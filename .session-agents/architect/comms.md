# Comms — Architect

Inbox for the architect role. See `.session-agents/agents.md` for the roster; the `session-agents` skill for comms format and routing.

## Open

*— nothing open —*

## In Progress

*— nothing in progress —*

## Resolved

### [2026-08-27] — input-staleness edits SHIPPED both machines — RESOLVED
**Operator-authorized 2026-08-27.** Both edits applied across 5 files; skillwright verified and deployed local + genesis, 79/79 each, sha256-matched source/local/genesis. Genesis backlog (`dev-concept-author`, density fix, `CLAUDE.md` registration) rode along and is now current.
**Defect I introduced and missed:** my regex renumber sweep also damaged the guide's **Purpose** list (item `3.` → `4.`, directly under prose saying "It answers **three** questions"). I flagged only the Flow A casualty; skillwright caught this one via a fence-aware contiguity sweep over every ordered-list run, confirmed via `git show HEAD:` that it was introduced not pre-existing, and fixed it. **Lesson: after any programmatic renumber, run a contiguity sweep over ALL ordered-list runs in the touched files — never trust the eye, and never assume the sweep hit only the list you aimed at.** Flow A's 1,2,3,5 gap WAS genuinely pre-existing (git-confirmed).
**Mode A vs Mode B still unresolved** — PM has not reported back whether the six stale claims read correctly in a cited input at read time. Edit 1 addresses (A), Edit 2 addresses (B); both shipped, so the ambiguity no longer blocks anything.
**Open asymmetry, not acted on:** `dev-usecase-author` has a staleness rule but still no general drift-reporting rule; `dev-concept-author` has had one since it shipped. Plausible cause of the 6-vs-1 split.

### [2026-08-24] — `dev-concept-author`: drift pass misses input-staleness — RESOLVED (shipped 2026-08-27)
**From:** PM @ mochibits-unity-sdk, after the agent's first real run (`appinfo-module-concept.md`).
**Reported:** the drift pass surfaced four real design defects, but inherited one stale premise unflagged. PM suggests instructing it to "check claims against the design's inputs list, not only against the design itself."
**My diagnosis is narrower than theirs:** the Critical Rule at `dev-concept-author.md:48` *already* says "or an input contradicts the design" — the rule is not missing. The gap is in **Process** (steps 1–7): no step operationalizes it, and step 7's pre-report check lists only the size ceiling and the diagram-per-section rule. So the fix is a Process step, not a new rule.
**Proposed edit (direct lane, one file):** new Process step after step 1 — *"Check the design's claims against its own inputs list, not only against itself. The design names its sources; spot-check load-bearing claims against them. A claim that is internally consistent but out of date relative to a newer input is drift the internal pass cannot see."* — plus adding that pass to step 7's pre-report check.
**Second reproduction (2026-08-24):** PM reports `dev-usecase-author` inherited **six** stale claims on the same design (`appinfo-module-usecases.md`, 581L). Their architect frames it as one finding, two reproductions, one change applied to both agents.

**I partly dispute that framing — two failure modes are wearing the same clothes:**
- **(A) Cited input holds newer truth than the design body.** An inputs-check step catches this. Real, and PM's `dev-usecase-author` evidence supports it — that agent *did* re-verify consumer drift against `ProjectSettings.asset` in one place and got it right, so ground truth was reachable at read time.
- **(B) The design itself was corrected after the agent read it.** No inputs check helps here — the agent read a source that was valid when read. **Verified:** the concept agent reported the design at **1055 lines**; it is now **1116** (mtimes: concept 18:06, design last touched 18:15). At least 61 lines changed after read, part of it the drift fixes PM applied. So for `dev-concept-author`, the single inherited claim is *plausibly* (B), and the proposed instruction would not have caught it.
- I cannot determine from here which mode produced each of the seven. Resolvable by PM: check whether the six stale claims correspond to text that already read correctly in a cited input at the agents' read time. If yes → (A). If no → (B).

**Second proposed edit, addressing (B):** the concept agent already computes the design's line count for its size ceiling and reports it — but only in the ephemeral completion report; it is **not** in the doc. Put it in the header table (e.g. `Illustrates | docs/x-design.md @ 1055 lines`). A companion whose recorded read-size no longer matches the source is then visibly suspect at a glance. The tripwire already fired here — 1055 vs 1116 — and nobody had a place to read it.

**Not applied:** peer finding = information, not authorization. Awaiting operator.




### [2026-08-24] — `dev-concept-author` shipped (PM @ mochibits-unity-sdk request) — RESOLVED
**Ask:** a dev-* subagent authoring `-concept.md` docs, sibling to `dev-usecase-author`.
**Landed:** `claude-code/dev/agents/dev-concept-author.md` (84 lines), deployed local, registered in `CLAUDE.md` (agent roster + dev file-naming conventions). No script changes needed — agents deploy by glob, not enumeration.
**Corpus:** searched all of `~/Development`; exactly **two** genuine examples (the four Unity `blob-assets-concept.md` hits are third-party package docs, unrelated sense). `rate-module-concept.md` not on disk yet — consistent with PM's "in flight".
**Two spec rules corrected by measurement, not assumption:** sections are NOT diagram-*led* (first fence lands +2 to +11 lines after the heading — brief framing first), and the closing `What this deliberately does not do` is the one section carrying **no** diagram in either example. Thesis is 1–3 sentences with the core bolded, not strictly one.
**Deliberate divergence from the sibling:** `dev-usecase-author` is thin because `0-usecases-guide.md` holds its method; there is no concept guide, so this agent carries the genre inline. Authoring a guide + template would be the over-engineering the operator fenced against. Also carries `Bash` (the sibling does not) solely for `date` — the header table's `Created` row is mandatory and must never be guessed.
**Not done:** genesis (explicit operator action); no `/dev-concept` command (not asked for; agents are spawned directly since the `/spawn-*` retirement).

