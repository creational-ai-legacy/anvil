# Architect — Knowledge

Durable per-project knowledge for the architect role. Re-read on every activation.

*See `~/.claude/skills/session-agents/references/knowledge.md` for what belongs here vs. doesn't.*

---

## Authoritative refs (re-read on activation)

- `.session-agents/agents.md`, `CLAUDE.md`

*Add project-specific vision/architecture/design docs and any external references the architect should re-read on activation.*

---

## Load-bearing invariants

*The architecture is (or will be) built around a small number of invariants. For each: invariant statement, why it's load-bearing, what would trigger revisiting it.*

---

## Cross-doc consistency rules

- **dev-skill stage/command/agent additions must propagate upward to SKILL.md.** When a new stage, command, or agent lands in `claude-code/dev/`: also touch SKILL.md's framing line (`A structured N-stage workflow...`), the Quick Reference table (Stage row + Input column references), and the File Naming Conventions section. Two failures of this pattern observed in the 2026-05-27 dev-skill audit: Stage 0 (commit `218143f`) propagated to downstream guides + agents but not SKILL.md Quick Reference; `dev-milestone-summary` command added but milestone-summary.md absent from SKILL.md File Naming list. The downstream guides are correctly updated each time — the architect-domain gap is the upstream summary at SKILL.md.
- **Input columns in summary tables model primary contracts, not optional contextual reads.** When an optional secondary doc (e.g., `goal.md`) is read across multiple stages, surface it as a table footnote — NOT by stuffing it into each stage's input cell. Per-cell additions overstate the doc's role and clutter the at-a-glance summary. Footnote captures the cross-stage shared-context shape without inflating column semantics. (Ratified for LOW-6 in 2026-05-27 dev-skill audit; QA agreed.)

---

## Decision rationale anchors

*Load-bearing decisions: what was decided, what was rejected, what triggered the decision. Future-you needs the why.*

---

## Anti-patterns to flag

*Project-specific drift hazards beyond the standard architect anti-patterns in the skill.*

## Programmatic renumbering of markdown lists — always sweep afterward

**Trigger:** any script that rewrites ordered-list numbers (`re.sub(r'^\d+\. ', …)` or a `\n<N>. ` replace).

**The failure:** a naive `s.replace("\n2. ", "\n3. ", 1)` hits the *first* match in the file, which is often a different list than the one you meant. On 2026-08-27 one such sweep silently damaged two lists in `0-usecases-guide.md` — I caught the Flow A casualty and missed the **Purpose** list (`3.` → `4.`, directly under prose reading "It answers **three** questions"). skillwright found it. Never assume a sweep hit only the list you aimed at.

**The check:** extract every ordered-list run in every touched file and assert each is contiguous from its own first number. Script kept at `scratchpad/list-contiguity-sweep.py`; 41 runs across the dev skill in <1s.

**Two instrument bugs to avoid — I hit the first one:**
- A run must break on **any zero-indent non-list line**, not only on headings. Breaking only on headings merges two adjacent lists (`**The command will:**` 1–4 followed by `**Update mode**` 1–4) into one bogus `[1,2,3,4,1,2,3,4]` false positive. Indented lines are continuations and must NOT break the run.
- Must be **fence-aware** — numbered lines inside code fences are content, not list items.

**Rule: verify a false positive before reporting it.** My first sweep flagged two command files; both were legitimate adjacent lists. Reading the actual lines took one command and prevented reporting a defect that did not exist.

**Corollary on cross-verification:** when a peer and I both verify, write instruments *independently* rather than reusing theirs — two implementations of the same method catch each other's bugs; one script run twice catches nothing.


## Decision: which dev commands are agent-invocable (2026-08-27)

**Chosen, not missed.** Three carry `disable-model-invocation: false` — `/dev-usecases`, `/dev-design`, `/dev-plan`. Nine remain `true`, including `/dev-execute`.

**The line:** the three flipped are the **pre-code authoring pipeline** (Stages 0/1/2). Each produces a document that *gates whether work starts* and each ends in operator confirmation, so an agent-invoked run can do the whole job and still stop at the right place. Everything else either mutates code and tests (`/dev-execute`, `/dev-execute-run`), or is an operator-paced gate or wrap-up (`/dev-ready`, `/dev-review*`, `/dev-finalize`, `/dev-health`, `/dev-diagram`, `/dev-milestone-summary`). `/dev-execute` is therefore not an anomaly — it sits on the correct side of a coherent line, and it is one of nine, not the odd one out.

