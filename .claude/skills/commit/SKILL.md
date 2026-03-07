Create a git commit following this repo's Conventional Commits convention and commit message best practices.

## Steps

1. Run `git branch --show-current` and check if on `main`. If so, **stop immediately** — do not commit to main directly. create a new branch named `<short-description>`, switch to it, then continue.
2. Run `git status`, `git diff` (unstaged), and `git diff --staged` to understand the full picture of changes.
3. If there are no changes at all, tell the user and stop.
4. Assess whether the changes form one logical unit or multiple. If they span unrelated concerns, suggest splitting into smaller focused commits and ask the user which grouping to proceed with.
5. If nothing is staged yet, propose which files to stage based on the logical grouping and ask the user to confirm before staging.
6. Check `git log --oneline -5` to see recent commits. If the current changes are a natural fix/continuation of the last commit, verify it is local-only by running `git log origin/<branch>..HEAD --oneline`. If the commit appears (i.e., not yet pushed), suggest an amend. Otherwise, default to a new commit.
7. Determine the **type**:
   - `feat` — new functionality
   - `fix` — bug fix
   - `refactor` — restructuring without behavior change
   - `test` — adding/updating tests only
   - `chore` — tooling, deps, config, CI
   - `docs` — documentation only
   - `perf` — performance improvement
8. Determine the **scope** from the primary package/area touched
   - Omit scope if the change spans many areas with no clear primary.
9. Write the commit message following best practices:
   - **Subject**: `type(scope): imperative-mood summary` (≤72 chars, no period at end)
   - **Body** (if needed): blank line after subject, then explain *what* changed and *why*, not *how*. Wrap at 72 chars.
10. Before committing, run `make test`.
11. Show the proposed commit message (and files to be staged if staging is needed) and ask for confirmation before proceeding.
12. On confirmation, stage any additional files if needed and run `git commit` using a heredoc to preserve formatting.

## Rules
- Never commit directly to `main`. If on main, always create a new branch first.
- Never use `--no-verify`.
- Do not include AI attribution lines.
- Prefer smaller, focused commits over one large commit when changes are logically separable.
- Default to a new commit; only suggest amending if the last commit is unpushed and the changes clearly belong to it.