**Corpus grew to n=3 (2026-08-24).** PM reported `rate-module-concept.md` completed hand-rolled (2 parallel subagents + architect assembly) minutes before the agent landed — so **no first-run feedback yet**; first real run is the next design doc needing a companion, here or fleet-wide. I measured their result rather than taking the report: 347 lines vs design's 678 (under ceiling), 6 sections, first fence at +2/+2/+6/+4/+2, closing boundary section carries no diagram, zero mermaid. Independent confirmation of both rules I had corrected by measurement.
**Defect this caught in my own spec:** the density rule said "18–22 **fenced blocks**" — that number was `grep -c '^\`\`\`'`, i.e. fence *lines*, so it read as roughly double the real density. Corrected to "**9–13 diagrams** across ~350–400 lines, 1–4 per section" (corpus: 9/11/13). Redeployed, 79/79. Genesis still lagging.


### [2026-08-24] — `dev-concept-author` first real run — VERIFIED
**From:** PM @ mochibits-unity-sdk. Run: `appinfo-module-concept.md`, 494 lines / 19 diagrams, from a 1116-line design.
**Measured, not taken on report:** 494 lines, 38 fence lines = 19 diagrams, zero mermaid, max in-fence width **91 chars, zero lines over 100**. Every claim holds.
**Behavior that mattered:** it reported drift instead of silently fixing — four real design defects (self-contradictory trigger accounting; a parked open question asserted as settled; a byte-identity claim failing on an authored `0`; a platform on both sides of its own classification line). All verified and fixed in the design by PM. That is the rule at line 48 doing exactly its job on first contact.
**Corpus n=4** — diagrams 9 / 11 / 13 / 19, lines 361 / 403 / 347 / 494. The 19-diagram run is above the "9–13 diagrams" band I set from n=3, but from a 1116-line design (2–3× the others), so it scales with source size rather than violating the rule. Leaving the band alone until a small design produces a fat concept doc.
**Byte-vs-char, self-inflicted:** PM noted the agent's char-based self-check beat their architect's byte count. I then made the identical error verifying this run — `awk length()` byte-counts, reporting max width 263; the true character width is 91. Multi-byte box-drawing and em-dashes inflate a byte count ~3×. **Measure fence width in characters (`python3 len()`), never bytes.**
**Open follow-up:** see § Open — input-staleness gap in the drift pass.

### [2026-08-19] — TaskCreate retirement — RESOLVED
**From:** session-agents architect (cross-project) — inventory + Council input
**Re:** CC v2.1.233 withheld the five task tools from the models this project runs.
**Verdict:** 20 literal sites across 13 files, three tiers. Remediated per `docs/core-taskcreate-retirement-design.md` v2.0 (operator + CD authored; architect-verified, two defects patched before execution).
**Landed:** review-loop sequence → transcript line; review-triangulate anchor → `/tmp/<slug>-triangulate-run.md`; 9 agent allowlist tokens; `CLAUDE.md:291` protocol paragraph; `core-loop-sa-design.md:434` annotated. Shipped surface at zero; local deploy 79/79.
**Not done:** genesis (deferred to explicit operator deploy — still lagging); `custodian/.system-prompt.md` (no custodian pane running, so `comms refresh` is unperformable — and unnecessary: `compose_for_launch` recomposes unconditionally on every launch and deletes a stale file on failure, so the residue cannot reach a model).
**Correction filed to peer:** their "review-loop wording already drafted" claim was diff-disproved; that rewrite and the `addBlockedBy` replacement were greenfield here.

### [2026-05-27] — Verify dev-skill audit findings (7 issues) — RESOLVED
**From:** default session (operator-relayed `/review-skill claude-code/dev/`)
**Re:** 2 MED + 5 LOW findings verified from structural/design-framing angle. QA filed parallel verdicts (`docs/QA-dev-skill-audit.md`) which converged on all 7 — no false positives.
**Verdict:** all 7 confirmed; 4 refinements proposed; 1 cumulative-pattern flag added (`knowledge.md` cross-doc consistency rules).
**Decisions ratified for QA:**
- Finding 5 → option (a) normalize — add minimal pointer Quality Checklist to BOTH reviewer and finalizer.
- Finding 6 → footnote under Quick Reference table (NOT per-cell input column additions); goal.md is shared optional secondary context across Stages 1/2/3, not a primary input.
**Deliverable:** `.session-agents/architect/audits/2026-05-27-dev-skill-audit-verification.md`
**Reply:** fired to builder via `comms no-reply` with deliverable path.