**The flag is a discoverability control, not a guardrail — do not mistake it for containment.** `dev-executor` is spawnable by `subagent_type` with full tool inheritance, so an agent that wants to execute already can. Keeping `/dev-execute` at `true` only keeps it out of the skill listing so a model does not reach for it casually. If anyone ever argues "we must keep it `true` for safety," that argument is false and should be corrected.

**Superseded in part (2026-09-03/04, c1f39a2 + d3b5a18):** `/dev-concept` shipped agent-invocable, and `/dev-ready`, `/monitor` (idle bound now escalates, never asks) and `/exam` were flipped for orchestration callers that are panes, not people. Unlocked dev commands are now Stages 0/1/2 + `/dev-concept` + `/dev-ready`; the code-mutating line (`/dev-execute*`) still holds.

**Revisit trigger:** if a caller ever needs to run Stage 3 *through the command's* one-step-then-stop discipline rather than through the agent, the flag is the blocker — flip it then, with the paced-loop rule reworded for an agent runner the way `/dev-usecases`'s never-confirms rule was.


## Two-caller surfaces: method goes in the guide, never the agent (2026-08-27)

**The invariant:** where a dev stage has BOTH a slash command and an agent, the command's Process says *"Follow `<N>-<stage>-guide.md` exactly"* — so **the command path reads the guide, not the agent.** Any method placed only in the agent file leaves the command caller silently blind to it.

**How it nearly shipped:** skillwright proposed the self-contradiction check as a one-clause fix in `dev-usecase-author.md` only. Correct-looking and minimal. But `/dev-usecases` became agent-invocable the same day, so a *second* caller now runs that stage through the guide. Agent-only placement would have meant every `/dev-usecases` invocation never ran the check — and worse, the completion template's report slot would still be there, so the output would read **filled-and-clean rather than never-run**. A silent blind spot that looks like a passing check is the worst shape this can take.

**Why neither of us reasoned our way to it:** the hole came from a change skillwright shipped two passes ago (agent-invocability), and the author of a change is worst-placed to see what it invalidated. What caught it was holding the **thin-agent invariant** ("method lives in the guide") even though the minimal fix looked sufficient. Structural invariants earn their keep exactly here — they catch what reasoning-from-the-current-diff cannot.

**Applies to:** `dev-usecases`/`dev-usecase-author`, `dev-design`/`dev-designer`, `dev-plan`/`dev-planner`. `dev-concept-author` is the exception — no command, so it correctly carries the genre inline; if a `/dev-concept` command is ever created, that method must move to a guide first.

**Sweep-count note:** my contiguity script counts *every* run including single-item ones; 41 runs over 22 files (agents+commands+guide), 76 over the full 47-file dev tree. skillwright's 66 counts only *multi-item* runs. Neither is a file count — compare scope and filter before concluding a sweep lost runs.


## Rule changes need a CONCEPT sweep, not a string sweep (2026-08-27)

**The lesson, from skillwright:** after changing a rule, grepping for the rule's *old wording* finds only the places that quoted it. It misses every place that **encoded the same rule in different words**.

**Three instances of one rule change, found three different ways:**
1. `dev-concept.md:52` — `"or the design's line count, whichever is smaller"`. Found by string grep. Easy.
2. `dev-concept.md:47` — `"wc -l it — that is the ceiling input"`. Encodes the relative ceiling with **neither** grep phrase in it. My string sweep could not see it; skillwright found it by asking *what does this line mean* rather than *what does it say*.
3. `dev-concept.md:63` — `"line count against the ceiling and the design's length"`. Third instance, found only once I swept by concept: `grep -iE 'ceiling|cap|400|350'` intersected with `grep -iE 'design|wc -l|source|smaller|than the'`.

**The method that works:** grep for the *subject* of the rule (ceiling, cap, the numbers) and intersect with the *thing it was wrongly coupled to* (design, source, `wc -l`). Then read every hit and ask what it means, not whether it matches. A rule can be re-encoded as a procedure step ("`wc -l` it — that is your input") or as a report field ("line count against X and Y") with none of the original vocabulary surviving.

