## Lessons Learned

- **[Key concept 2-5 words]** - [Complete, standalone explanation with technical details when valuable].

- **[Key concept 2-5 words]** - [Complete, standalone explanation].

- **[Key concept 2-5 words]** - [Complete, standalone explanation].

---

## Example

- **Database constraints handle cascades automatically** - ON DELETE SET NULL in FK constraint handles task unlinking when milestone is deleted, no application code needed.

- **Force flag pattern for destructive operations** - Block by default with informative error, allow override with explicit `force=True`. Protects against accidental data loss while enabling intentional cleanup.

- **Return affected entity info from delete operations** - Returning `tasks_unlinked` count and `dependencies_removed_from` list helps callers understand what changed without additional queries.

- **TEXT[] arrays simplify dependency tracking** - PostgreSQL array fields like `depends_on: TEXT[]` can be filtered and updated in application code without complex SQL, making dependency cleanup straightforward.
