# Loop Guide

This guide is loaded fresh on each `/review-doc-loop` or `/exam-loop` invocation to prevent instruction drift. Do NOT treat prior conversation as authoritative for loop semantics -- always re-read this guide on every tick wake per the echo's `Continue per review-loop-guide Continuation` pointer.

Scope: loop mechanics only. Per-round execution delegates to the existing guides:

- Review side: `review-doc-run-guide.md` Phase 1-3.
- Exam side: `exam-guide.md` Review Mode per-round flow.

The per-round guides are treated as libraries the loop wraps externally; they are NOT modified by this feature.

---

## Tuning

All tuning constants live in this single section -- edit one place to change cadence, idle tolerance, or round bound.

```
POLL_INTERVAL_SECONDS = 240   # 4 minutes; tweak to change tick cadence
MAX_IDLE_TICKS = 4            # 4 ticks without counterpart progress triggers idle termination
MAX_ROUNDS = 20               # upper bound on N; protects against typo-driven runaway
DEFAULT_REVIEW_ROUNDS = 1     # used when N is omitted on /review-doc-loop
DEFAULT_EXAM_ROUNDS = 2       # used when N is omitted on /exam-loop
```

The two default-N constants are asymmetric by design: the default workflow is exam-led (critic-sandwich `E1 -> R1 -> E2`), so `/exam-loop` runs 2 rounds by default (initial critique + verification) while `/review-doc-loop` runs 1 round (the thorough pass between them). Either constant can be overridden at invocation time by passing an explicit N.

These constants render back into echoes and error messages as literal values (for example, the `N must be between 1 and 20` error embeds the rendered value of `MAX_ROUNDS`, and idle-timer echoes embed `MAX_IDLE_TICKS` in the `idle X/<MAX_IDLE_TICKS>` denominator). If you change a constant here, both the error text and the echo denominators shift accordingly with no other edits needed.

---

## Argument Parsing

Both loop commands share the same positional shape:

```
/review-doc-loop <doc-path> [N] [--first | --follow] [notes]
/exam-loop <doc-path> [N] [--first | --follow] [notes]
```

The command body does NOT validate arguments. All parsing happens here, in the loop guide, on every tick wake (because the guide is re-read each iteration per the drift-prevention preamble).

### Seven-step tokenize/parse contract