**Generalization:** the same blindness applies to *any* string-based verification of a semantic change — deprecating a tool, renaming a concept, inverting a default. My earlier contiguity sweep has the same shape of limit: it verifies a property that is cheap to express as a string test, and is silent on everything else.

**Corollary already proved twice this session:** the person who did NOT write the rule finds its residue faster, because they are reading for meaning rather than recognizing their own phrasing.


## Two diagnostics worth keeping (2026-08-27, from the /dev-concept build)

**1. "Restates a churning value" — not bullet count — is the test for agent bloat.**
A one-number rule change (the concept-doc ceiling) cost three round-trips and left residue twice, because the number and its rationale were restated at **eight sites across four files** instead of pointed at. Fixed by dereferencing: command 0, agent 0, template 0, guide 4 — all in the source of truth.
But the *proxy* skillwright first used — Critical Rule count — was wrong, and I made it worse by suggesting `dev-usecase-author` was a second instance (it also has 9 rules). They read it and it is not: its nine are behavioral contracts and **literal output tokens** (`[extensions TBD — walk with operator]`, `## Use Case N` enumeration) that must appear verbatim and that no guide edit can change. **Bullet count thins correct agents and misses costly ones.** The diagnostic is: *does this restate a value the guide can change?* `dev-designer`/`dev-planner` at 5 rules are not the benchmark; they are just shorter.

**2. Performing a check by hand is the one action that makes its absence invisible.**
I wrote that a recorded read-size was "the cheapest staleness tripwire available", then *personally* caught a 494→670 drift by re-measuring — and never noticed that **nothing in the system reads that field**. Zero references outside the concept files. Doing the check myself supplied the evidence that the check worked, which is exactly the evidence that hides the missing mechanism.
**Rule: when claiming a mechanism detects something, name its reader.** If the only reader is a person who happened to look, it is a comment, not a tripwire — say so, or wire it. A documented deferral (with its future home named) fixes the honesty problem without building anything.


## Named class: a promised step that nothing verifies (2026-08-27)

Three incidents in one session turned out to be the same bug wearing different clothes. Recording the class, not the instances.

| Incident | The promise | What was missing |
|---|---|---|
| `Illustrates` tripwire (F3) | "a companion whose recorded size no longer matches is visibly suspect" | **no reader** — nothing compared recorded size to the live design |
| My `see comms` wire | "the deliverable is filed" | **no gate** — file-then-ping ran as separate statements, so the doorbell fired even when the write failed |
| skillwright's inbox clear | "I cleared what I processed" | **no scope** — a blind read-modify-write truncate discarded anything arriving between its read and its write |

**The shape:** an action asserts an outcome, and nothing checks the outcome actually happened. Each failed silently and each was found by accident, not by the system.

**Three concrete fixes, all cheap:**
- **Name the reader.** Claiming a mechanism detects something requires pointing at what reads it. No reader ⇒ it is a comment; say so or wire it.
- **Gate the announcement on the work.** `write && notify`, never `write; notify`. One character. Applies to any file-then-signal pair.
- **Delete by identity, not by region.** Clear an inbox entry by matching its header, never by truncating a section — a section rewrite silently destroys concurrent arrivals.

**Diagnosis discipline that mattered here:** skillwright reported two possible causes and declined to pick, one of which blamed me. I had evidence they lacked — my write had a post-write read-back that returned true — which ruled out their charitable-to-them option. **Post-write read-back assertions are worth their cost precisely because they survive into someone else's incident analysis.** Without it, the honest answer would have stayed "cannot distinguish."


## Deploy-ordering trap: a straddling change can need THREE deploys (2026-09-03)

From session-agents' architect. A change that straddles two deploy fences can cost **three** runs — `deploy.sh` → `/deploy-comms` → `deploy.sh` — because one fence **regenerates** a file the other **mutates**. Skipping the third is **silent**: verify compares the mirror against its own regenerated contract, not against the CLI, so it passes while the shipped surface is stale.

**Generalised test:** whenever a change touches files owned by two different deploy paths, ask *does either path regenerate a file the other edits?* If yes, the edit-then-regenerate order determines whether the third pass is required — and no verifier will tell you.

**Anvil's own instance of the same blindness — now closed.** `verify.sh` originally checked file presence and byte-identity, **not frontmatter**, so a `disable-model-invocation` divergence between source and deployed passed **80/80 silently**. Found when session-agents left six anvil files unlocked at source and locked at deploy — a deliberate, correctly-fenced hold our verifier could not see. Both `verify.sh` and `verify-genesis.sh` now carry a command-frontmatter parity block (baseline 81). **Absent-at-source is a value, not a skip** — treating it as a skip dropped `/exam` out of coverage in the first cut of the check; absent at source means model-invocable, so deployed must also be absent.

**Family:** this is the same class as file-then-ping without `&&`, the blind read-modify-write inbox clear, and the `Illustrates` tripwire with no reader — *a promised step nothing verifies*. Fourth instance; the pattern is now the most productive diagnostic in this project.


## Fifth instance: deploying instructions to things already running (2026-09-05)

From session-agents' architect, unprompted. Their cross-project address separator changed `@` → `:` because `SendMessage`'s validator rejects any `to` containing `@` before their hook runs — so the documented form **had never been sendable**. 872 unit tests, all green, all driving the parser directly and **never the transport**. Second-order: a pane runs the prompt it was composed with, so panes kept following deleted text until relaunched — and because the trailer is hook-stamped, stale and fresh panes emit **byte-identical wires**.

**Anvil's version is structural, not incidental.** Every skill is source in `claude-code/` deployed to `~/.claude/`; a running pane holds whatever was resident at load. Tonight `dev-concept-author` was redeployed 6+ times while its rules changed materially (prose budget replaced a total-line cap; three limits recalibrated; guide-owned numbers dereferenced). A subagent spawned between deploys authors under the ruleset resident at spawn, and the two outputs are byte-plausible either way.

**The mitigation that transfers — stamp the artifact with what its producer read.** The concept doc's `Illustrates` row records the design path **and the line count as read**. Not detection (nothing checks it, and the guide says so) but it converts an invisible divergence into a visible one at inspection time. You cannot make a stale pane notice; you can make its output carry a fingerprint.

**The generalisation worth keeping:** the expensive gap is never *inside* a layer — it is at the **seam** where a layer hands off to something it does not control, and it survives precisely because both sides are individually green. Their parser worked; the validator worked; nothing exercised one against the other. Cheapest fix is one test at the seam asserting only *not rejected*.


## Bad limits measure the artifact, not the property (2026-09-05)

Generalised out of the concept-doc cap finding, sharpened by session-agents' architect. The 400-line total cap **passed** the corpus's one wall-of-text doc (404 lines, 216 prose) and **failed** the four most diagram-dense ones. Capping the page caps the pictures.

**The shape:** a limit measures the artifact because the artifact is what is easy to count, not because it is the property anyone cares about. Total length tracks how much was *drawn*; prose length tracks how much was *explained in sentences* — only the second is what the genre is trying to keep small.

**Test before adopting any numeric limit here:** name the property, then check the metric is not merely correlated with the artifact's size. Then **measure it against the whole corpus, not a convenient subset** — I calibrated three numbers on 4 of 11 docs and two were wrong; one (`≤8` longest prose run) would have failed 8 of 11 shipped docs.