1. Tokenize the arguments string on whitespace. No flag-aware positional parse -- just split.
2. First token -> `doc_path` (required). If missing, error with usage (`doc_path is required`).
3. Second token -> `N` (optional; side-aware default -- `DEFAULT_REVIEW_ROUNDS = 1` on `/review-doc-loop`, `DEFAULT_EXAM_ROUNDS = 2` on `/exam-loop`). Resolution rules, in order (let `DEFAULT_N` bind to the side-appropriate constant):
   a. If the second token is missing OR begins with `--` (it's a flag, not a number), set `N = DEFAULT_N` and leave the token in the stream for flag scanning in steps 4-5.
   b. Else if the second token parses as an integer in `[1, MAX_ROUNDS]`, that's `N`. Consume the token.
   c. Else if the second token parses as an integer OUTSIDE `[1, MAX_ROUNDS]` (zero, negative, or > 20), error with `N must be between 1 and 20` (the `20` is the rendered value of `MAX_ROUNDS` from the Tuning subsection above).
   d. Else the second token is a non-flag non-integer (e.g. a typo like `twoo` or the doc author's free-form notes starting in the second position). Set `N = DEFAULT_N` and leave the token in the stream; it falls through to `notes` in step 7.
4. Scan remaining tokens for the literal flag `--first`. If one or more occurrences are present, set `first_flag = true` and remove ALL occurrences from the stream. Duplicates are ignored (treated as one).
5. Scan remaining tokens for the literal flag `--follow`. If one or more occurrences are present, set `follow_flag = true` and remove ALL occurrences from the stream. Duplicates are ignored.
6. If both `first_flag` and `follow_flag` are true -> error with usage `--first and --follow are mutually exclusive on the same command`. Do NOT silently pick one.
7. Everything left is free-form `notes`, joined with spaces. Unknown flags that are not `--first` or `--follow` are passed through as notes (not errors).

### Semantics

- **`N` is additive**. It counts rounds RUN BY THIS INVOCATION, not a cap on total rounds logged. Captured at Initial entry as `target_rounds = N`. Used alongside `entry_r_done` / `entry_e_done` (completed-row counts captured from the doc at entry) to compute `rounds_done = current_done - entry_done` on every tick. `N = 1` against a doc with R3/E3 Applied runs R4 only (review side) or E4 only (exam side). Only rows whose Status is `Applied` or `Clean` count -- a `Pending` row represents an in-flight round that has not yet been consumed by this invocation's round budget.
- **`N` has asymmetric defaults** when omitted: `DEFAULT_REVIEW_ROUNDS = 1` on `/review-doc-loop`, `DEFAULT_EXAM_ROUNDS = 2` on `/exam-loop`. This encodes the default exam-led workflow as a critic-sandwich (E1 -> R1 -> E2): exam bookends one thorough review pass.
- **`--first`** forces this side to `leader`, overriding the default.
- **`--follow`** forces this side to `follower`, overriding the default.
- **Default role by side**: `/exam-loop` defaults to `leader`; `/review-doc-loop` defaults to `follower`. The exam-led default matches the "critic leads, review addresses, critic verifies" cadence.
- **Duplicate-flag handling**: `--first --first` is treated as a single `--first`. Same for `--follow --follow`. Mixing `--first --follow` (in any order, any number of duplicates) is still a mutual-exclusion error.
- **Unknown flags** pass through as notes (no error).

### Examples

```
# Default workflow -- exam leads (N=2), review follows (N=1). Critic-sandwich: E1 -> R1 -> E2.
/exam-loop docs/foo.md 2                             -> doc=docs/foo.md, N=2, no flag, exam=leader (default)
/review-doc-loop docs/foo.md 1                       -> doc=docs/foo.md, N=1, no flag, review=follower (default)

# Resume case -- just rerun with the number of additional rounds
/exam-loop docs/foo.md 1                             -> 1 more round (resume), exam=leader
/review-doc-loop docs/foo.md 1                       -> 1 more round (resume), review=follower

# Review-first workflow -- COORDINATED PAIR. Both flags required.
/review-doc-loop docs/foo.md 2 --first               -> 2 additive rounds, review=leader
/exam-loop docs/foo.md 2 --follow                    -> 2 additive rounds, exam=follower

# No-op flags (for symmetry; accepted without error)
/exam-loop docs/foo.md 2 --first                     -> exam=leader (same as default)
/review-doc-loop docs/foo.md 1 --follow              -> review=follower (same as default)

# Default N (omit the number; side-aware defaults apply)
/exam-loop docs/foo.md                               -> doc=docs/foo.md, N=2 (DEFAULT_EXAM_ROUNDS), exam=leader
/exam-loop docs/foo.md --first                       -> doc=docs/foo.md, N=2 (DEFAULT_EXAM_ROUNDS), exam=leader (no-op flag)
/review-doc-loop docs/foo.md                         -> doc=docs/foo.md, N=1 (DEFAULT_REVIEW_ROUNDS), review=follower
/review-doc-loop docs/foo.md --first                 -> doc=docs/foo.md, N=1 (DEFAULT_REVIEW_ROUNDS), review=leader

# With notes
/exam-loop docs/foo.md 3 check the gate arithmetic
    -> doc=docs/foo.md, N=3, no flag, notes="check the gate arithmetic"
/review-doc-loop docs/foo.md 3 focus on the coordination protocol
    -> doc=docs/foo.md, N=3, no flag, notes="focus on the coordination protocol"

# Error cases
/exam-loop docs/foo.md 0                             -> error: N must be between 1 and 20
/review-doc-loop docs/foo.md 21                      -> error: N must be between 1 and 20
/review-doc-loop docs/foo.md 2 --first --follow      -> error: --first and --follow are mutually exclusive on the same command
/review-doc-loop docs/foo.md --auto                  -> doc=docs/foo.md, N=1 (DEFAULT_REVIEW_ROUNDS), notes="--auto" (--auto is NOT a recognized flag on loop commands; it passes through silently as notes)
```

### Edge cases

- **Duplicate `--first`**: ignored; treated as one. Same for duplicate `--follow`.
- **Duplicate `--first` + `--follow`**: still a mutual-exclusion error.
- **`--auto` on a loop command**: not a recognized flag. Since the loop is always auto-apply (see Fix-application under the loop), there is no user-facing `--auto` flag. Per step 3a of the parser contract, any second token beginning with `--` triggers the side-aware `N = DEFAULT_N` default and remains in the stream for flag scanning. `--auto` is not matched by steps 4 (`--first`) or 5 (`--follow`), so it falls through to notes in step 7. Behavior: `/<cmd> doc --auto` runs with the side-aware default N (2 for exam, 1 for review) and notes="--auto" -- no error, but also no auto-apply override (since the loop already applies fixes by convention).

### No-op flags

`--first` on `/exam-loop` and `--follow` on `/review-doc-loop` are accepted without error for symmetry, even though each matches the side's default role. Users don't have to remember which command accepts which flag.

---

## Role Assignment

Each side has a default role. Flags override. Role is a pure function of each side's OWN flags -- the two sessions run independently and cannot read each other's flags. The user coordinates by passing matched flags on both sessions.

### Role derivation rule

Identical on both sides; only the default differs.

1. If `first_flag` is true -> `role = leader`.
2. Else if `follow_flag` is true -> `role = follower`.
3. Else -> side default: `follower` for review side, `leader` for exam side.

### Role matrix

| Command | Flag | Resulting role |
|---------|------|----------------|
| `/exam-loop` | (none) | leader (default) |
| `/exam-loop` | `--first` | leader (same as default; accepted for symmetry) |
| `/exam-loop` | `--follow` | **follower** |
| `/exam-loop` | `--first --follow` | parser error |
| `/review-doc-loop` | (none) | follower (default) |
| `/review-doc-loop` | `--first` | **leader** |
| `/review-doc-loop` | `--follow` | follower (same as default; accepted for symmetry) |
| `/review-doc-loop` | `--first --follow` | parser error |

See design § Item #2: Role Assignment & Coordination Protocol for the derivation of this matrix.

### Coordinated usage

- **Default workflow (exam leads)**: `/exam-loop doc` in one session + `/review-doc-loop doc` in another. Neither side needs a flag. With both sides' default N (exam=2, review=1), the sequence is E1 -> R1 -> E2 (critic-sandwich). With larger N, the pattern continues as E1 -> R1 -> E2 -> R2 -> ... until either side's target is met.
- **Review-first workflow (review leads)**: `/review-doc-loop doc N --first` in one session + `/exam-loop doc N --follow` in another. BOTH flags are required.

The reason both flags are required for the review-first case: each session is an independent Claude Code main conversation. The exam session cannot read the review session's arguments. If the user passes `--first` to review but nothing to exam, exam falls back to its default leader role, both sides see their gates trivially satisfied, and both run round 1 in parallel on a fresh doc -- the interleaving is lost. This is the silent-degrade pitfall documented in the command files' Usage examples.

---

## Coordination Protocol

The Review Log table in `docs/<slug>-review.md` is the only coordination channel between the two sessions. Each tick wake re-reads the log, counts R and E rows, and decides whether to run or wait.

### Counter measurement

On each tick, re-read `docs/<slug>-review.md` with the Read tool and extract six counts. Two come from the Review Log; four come from the summary tables. All six feed the idle-reset signature; only `rD` / `eD` gate round progression.

**Completed Review Log counts (`rD`, `eD`)** -- used by BOTH gate and idle reset. Scoped to the `## Review Log` section (between the heading and the next `---` or `##`). Only count rows whose Status column (the last pipe-separated cell) is `Applied` or `Clean`:

- `^\|\s*R\d+\s*\|.*\|\s*(Applied|Clean)\b` -- matches completed R rows
- `^\|\s*E\d+\s*\|.*\|\s*(Applied|Clean)\b` -- matches completed E rows

The greedy `.*` between the first pipe and the last spans the intermediate columns (Timestamp, Command, Mode, Issues). The `\bApplied\b` / `\bClean\b` word-boundary anchor matches both bare `Clean` and `Applied (X of Y)` forms. Rows with Status `Pending` or any other value DO NOT count toward the completed counters.

**Total Review Log counts (`rT`, `eT`)** -- used by idle reset ONLY. Same scope as above, Status-agnostic:

- `^\|\s*R\d+\s*\|` -- matches any R row
- `^\|\s*E\d+\s*\|` -- matches any E row

These capture the Phase 3.3 signal -- a new Pending row appearing before it flips to Applied at Phase 3.5. Scoping the greps to the Review Log section is defense-in-depth; today's templates never put `R\d+`/`E\d+` tokens in the first column of other tables.

**Summary-table step counts (`rS`, `eS`)** -- used by idle reset ONLY. Scoped to ALL tables in the doc whose header row contains an `R\d+` or `E\d+` cell. In the current tracking template this covers the Item/Step/Task Summary and the Holistic Summary; the Review Log is excluded because its header cells are `#`, `Timestamp`, etc. -- not `R\d+`.

For each such summary table, perform per-table parsing:

1. Parse the header row into pipe-separated cells. Record column indices whose (trimmed) content matches `R\d+` (R-columns) and those matching `E\d+` (E-columns).
2. Add the R-column count to `rS`; add the E-column count to `eS`. This captures the Phase 1 signal -- a new R2 or E2 column is added to each summary-table header before any cell is populated.
3. For each data row (pipe-separated, skipping the header row and any `|---|` separator): for each R-column index, if the trimmed cell content is non-empty and NOT the literal `...`, increment `rS`. Repeat for E-column indices -> `eS`.

Step 3 captures the Phase 2 signal -- individual cells flipping from `...` to `✅` / `1 HIGH 2 MED` as subagents complete, giving per-item idle-reset granularity throughout the round's multi-turn window. Without this, an expanding-Phase-2 round that exceeds `MAX_IDLE_TICKS * POLL_INTERVAL_SECONDS` wall-clock would idle out the follower even though the counterpart is visibly working.

If the doc does not exist, or has no Review Log section, or has no summary table with R/E headers, the corresponding counters read 0. Treat the doc as fresh. The first round appends/creates everything.

Note: the Review Log may also contain user-refinement rows with a `U\d+` prefix (e.g., `U1`, `U2`) representing user-driven pivots between automated rounds. These are ignored by ALL six counters and do not affect gate math or idle-reset semantics because they represent neither side's round.

### Why done vs total+step (split counters)

- **Gate uses done-only (`rD`/`eD`)**: a `Pending` row represents an in-flight round -- the leader is mid-phase, findings are not yet applied, and the follower cannot yet read a valid counterpart state. Gating on `Pending` or on summary-table cell fills would let the follower race ahead before the leader finishes.
- **Idle reset uses all six counters**: any of `rD`, `eD`, `rT`, `eT`, `rS`, `eS` changing between ticks IS progress signal -- the counterpart is visibly working somewhere (summary column added, cell flipped, Pending row landed, Status moved to Applied). The follower should acknowledge it and reset `idle_ticks = 0`, even while the gate correctly keeps it waiting for `rD`/`eD` to advance.

This split is what lets Gate and Idle reach different decisions on the same tick: "the gate is NOT satisfied yet (R_k is still Pending or mid-Phase-2), BUT the counterpart is alive (sig changed since last tick)."

Timing map of signals visible to the follower during one leader round (review side):

| Leader phase | Summary table | Review Log | Counter that advances |
|--------------|---------------|------------|-----------------------|
| Phase 1 (setup) | R_k column added, cells `...` | (unchanged) | `rS` (+1 per summary table, typically +2) |
| Phase 2 per-item | cells flip `...` -> content | (unchanged) | `rS` (+1 per subagent completion) |
| Phase 3.3 (set log entry) | (stable) | R_k Pending row added | `rT` (+1) |
| Phase 3.5 (fix applied) | (stable) | R_k Status -> Applied | `rD` (+1); `rT` unchanged |

Every row except the last is invisible to a Review-Log-only follower; `rS`/`eS` and `rT`/`eT` exist precisely to surface them.

### Invocation-relative counts

All gate math uses **invocation-relative** counts, not absolute counts. The invocation is the single `/review-doc-loop` or `/exam-loop` call the user made; `N = target_rounds` counts rounds run BY THIS INVOCATION.

- `this_own = own_done - entry_own_done` (own-side progress since Initial entry)
- `this_counterpart = counterpart_done - entry_counterpart_done` (counterpart progress since Initial entry)
- `k = this_own + 1` (invocation-relative round ordinal: the next round this invocation will run; starts at 1)

Why invocation-relative: if the doc already has `E1 Applied` pre-existing (e.g., from a prior `/exam` pass before the loop was invoked), a leader-absolute gate would see `e_count = 1` and trivially pass the gate for `k = 2`, running R1 and R2 back-to-back without waiting for a fresh E2. Invocation-relative math sees `this_e = 0` at entry, so the gate for `k = 2` requires a NEW E to appear.

### Leader gate

```
Leader gate for round k: this_counterpart >= k - 1
```

On invocation round 1 this is `0 >= 0`, trivially satisfied.

### Follower gate

```
Follower gate for round k: this_counterpart >= k
```

On invocation round 1 this is `0 >= 1`, NOT satisfied -- follower waits for leader's round 1.

### Decision rules (symmetric, keyed by role)

**Leader role** (whichever side resolved to `role = leader`):

- `this_own = own_done - entry_own_done`; `this_counterpart = counterpart_done - entry_counterpart_done`; `k_next = this_own + 1`.
- Gate: `this_counterpart >= k_next - 1`.
- Gate satisfied -> run the round (review: Phase 1-3 from `review-doc-run-guide.md`; exam: single-turn exam flow from `exam-guide.md` Review Mode).
- Gate not satisfied -> arm the timer, idle.

**Follower role** (whichever side resolved to `role = follower`):

- `this_own = own_done - entry_own_done`; `this_counterpart = counterpart_done - entry_counterpart_done`; `k_next = this_own + 1`.
- Gate: `this_counterpart >= k_next`.
- Gate satisfied -> run the round.
- Gate not satisfied -> arm the timer, idle.

### Invariants keyed on resolved roles (invocation-relative)

- **When resolved roles are review=follower, exam=leader** (default workflow, plus `--first` on exam and `--follow` on review as no-op variants): `this_r <= this_e` at all times. R cannot lead E in this invocation because R_k's follower gate requires the invocation's E_k to exist.
- **When resolved roles are review=leader, exam=follower** (review-first workflow: `--first` on `/review-doc-loop` AND `--follow` on `/exam-loop` -- both flags are role-changing, so there are no paired-no-op variants for this case): `this_e <= this_r` at all times. E cannot lead R in this invocation because E_k's follower gate requires the invocation's R_k to exist.

Both invariants are keyed on resolved roles, not literal flags, and hold only over the invocation-relative deltas. Absolute counts may already be imbalanced at entry (e.g., doc has `E1 Applied` pre-existing before review-leader is invoked) and that is fine -- the entry counts absorb the imbalance.

### Degenerate cases (documented, not defended against)

- **`--first` on both sides**: both sides are leader; rounds may run in parallel without proper interleaving. The "R sees E's findings" property is lost. Don't do this.
- **`--follow` on both sides**: both sides wait forever for the counterpart to log round 1. Both exit via idle termination after `MAX_IDLE_TICKS * POLL_INTERVAL_SECONDS` of wall-clock time (~16 min at defaults). On a fresh doc, `counterpart_count == 0 AND role == follower` means both sides exit via Condition #3 (`counterpart never started, stopping`). Harmless but wastes wall-clock.
- **Mismatched flags** (e.g., `--first` on exam alone with nothing on review): review falls back to default leader, both sides are leader, same as "both `--first`". Silent degrade.
- **Only one side started** (e.g., `/review-doc-loop doc N` alone, `/exam-loop` never invoked): the started side runs its first round (if leader) or waits (if follower), then idles for `MAX_IDLE_TICKS` ticks and exits via Condition #3.

### `target_rounds` additive semantics

`target_rounds = N` is additive -- counts rounds run by the current invocation starting at `rounds_done = 0`, regardless of what already exists in the Review Log. A resumed `/review-doc-loop doc 2` against a doc that already contains R5/E5 Applied will run R6 + R7 (or E6 + E7 on the exam side) and exit, not cap at R2 total. `entry_r_done` / `entry_e_done` are captured at Initial entry and carried forward in each iteration's TIMER echo string so the loop can compute `rounds_done = current_done - entry_done` on every tick wake. This is what makes resume free -- no special "resume mode" is needed.

### Resume correctness trace

On a doc with R3/E3 Applied, re-running the loop on either side with `N = 1` (invocation-relative gate math):

- **Review-leader side**: entry_r=3, entry_e=3. `this_r=0, this_e=0, k=1`. Leader gate checks `this_e >= k - 1` = `0 >= 0` (satisfied). Runs R4 (label R4 because r_total+1 = 4 -- the 4th R row in the absolute doc). After R4: `this_r=1, this_e=0, rounds_done=1 >= target_rounds=1` -> exit. No round is re-executed; Review Log grows by exactly one R row.
- **Exam-follower side**: entry_r=3, entry_e=3. `this_r=0, this_e=0, k=1`. Follower gate checks `this_r >= k` = `0 >= 1` (NOT satisfied) -- wait one tick, sees R4 land, `this_r=1`, gate becomes `1 >= 1` (satisfied). Runs E4. After E4: `this_e=1, rounds_done=1 >= 1` -> exit.
- **Exam-first resume variant** (`--first` on exam, `--follow` on review): entry_r=3, entry_e=3 on both sides. Exam-as-leader at entry: `this_e=0, k=1`. Leader gate `this_r >= 0` satisfied. Runs E4, exits. Review-as-follower at entry: `this_r=0, this_e=0, k=1`. Follower gate `this_e >= 1` is `0 >= 1` at entry -- waits -- sees E4 land, `this_e=1`, gate `1 >= 1` satisfied. Runs R4, exits.

A resumed `/review-doc-loop doc 2` paired with `/exam-loop doc 2` against a doc with R5/E5 Applied will run R6, E6, R7, E7 interleaved (not R6+R7 then E6+E7 independently) -- each side terminates after `rounds_done = 2`.

### Pre-existing-imbalance trace (the bug scenario)

On a doc with `E1 Applied` only (no R rows yet) from a prior `/exam` pass, running `/review-doc-loop 2` paired with `/exam-loop 2` with N=2:

- entry_r=0, entry_e=1 (review sees 0 R and 1 completed E at entry). entry on exam side is identical.

**Review-leader side**:
- Entry: `this_r=0, this_e=0, k=1`. Leader gate `this_e >= 0` TRUE. Runs R1. After: `this_r=1, this_e=0`.
- Tick: `k=2`. Leader gate `this_e >= 1` is `0 >= 1` FALSE. Wait for E2.
- E2 lands. Tick: `this_e=1, k=2, 1 >= 1` TRUE. Runs R2. After: `this_r=2, rounds_done=2 >= 2` -> exit.

**Exam-follower side**:
- Entry: `this_r=0, this_e=0, k=1`. Follower gate `this_r >= 1` is `0 >= 1` FALSE. Wait for R1.
- R1 lands. Tick: `this_r=1, k=1, 1 >= 1` TRUE. Runs E2 (label E2 because e_total+1 = 2 -- the 2nd E row in the absolute doc, since E1 pre-existed). After: `this_e=1, this_r=1, k=2`.
- Follower gate `this_r >= 2` is `1 >= 2` FALSE. Wait for R2.
- R2 lands. Tick: `this_r=2, k=2, 2 >= 2` TRUE. Runs E3. After: `this_e=2, rounds_done=2 >= 2` -> exit.

Final doc state: E1 (pre-existing) + R1 + E2 + R2 + E3. Review logged R1, R2 (2 rounds); exam logged E2, E3 (2 rounds). Pre-existing E1 is outside the invocation-relative budget and is never re-processed.

---

## Tick-Driven Loop Structure

Each side runs the same tick-driven loop. The loop uses a background timer (`Bash(run_in_background: true, command: "sleep 240 && echo '...'")`) identical in mechanics to `/monitor`, with echo-encoded state so compaction during idle sleep cannot corrupt loop memory.

### Per-iteration state (carried in the echo suffix)

All three tuning constants (`POLL_INTERVAL_SECONDS`, `MAX_IDLE_TICKS`, `MAX_ROUNDS`) live in the Tuning subsection above -- NOT in the echo. They are re-read from the guide on each tick wake.

Per-iteration state rides in the echo's trailing `(...)` block:

```
(idle X/<MAX_IDLE_TICKS>, last_sig=rD,eD,rT,eT,rS,eS, entry=r0,e0, target=N, role=leader|follower)
```

Fields:

- `target_rounds` -- from `target=N` in the suffix
- `last_sig` -- from `last_sig=rD,eD,rT,eT,rS,eS`; the 6-tuple `(r_done, e_done, r_total, e_total, r_step, e_step)` observed at the previous tick
- `idle_ticks` -- from `idle X/<MAX_IDLE_TICKS>`; stall accumulator
- `entry_r_done` -- from `entry=r0,e0`, first element; completed R count captured at Initial entry, never updated
- `entry_e_done` -- from `entry=r0,e0`, second element; completed E count captured at Initial entry, never updated
- `role` -- from `role=leader|follower`; resolved at Initial entry from `--first`, `--follow`, and the side default

Derived fresh on each tick:

- `current_sig = (r_done, e_done, r_total, e_total, r_step, e_step)` recomputed from the doc on every read per the Counter measurement rules
- `this_own = own_done - entry_own_done` (review side: `r_done - r0`; exam side: `e_done - e0`)
- `this_counterpart = counterpart_done - entry_counterpart_done` (review side: `e_done - e0`; exam side: `r_done - r0`)
- `rounds_done = this_own`
- `gate = (this_counterpart >= k - 1)` if `role == leader`, `(this_counterpart >= k)` if `role == follower`, where `k = this_own + 1`

**Sig vs gate** (load-bearing split):
- Any of the 6 sig elements changing between ticks -> reset `idle_ticks = 0`. This includes `rT`/`eT` incrementing (Pending row appeared) AND `rS`/`eS` incrementing (summary column added OR individual cell flipped from `...`), in both cases without `rD`/`eD` moving. All of these are counterpart-alive signals.
- The gate reads ONLY `rD` and `eD`. Neither a `Pending` Review Log row nor a summary-table cell fill satisfies the gate -- a round only opens the gate once its Review Log status flips to `Applied` / `Clean`.

### Echo format

Armed at the end of every iteration that sleeps. The `idle X/Y` denominator renders the current value of `MAX_IDLE_TICKS` from the Tuning subsection.

Review side:

```
sleep 240 && echo 'Running /review-doc-loop <doc> <N> [--first | --follow] -- <narrative>. (idle X/<MAX_IDLE_TICKS>, last_sig=rD,eD,rT,eT,rS,eS, entry=r0,e0, target=N, role=leader|follower). Continue per review-loop-guide Continuation.'
```

Exam side (symmetric):

```
sleep 240 && echo 'Running /exam-loop <doc> <N> [--first | --follow] -- <narrative>. (idle X/<MAX_IDLE_TICKS>, last_sig=rD,eD,rT,eT,rS,eS, entry=r0,e0, target=N, role=leader|follower). Continue per review-loop-guide Continuation.'
```

### Concrete echo format examples

Round counts are illustrative. `rS`/`eS` values include summary-table column headers + populated non-`...` cells across the Item/Step/Task Summary and Holistic Summary tables combined. Exact totals depend on doc shape; the examples below use an arbitrary 10-item doc with 7-concern Holistic Summary -> 17 cells per completed round, +2 headers per round.

**Review-leader default, mid-loop, after R1 completes (Applied), waiting for E1** (10-item doc, 7-concern holistic; after R1 fully applied: 2 R headers accounted for + 17 R cells populated = `rS=19`):

```
sleep 240 && echo 'Running /review-doc-loop docs/foo.md 2 -- R1 done, waiting for E1 or next tick (idle 0/4, last_sig=1,0,1,0,19,0, entry=0,0, target=2, role=leader). Continue per review-loop-guide Continuation.'
```

**Exam-leader `--first`, mid-loop, after E1 completes (Applied), waiting for R1** (same 10+7 doc shape):

```
sleep 240 && echo 'Running /exam-loop docs/foo.md 2 --first -- E1 done, waiting for R1 or next tick (idle 0/4, last_sig=0,1,0,1,0,19, entry=0,0, target=2, role=leader). Continue per review-loop-guide Continuation.'
```

**Review-follower `--follow`, Initial entry on fresh doc, waiting for E1 before running R1**:

```
sleep 240 && echo 'Running /review-doc-loop docs/foo.md 2 --follow -- waiting for E1 or next tick (idle 0/4, last_sig=0,0,0,0,0,0, entry=0,0, target=2, role=follower). Continue per review-loop-guide Continuation.'
```

**Exam-follower default, Initial entry on fresh doc, waiting for R1 before running E1**:

```
sleep 240 && echo 'Running /exam-loop docs/foo.md 2 -- waiting for R1 or next tick (idle 0/4, last_sig=0,0,0,0,0,0, entry=0,0, target=2, role=follower). Continue per review-loop-guide Continuation.'
```

**Exam-follower default, mid-tick after leader opened R1 (Phase 1 complete, R1 column added to both summary tables with all `...` cells -- no Review Log row yet)**:

```
sleep 240 && echo 'Running /exam-loop docs/foo.md 2 -- R1 Phase 1 started (summary columns added), gate not satisfied, idle reset (idle 0/4, last_sig=0,0,0,0,2,0, entry=0,0, target=2, role=follower). Continue per review-loop-guide Continuation.'
```

**Exam-follower default, mid-tick after 5 of 10 items' R1 cells populated during Phase 2 (still no Review Log row)**:

```
sleep 240 && echo 'Running /exam-loop docs/foo.md 2 -- R1 Phase 2 in progress (5/10 items done), gate not satisfied, idle reset (idle 0/4, last_sig=0,0,0,0,7,0, entry=0,0, target=2, role=follower). Continue per review-loop-guide Continuation.'
```

**Exam-follower default, mid-tick after leader wrote R1 Pending Review Log row at Phase 3.3 (round not yet Applied)**:

```
sleep 240 && echo 'Running /exam-loop docs/foo.md 2 -- R1 Phase 3.3 Pending logged, gate not satisfied, idle reset (idle 0/4, last_sig=0,0,1,0,19,0, entry=0,0, target=2, role=follower). Continue per review-loop-guide Continuation.'
```

The last three examples illustrate the load-bearing sig/gate split: `rS` then `rT` advance as the leader progresses through Phase 1 -> Phase 2 -> Phase 3.3, while `rD` stays at 0 (not yet Applied). Gate for exam-follower `this_r >= k` is `0 >= 1` FALSE at every one of these ticks -- follower keeps waiting. But `idle_ticks` resets to 0 at each tick because the sig changed. The follower acknowledges counterpart-alive progress throughout the round without opening the gate prematurely.

### Parser rule

Tool-result text beginning with `Running /review-doc-loop ` or `Running /exam-loop ` WITHOUT the `[sentinel]` marker immediately after the command name is a **loop wake** -- proceed with tick-wake logic. Extract all state fields from the suffix with this regex:

```
\(idle (\d+)/\d+, last_sig=(\d+),(\d+),(\d+),(\d+),(\d+),(\d+), entry=(\d+),(\d+), target=(\d+), role=(leader|follower)\)
```

Capture groups (in order): `idle_ticks`, `rD` (last_sig completed R), `eD` (last_sig completed E), `rT` (last_sig total R), `eT` (last_sig total E), `rS` (last_sig R step-count), `eS` (last_sig E step-count), `entry_r_done`, `entry_e_done`, `target_rounds`, `role`.

The `\d+` in the idle-tick denominator accommodates edits to `MAX_IDLE_TICKS` in the Tuning subsection without breaking the parser. The prose narrative (everything between `-- ` and the opening `(`) is free-form and ignored by the parser. Everything after the closing `)` is the guide pointer.

Tool-result text beginning with `Running /review-doc-loop [sentinel] ` is a **mid-round breadcrumb** -- IGNORE as wake trigger. The agent is already mid-round, not re-entering the loop.

**The `[sentinel]` marker is a literal 10-character string** (left bracket, `s`, `e`, `n`, `t`, `i`, `n`, `e`, `l`, right bracket), NOT a regex character class. Use literal-prefix string matching for this check, not regex. A naive regex transliteration of `[sentinel]` would match any single character from the set `{s,e,n,t,i,l}`, which is wrong.

### Prefix -> side mapping

Side (from prefix) and role (from the `role=` suffix field) are independent. Always read `role` from the suffix, never infer from the prefix.

- Prefix `Running /review-doc-loop ` -> **review side**. `own_done = r_done`, `counterpart_done = e_done`, `this_own = r_done - r0`, `this_counterpart = e_done - e0`, `k = this_own + 1`, `rounds_done = this_own`.
- Prefix `Running /exam-loop ` -> **exam side**. `own_done = e_done`, `counterpart_done = r_done`, `this_own = e_done - e0`, `this_counterpart = r_done - r0`, `k = this_own + 1`, `rounds_done = this_own`.
- No other prefix is a valid loop wake. A tool result that does not match one of these two prefixes is not a TIMER echo -- ignore it for loop state purposes.

**Side does not imply role.** `/review-doc-loop` can run as leader OR follower depending on the `role=` suffix field; same for `/exam-loop`. The prefix only tells you which counter is `own_done` vs `counterpart_done`.

### Role -> gate formula mapping

- `role=leader` -> gate is `this_counterpart >= k - 1`.
- `role=follower` -> gate is `this_counterpart >= k`.

Side and role are independent. The prefix determines which side you are (and therefore which counter is `own_done`); the `role=` suffix field determines which gate formula to apply. Either side can be either role: `/review-doc-loop` with `role=follower` (exam-first workflow) uses `this_e >= k`; `/exam-loop` with `role=leader` (exam-first workflow) uses `this_r >= k - 1`. This decoupling is what lets `--first` / `--follow` on either side flow through the same loop code without branching on side.

### Doc path shell-quoting constraint

The echo is generated by `Bash(run_in_background: true, command: "sleep N && echo '...'")` where the doc path is interpolated inside single quotes. Doc paths containing single quotes, backticks, dollar signs, or backslashes will break the bash command. In practice, review docs live under `docs/` with conventional agent-generated names, so this is extremely unlikely. Enforced by convention, not runtime validation. A user who hits this constraint can rename the doc or fall back to single-pass `--auto`.

### Why the echo is compaction-immune

The echo string becomes a Bash tool-result message that arrives AFTER any compaction that may have fired during the `sleep`. Compaction summarizes prior conversation; it cannot affect messages that haven't arrived yet. The agent's memory of the loop may be compacted into a one-line summary, but the fresh TIMER echo plus the guide pointer are sufficient for re-entry.

What is NOT in the echo: the `POLL_INTERVAL_SECONDS`, `MAX_IDLE_TICKS`, and `MAX_ROUNDS` constants. They live in the Tuning subsection, re-read on each tick wake per the guide pointer. Keeping them out of the echo lets users change cadence by editing one line in the guide without affecting in-flight runs that would otherwise carry a stale value.

---

## Mid-round compaction recovery (review side only)

The echo protects against compaction during the idle `sleep`, but on the review side when the gate is satisfied the round runs via Phase 1 (setup) followed by Phase 2 (background spawning) -> end turn -> Phase 3.1 (notifications, multi-turn) -> Phases 3.2-3.6 -> Continuation logic. No idle timer is armed until the end of that sequence, and the verbose Phase 3.1 notification-processing is the most token-heavy part of a round. If auto-compaction fires mid-round the agent could lose `target_rounds`, `entry_r_done`, `entry_e_done`, and `role` -- plus the fact it is inside a loop at all.

To mitigate this (best-effort, not guaranteed), arm a **pre-round sentinel Bash call in the SAME single message as Phase 2's Task spawns**. The sentinel is one of the `run_in_background: true` tool calls emitted in the Phase 2 spawn message, alongside the item-reviewer Task calls, the holistic-reviewer Task call, and the Phase 2 brief status text that ends the turn. The sentinel's echo lands as a `tool_result` in the next turn alongside any Task notifications that have arrived.

### Phase 2 single-message override

The deployed `review-doc-run-guide.md` § Phase 2: Background Spawning (Subagents) at `review-doc-run-guide.md:150` mandates "Spawn ALL agents in a SINGLE message with `run_in_background: true` -- one Task tool call per item agent plus one for the holistic agent, all in one response." Under the loop, this mandate is **RELAXED** to permit the pre-round sentinel `Bash` call alongside the Task calls in the same message.

Explicitly: under the loop, Phase 2's single-message spawn is augmented to include one additional `run_in_background: true` Bash tool call (the pre-round sentinel) alongside the Task calls. The per-round guide's "one Task call per item agent plus one for the holistic agent" mandate is unchanged -- the loop adds a Bash call, does not remove or alter Task calls. The composite message still ends the turn per Phase 2's end-of-turn rule.

The heading § Phase 2: Background Spawning (Subagents) acts as the drift detector if `review-doc-run-guide.md:150` is ever shifted -- rediscover the single-message spawn mandate by grepping the heading. This override documentation is what prevents an executor (strictly reading line 150) from refusing to add the sentinel.

### Pre-round sentinel format

The sentinel uses a **distinct prefix** (`Running /review-doc-loop [sentinel] `) so the Parser rule can tell it apart from an idle-timer echo:

```
sleep 1 && echo 'Running /review-doc-loop [sentinel] <doc> <N> [--first | --follow] -- R<k> in progress, Phase 1 (setup) complete and Phase 2 (background spawning) underway (idle 0/<MAX_IDLE_TICKS>, last_sig=rD,eD,rT,eT,rS,eS, entry=r0,e0, target=N, role=leader|follower). Continue per review-loop-guide Continuation after Phase 3.6.'
```

The `R<k>` token is a meta-placeholder for the concrete round number being launched (e.g., `R6` when launching the sixth round) -- substitute before emitting. The sentinel shell-quoting constraint is identical to the idle-timer echo.

### Sentinel-vs-tick-wake parser distinction

The sentinel is a transcript-side breadcrumb, NOT a wake event. When its tool_result arrives, the Parser rule recognizes the `[sentinel]` marker in the prefix (via literal-prefix string matching -- see the Parser rule's 10-character literal string note above) and IGNORES it as an active trigger -- the agent is already mid-round, not re-entering the loop. The sentinel's purpose is strictly to place a recoverable state block into the transcript for later scanning (via Grep or manual inspection) if compaction fires during Phase 3.1.

This is distinct from the review-log "sentinel values" prohibited by the "no sentinel values" rule in Notes for the guide author below -- that rule targets the review doc; transcript-side pre-round sentinel echoes are permitted and load-bearing.

### Compaction-tolerance, not immunity

The sentinel's echo arrives as a fresh tool result at the start of Phase 3.1, then becomes ordinary historical content that a summarizer can and will process during subsequent compaction. It is therefore **compaction-tolerant** under typical summarizer behavior but NOT compaction-immune by construction (unlike the idle-timer echo, which is still pending when compaction fires and postdates the summary).

If a summarizer elides the sentinel echo during Phase 3.1, the post-compaction agent cannot recover loop state and MUST abort cleanly with an explicit error like `mid-round compaction erased loop state; aborting loop -- re-run the loop command to resume from current doc state`.

### Post-compaction recovery procedure

- **Post-compaction recovery (idle sleep)**: if a fresh loop-wake echo is received after auto-compaction during idle sleep, parse its suffix as normal -- the idle-timer echo is compaction-immune by construction because it was still pending when compaction fired.
- **Post-compaction recovery (review side, mid-round)**: if the review-side agent suspects compaction may have fired during Phase 2/3 processing and cannot recall its loop state, scan the transcript for the most recent `Running /review-doc-loop [sentinel] ` prefix and parse its suffix to recover `target`, `entry`, `role`. If no such sentinel is found in the transcript, abort the loop cleanly with the explicit error above -- do NOT guess at loop state from the review doc alone.

### Terminal silent-exit failure mode

The clean-abort path above assumes the post-compaction agent still recognizes it is inside a loop. If compaction erases BOTH the loop context (the "I'm in a loop" awareness established at Initial entry) AND the sentinel echo from the transcript, the agent reaches Phase 3.6 with no awareness of the loop at all. Phase 3.6 executes per the per-round guide, its Bash tool call completes, the turn ends normally, and no Continuation logic runs -- no next timer is armed and no error is printed. The loop silently exits. The user's only user-visible signal is the absence of subsequent rounds in the review doc.

This is the terminal failure mode of the compaction defense-in-depth chain: when every recovery mechanism fails, the loop disappears quietly rather than corrupting state. Acceptable because (a) it produces no data corruption, only early termination, and (b) the user can always re-run the loop command to resume from the current doc state.

The exam side does not need a sentinel because exam rounds are single-turn -- no multi-turn window exists for compaction to hit mid-round.

---

## Fix-application under the loop

Loop commands are **always auto-apply**. There is no user-facing `--auto` flag on the loop commands because the loop is meant to run unattended.

The mechanism is a **prose-convention branch override** in this guide, re-established on every tick wake (because this guide is re-read per the echo's `Continue per review-loop-guide Continuation` pointer). NOT literal flag injection -- there is no argument-passing mechanism between a loop command and a per-round guide, and no literal `--auto` token is passed between them.

### Loop-implicit-auto convention

- **Review side**: when the agent reads `review-doc-run-guide.md` inside a loop-driven round, the loop guide tells it to take the `--auto` branch of Phase 3.4 (auto-apply without prompting) even though the user did not pass `--auto` to the loop command. Phase 3.5 is a no-op in `--auto` mode per `review-doc-run-guide.md:347`. Phase 3.6 audio cue fires as normal.
- **Exam side**: same convention applied to `exam-guide.md` Applying Fixes -- the loop guide tells the agent to take the auto-apply branch. Update Review Doc Fix Status uses the same `Applied (X of Y)` path. Completion Notification fires as normal.
- **User-facing invocation**: the user does NOT pass `--auto` to the loop commands. Auto-apply is always on under the loop.

There is nothing to "inject"; there is only a branch-selection rule documented here and re-read each iteration. The override does not have to survive compaction on its own -- it is refreshed each iteration.

---

## Continuation-turn handoff (review side)

Phase 3.6 in `review-doc-run-guide.md` today ends with a single Bash invocation (portable `command -v` guarded `afplay` + `say`). When that Bash call completes, the current turn ends -- there is NO automatic "continuation turn" triggered by Phase 3.6. This is normally turn-end for the per-round flow.

**Inside a loop-driven round, Phase 3.6's Bash-call return is NOT the end of the turn.** The loop does NOT inject a hook into Phase 3.6 (the per-round guide remains textually untouched). Instead, this guide instructs the agent:

> When Phase 3.6's Bash call returns inside a loop-driven round, do NOT end the turn -- continue immediately with the Continuation logic (re-read doc, recompute state, arm next timer or exit).

This is the one place the loop explicitly re-frames how it wraps the per-round flow: normally Phase 3.6 is the end of the turn, but inside a loop it is followed by one more action in the same turn. No per-round guide modification is required -- the augmentation lives entirely in this guide's instructions.

The exam side does not need this handoff because exam rounds are single-turn -- there is no multi-turn Phase 2/3 window to re-emerge from.

---

## Initial entry

First iteration. Both sides execute the same outline; only the side default differs.

1. **Parse args** per Argument Parsing above. Determine `target_rounds = N`, `first_flag`, `follow_flag`. If both flags are true, error (parser should have prevented this).
2. **Read the review doc** (if any) and capture `entry_r_done`, `entry_e_done` -- the Applied/Clean-only counts. These are fixed for the whole invocation and used to compute `rounds_done = own_done - entry_own_done` on every subsequent tick wake. On a fresh doc both are 0; on a resumed run against a doc that already contains R5 Applied / E5 Applied they are `(5, 5)`. Pending rows at entry do NOT count toward entry_done -- they are in-flight rounds that will flip to Applied and be detected by the idle-sig comparison as progress.
3. **Derive role** from own flags per the Role Assignment derivation rule: `--first` -> leader, `--follow` -> follower, neither -> side default (review=follower, exam=leader).
4. **Set `last_sig = (r_done, e_done, r_total, e_total, r_step, e_step)`** (or `(0, 0, 0, 0, 0, 0)` on a missing doc / empty Review Log + no summary tables).
5. **Evaluate the gate** for round `k = this_own + 1` using the formula for `role` (leader: `this_counterpart >= k - 1`; follower: `this_counterpart >= k`), where `this_own = own_done - entry_own_done` and `this_counterpart = counterpart_done - entry_counterpart_done`.

### Review side, gate satisfied

Arm the pre-round sentinel Bash call (per the Pre-round sentinel format above) in the SAME single message as Phase 1 (setup) followed by Phase 2 (background spawning) Task spawns. This spawns item + holistic agents in the background and ends the current conversation turn. The loop is now dormant. Subsequent turns process agent notifications (Phase 3.1), elevation (Phase 3.2), write Review Log (Phase 3.3), apply fixes (Phase 3.4), update fix status (Phase 3.5), play completion notification (Phase 3.6).

Immediately after Phase 3.6's Bash result returns (same turn -- see Continuation-turn handoff above): re-read the doc for fresh `(r_done, e_done, r_total, e_total, r_step, e_step)`, refresh `last_sig = current_sig`, compute `rounds_done = r_done - entry_r_done`, print the canonical status line, then either (a) exit without arming a timer if `rounds_done >= target_rounds`, or (b) arm the echo-encoded timer with the freshly computed state. The echo's narrative reflects what just happened (`R1 done, waiting for E1 or next tick`); the suffix carries `idle=0/<MAX_IDLE_TICKS>`, `last_sig=rD,eD,rT,eT,rS,eS`, `entry=entry_r_done,entry_e_done`, `target=N`, `role=...`.

### Exam side, gate satisfied

No Phase 2 to compose with; the exam flow is single-turn per round. Run the round inline -- read cross-refs, deep-examine, write E_k (appends an Applied row to the Review Log since exam single-turn applies fixes in the same turn), apply fixes, update `last_sig = (r_done, e_done, r_total, e_total, r_step, e_step)` post-round all in the same turn. Then either exit if `rounds_done >= target_rounds` or arm the echo-encoded timer for the next iteration.

### Both sides, gate not satisfied

Print the canonical status line (`Waiting for <counterpart>_k (idle 0/<MAX_IDLE_TICKS>, next tick in 4m)`) and arm the echo-encoded timer carrying `idle=0/<MAX_IDLE_TICKS>`, `last_sig=rD,eD,rT,eT,rS,eS`, `entry=entry_r_done,entry_e_done`, `target=N`, `role=...`. End the turn.

### Postcondition

After Initial entry completes, the current conversation turn ends. No further tool calls are produced. The next turn is triggered by a TIMER notification (exam side, or review side awaiting the counterpart) or by an agent-completion notification (review side mid-round).

---

## On tick wake

Every subsequent iteration, fired by TIMER notification. Ten steps:

1. **Parse the incoming TIMER echo** per the Parser rule above. The tool result text begins with `Running /review-doc-loop ` (-> review side) or `Running /exam-loop ` (-> exam side). Extract all fields from the suffix: `idle_ticks`, `last_sig = (rD, eD, rT, eT, rS, eS)`, `entry = (r0, e0)` (completed-only counts at Initial entry), `target_rounds`, `role`. These plus the side inferred from the prefix are the complete per-iteration state.
2. **Re-read the review doc**. If missing or contains no Review Log section and no summary tables with R/E headers: `current_sig = (0, 0, 0, 0, 0, 0)`. Otherwise compute `current_sig = (r_done, e_done, r_total, e_total, r_step, e_step)` per the Counter measurement rules above.
3. **Compute `rounds_done`**: `r_done - r0` (review side) or `e_done - e0` (exam side). Check Condition #1: `rounds_done >= target_rounds` -> report the locked termination template (see Termination Rules below) and exit without arming another timer.
4. **Compare `current_sig` with `last_sig`** (6-tuple equality):
   - Any element changed -> reset `idle_ticks = 0`; set `last_sig = current_sig`. This includes `rT`/`eT` incrementing (Pending Review Log row appeared) AND `rS`/`eS` incrementing (summary column added OR cell flipped from `...`) with `rD`/`eD` unchanged -- all of these are counterpart-alive signals.
   - All six elements unchanged -> `idle_ticks += 1`.
5. **Check Conditions #2 and #3**: if `idle_ticks >= MAX_IDLE_TICKS`, apply the two-branch test using invocation-relative counterpart progress:
   - If `this_counterpart == 0` (counterpart has not advanced a completed round in this invocation) -> Condition #3 fires for EITHER role (leader or follower). Report `counterpart never started, stopping` and exit.
   - Else -> Condition #2 fires. Report `no change in review doc for 4 ticks (~16 minutes), stopping` and exit.
   - Exit without arming another timer on either Condition #2 or #3.
6. **Evaluate gate** using `role`. Compute `this_own = own_done - entry_own_done`, `this_counterpart = counterpart_done - entry_counterpart_done`, `k = this_own + 1`:
   - Review side: gate is `this_e >= k - 1` if `role = leader`, `this_e >= k` if `role = follower`.
   - Exam side: gate is `this_r >= k - 1` if `role = leader`, `this_r >= k` if `role = follower`.
7. **If gate satisfied**: run one round.
   - **Review side**: first arm the pre-round sentinel Bash call (per the Pre-round sentinel format above), then in the same message launch Phase 1 (setup) followed by Phase 2 (background spawning) from `review-doc-run-guide.md` and yield the turn. Immediately after Phase 3.6's Bash result returns (same turn -- see Continuation-turn handoff), the Continuation logic re-reads the doc, recomputes `rounds_done = r_done - r0`, resets `idle_ticks = 0`, and proceeds to steps 9-10.
   - **Exam side**: run the round single-turn and update state inline.
8. **If gate not satisfied**: print the canonical status line (`idle X/<MAX_IDLE_TICKS>, waiting for ...`). If `idle_ticks` was just reset in step 4 (sig changed -- e.g., `rT` advanced to show a Pending Review Log row, or `rS` advanced to show a new summary column / filled cell) but gate still not satisfied, the status line should explicitly note `idle reset (sig changed)` to surface the distinction between "gate waiting" and "counterpart alive".
9. **Early exit**: if `rounds_done >= target_rounds` after the round completes -> exit (don't arm another timer). This check fires immediately after the round completes, not on the next tick wake, so `N=1` does not incur a wasted 4-minute wait.
10. **Otherwise arm the next echo-encoded timer** carrying the updated `idle_ticks`, `last_sig = current_sig` (6-tuple), unchanged `entry = (r0, e0)`, unchanged `target = target_rounds`, unchanged `role`, and an updated prose narrative reflecting the current wait reason (`R2 done, waiting for E2 or next tick` / `waiting for R3 or next tick` / `R3 Phase 2 in progress, gate not satisfied, idle reset` / etc.). End the turn.

---

## Interaction with Phase 2/3 multi-turn flow (review side only)

### Dormant vs idle

**Dormant** = no timer is armed because a round is currently executing across multiple turns; the loop is waiting on its own work, not on the counterpart.

**Idle** = a timer fired, the doc was re-read, and the 6-tuple `(r_done, e_done, r_total, e_total, r_step, e_step)` was unchanged from `last_sig` -- including all six elements, not just the completed counts.

`idle_ticks` only accrues BETWEEN rounds, never during one.

### Multi-turn round structure

A review round is NOT a single-turn atomic operation. `review-doc-run-guide.md` Phase 2 spawns background item + holistic agents with `run_in_background: true` and explicitly ends the current turn so notifications can arrive; Phase 3.1 then processes notifications across several more turns; Phases 3.2-3.6 (elevation, log write, auto-fix, status update, notification sound) may coalesce into one or two final turns depending on auto-fix activity (in `--auto` mode Phase 3.5 is a no-op per `review-doc-run-guide.md:347`).

The loop is therefore **dormant during round execution** -- no ticks fire between the start of Phase 1 (setup) followed by Phase 2 (background spawning) and the completion of Phase 3.6. The timer is armed by this guide's Continuation logic, which runs inside the same turn as Phase 3.6, after its Bash tool call returns (see Initial entry and the Continuation-turn handoff section).

The per-round flow in `review-doc-run-guide.md` is not textually modified. The loop **augments** Phase 2's single-message spawn by adding a sentinel Bash call alongside the Task calls (see the Phase 2 single-message override subsection). The per-round guide's instructions still hold; the loop adds one extra `run_in_background: true` tool call to the same message. The existing guides are never edited -- the augmentation lives entirely in this guide's instructions to the agent.

The exam side does not have Phase 2, so for it "run a round" is a single-turn operation with no sentinel and no dormant/idle distinction.

---

## Termination Rules

Three conditions. Condition #1 is evaluated at step 3 of On tick wake (immediately after fresh counts are extracted in step 2), BEFORE the `last_sig` comparison (step 4). Conditions #2 and #3 are evaluated at step 5 (after `idle_ticks` has been updated in step 4).

### Termination-string templates (locked)

The loop guide MUST emit these literal termination strings. Tests and Success Criteria grep-match them exactly.

- **Condition #1** (rounds done): `completed <N> rounds, stopping` -- literal plural regardless of N (e.g., `completed 1 rounds, stopping`, `completed 2 rounds, stopping`). No pluralization-aware form.
- **Condition #2** (generic idle): `no change in review doc for <MAX_IDLE_TICKS> ticks (~16 minutes), stopping` -- `<MAX_IDLE_TICKS>` renders the Tuning constant value.
- **Condition #3** (counterpart never started): `counterpart never started, stopping` -- applies symmetrically to both roles and both sides.

These three templates are the ONLY termination strings the loop guide produces, used symmetrically on both review and exam sides.

### Condition #1: Completed N rounds

`rounds_done >= target_rounds` -> normal exit. Report the locked template `completed <N> rounds, stopping`.

Early exit: this check is also applied immediately after a round completes (On tick wake step 9, and the review-side Continuation after Phase 3.6). This prevents an `N = 1` invocation from arming a final timer and wasting a full `POLL_INTERVAL_SECONDS` before exiting.

### Condition #2: Idle ticks exceeded (generic)

`idle_ticks >= MAX_IDLE_TICKS` at step 5 AND `this_counterpart > 0` -> exit with `no change in review doc for <MAX_IDLE_TICKS> ticks (~16 minutes), stopping`. Applies to both sides and both roles.

Fires when the counterpart has advanced at least one round in this invocation but has since gone quiet for 16 minutes (at default `POLL_INTERVAL_SECONDS`). Diagnostic meaning: "we were both working together, then you stopped."

### Condition #3: Counterpart never started (symmetric across roles)

`idle_ticks >= MAX_IDLE_TICKS` at step 5 AND `this_counterpart == 0` -> exit with `counterpart never started, stopping`. **Fires for EITHER role** -- the earlier `role == follower` restriction was removed because the diagnostic is equally informative when a leader side runs round 1 alone and then idles without a counterpart. Uses invocation-relative `this_counterpart`, not absolute `counterpart_done`, so a doc with pre-existing counterpart rows still fires Condition #3 correctly when the counterpart's CURRENT SESSION never engages.

Three symmetric scenarios:

Sig vectors below use the illustrative 10-item / 7-concern doc shape: one completed round populates 17 R-cells + 2 R-headers = 19 toward `rS` (symmetric for `eS`). Exact numbers vary with doc shape; the structural argument (sig stable because counterpart never advances) is independent of shape.

- **Follower side, fresh doc**: when a side running with `role = follower` enters a fresh doc, its initial `last_sig = (0, 0, 0, 0, 0, 0)`. On the first tick wake the observed `current_sig` is still `(0, 0, 0, 0, 0, 0)`, which matches `last_sig`, so `idle_ticks` increments on every tick starting from tick 1. `this_counterpart = 0 - 0 = 0`. After `MAX_IDLE_TICKS` ticks that side exits with Condition #3. The initial `(0, 0, 0, 0, 0, 0)` convention is load-bearing here -- without it the first tick would be a "change" and the exit would drift to ~20 minutes.
- **Leader side, counterpart never starts**: when a side running with `role = leader` enters a fresh doc and runs its round 1 (review side runs R1 Applied), its subsequent `last_sig` lands at something like `(1, 0, 1, 0, 19, 0)` (17 R-cells populated + 2 R-headers from R1). If the counterpart never starts, `current_sig` remains at that 6-tuple on every tick wake, matching `last_sig`, so `idle_ticks` increments from tick 1 after R1 lands. `this_counterpart = 0 - 0 = 0`. After `MAX_IDLE_TICKS` ticks past R1, the leader side exits with Condition #3 -- the same informative message as the follower case.
- **Leader side with pre-existing counterpart rows, counterpart's current session never starts**: doc has `E3 Applied` pre-existing from a prior run. User runs `/review-doc-loop 2` alone (forgot to invoke `/exam-loop` in another session). entry_e_done=3 (entry_r_done=0). Review runs R1 (leader gate `this_e(0) >= 0` satisfied), `last_sig = (1, 3, 1, 3, 19, 63)` (R1 populated the R-column; 3 pre-existing E columns contribute headers + 17 cells each = 3 + 60 = 63 toward `eS`). If no new E row ever appears, `current_sig` stays at that 6-tuple on every tick, `this_counterpart = 3 - 3 = 0`. After `MAX_IDLE_TICKS` ticks, review exits with Condition #3 ("counterpart never started, stopping") -- the informative diagnostic, NOT Condition #2 ("no change for 16 minutes") which would be misleading since the pre-existing E3 was never part of this invocation's counterpart budget.

The symmetric treatment, keyed on `this_counterpart` rather than absolute `counterpart_done`, means the user gets the diagnostic message regardless of which loop command they forgot to start, even when the doc is not fresh.

### No timer on exit

On any termination path, do NOT arm a new timer. This prevents zombie ticks.

### Explicitly not handled

- User Ctrl-C during a sleep -- standard shell behavior; not our problem.
- Counterpart running a fix that invalidates findings just applied by our side -- later edit wins; acceptable because rounds are sequenced.
- Counterpart running `/review-doc-run` or `/exam` in single-pass mode mid-loop -- the log grows as usual, both counters still advance, nothing special needed.
- Two loop invocations of the same command on the same doc in the same session -- undefined behavior, don't worry about it.
- Both sides passed `--first` -- both use leader gate, rounds run in parallel without proper interleaving. Documented in Coordination Protocol § Degenerate cases; don't do this.
- Both sides passed `--follow` -- both wait forever for the counterpart to log round 1 in this invocation. On both fresh and resumed docs, `this_counterpart = 0` on both sides because neither side advances the counterpart's counter, so both exit via Condition #3 after ~16 minutes.
- Mismatched flags (e.g., `--first` on exam alone with nothing on the review counterpart) -- review falls back to default leader, both sides are leader, same degrade as "both `--first`".

---

## Notes for the guide author

- Signature is the 6-tuple `(r_done, e_done, r_total, e_total, r_step, e_step)`. Any element changing between ticks resets idle. Done-counts (`rD`, `eD`) gate round progression; total-counts (`rT`, `eT`) capture Pending Review Log rows; step-counts (`rS`, `eS`) capture summary-table progress (column adds at Phase 1, cell fills throughout Phase 2). Together they ensure a leader mid-round registers as counterpart-alive for the follower across every observable progress signal, while the gate still only opens on completion. Both sides symmetric.
- Between ticks the user can chat freely -- answer immediately with loaded context, same rule as `/monitor`'s "conversational, not transactional."
- **Post-round tick-interval wait**: after running a round we do NOT immediately re-check the gate. We still wait the full tick interval before the next iteration. The round already advances our own counter, and a post-round re-check only helps if the counterpart happened to finish in the last few seconds -- not worth the added loop-shape complexity. The tick interval is short enough that this is cheap.
- **No extra review-log markers**: the running side always logs its round exactly as today. No extra rows, no sentinel values, no "done" marker written to the review doc. The idle-tick rule naturally ends both sides once the faster one finishes. (Transcript-side pre-round sentinel echoes are permitted and load-bearing -- see Mid-round compaction recovery. That rule only forbids writing sentinels into the review doc.)
- **No timer on exit**: on any termination condition, do NOT arm a new timer. Prevents zombie ticks.
- **Fix-application completes within the same turn**: each round's fix application (Phase 3.4-3.5 for review, Applying Fixes for exam) completes within the same turn before the next timer is armed, so the counterpart always wakes to a settled document.