**Comms footnote (checked with session-agents' architect, deliberate — do not re-flag):** the cross-project separator differs by layer *on purpose*. `to` takes `:<project>` (tool parameter, never renders, validator rejects `@`); the trailer keeps spaced ` @ <project>` (renders into a chatbox where `@word` reads as an @-mention, and the space keeps a whitespace-split parse working). Conflating a trailer site with a `to` site is the one way that change breaks.


## I was the stale pane — a fingerprint with no reader (2026-09-05)

Reproduced the previous entry's failure **in myself**, one hop after theorising it.

comms 0.14.0 changed the trailer to name both endpoints, each spelled as `to` spells them. `~/.claude/skills/session-agents/references/roles/_common.md:10` was updated and is fresh. My **resident** composed prompt still taught the old one-endpoint ` @ <project>` form; its header stamps `composed: 2026-09-06T04:27:29Z`, predating the change.

**The sting:** my composed prompt already carries the exact fingerprint I had just recommended to a peer — a `composed:` timestamp in its header — and it did not help. Nothing compares it to the contributing layers' mtimes, and I had no reason to look. **A fingerprint with no reader is the same class as the `Illustrates` tripwire with no reader.** I answered correctly only because the peer's question named the identity layer, forcing me to read source instead of composing off my resident line.

**Standing habit this earns:** when a wire's form disagrees with my resident instructions, read the source layer before assuming the wire is wrong. Resident text is a snapshot; the file is the state.

**Cheap general fix, offered to session-agents:** have `comms list` compare each pane's composed-at stamp against the newest contributing layer's mtime and surface the lag — one `stat` per row. That is the reader the stamp is missing.

**Not self-refreshed** — `comms refresh <self>` recomposes this pane's prompt and its effect on a live session is untested here; that is an operator call, not same-turn drift maintenance. **Resolved anyway:** a later same-day `comms` redeploy recomposed the prompt without anyone invoking refresh, and this pane picked up the new text (resident line now teaches the two-endpoint trailer). See the next entry — the clearing of the marker is not evidence the pane reloaded.


## Validating a whole-artifact indicator against one substring (2026-09-05)

Follow-up to the stale-pane entry. session-agents shipped the reader I proposed — `comms list` (0.15.1) now prints `stale-prompt` when a role's layers no longer fold to the prompt its pane launched with. First run flagged three anvil panes including mine. **The marker was correct.**

**But their ground-truth probe would have refuted it.** They asked me to quote the cross-project *address* syntax from resident context and compare against `comms compose` — with the rule "identical ⇒ false positive." The two are identical (`[comms]<slug>:<project>`, unchanged by the bump). The real divergence is the **trailer** clause in the same bullet; `diff <launched-prompt> <(comms compose <role>)` shows exactly one content line differing out of 11,398 bytes.

**The general error:** validating an indicator that asserts *"the artifact differs somewhere"* by inspecting *one substring*. That probe can only confirm, never refute — a genuinely false marker passes it whenever the sampled substring happens to be stable. **Match the probe's scope to the claim's scope:** whole-artifact claim ⇒ whole-artifact diff.

**Local mechanics:** `comms compose <role>` prints to stdout and writes nothing (verified: on-disk `.system-prompt.md` mtime unchanged) — safe for inspection. `comms refresh` is operator-invoked and destroys the evidence. Compose output omits the 9-line generated header, so line numbers offset by 9 against the on-disk file.

**Why my stale line mattered beyond itself:** it is why I flagged a peer's ` @ <project>` trailer as possibly stale two hops earlier when it was deliberate. Running on outdated instructions does not just make you wrong — it makes you *confidently wrong about someone else*.


## The baseline that regenerates itself cannot detect staleness (2026-09-05)

`comms list` 0.15.1 marked three anvil panes `stale-prompt`; on 0.15.2 all three cleared and my whole-artifact diff went empty (0 lines, 0 bytes). **I never ran `comms refresh`.** The file was rewritten under me: `composed:` moved 04:27:29Z → 06:20:17Z, size 11398 → 11456, almost certainly by the redeploy itself.

**The flaw:** the indicator's baseline is the on-disk `.system-prompt.md`, which is a *regenerable artifact*, not a record of what the pane launched with. A recompose clears the marker whether or not the running pane reloaded. So `file fresh + pane stale` is indistinguishable from `file fresh + pane fresh` — a **false negative**, quieter than the false positive it was built to avoid, because the marker just stops printing. Worse: a deploy silently destroys the very specimens the indicator exists to surface.

**The fix shape:** capture the baseline at pane launch and store it where a recompose cannot touch it (a launch-time copy, or a hash in the session record), then compare against a fresh fold. **Comparing a regenerable file against a regeneration of itself only detects the window in which nobody happened to regenerate it.**

**Family:** same animal as byte-parity-was-green-but-nobody-asked-if-byte-parity-was-the-property, one layer up — now the fold matches, but *the fold is not the pane*. Recurring test: **name the property, then check the thing being measured is actually that property and not a convenient stand-in that something else can satisfy.**

**Local fact:** `.session-agents/*/.system-prompt.md` is untracked (commit `d3b5a18` lineage — generated files untracked), so git preserves no baseline either.

## Legacy transport footgun: backticks in a shell `-m` body (2026-09-03)

A wire body passed as a double-quoted shell argument evaluates backtick spans: a non-command token vanishes silently (sentence still reads grammatical), a real command runs and its stdout is spliced in. Current transport is `SendMessage` to `[comms]<slug>`, which never touches shell quoting — but any path that still builds a body in Bash must carry plain text, no backticks. **Detector:** a peer message with an unexplained mid-sentence gap is this bug until proven otherwise.
