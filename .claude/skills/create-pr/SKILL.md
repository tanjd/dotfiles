Create a pull request based on the branch's commits and diff.

## Steps

1. Run the following in parallel to gather context:
   - `git branch --show-current` — get branch name
   - `git log master...HEAD --oneline` — list all commits on this branch
   - `git diff master...HEAD --stat` — files changed summary
   - `git diff master...HEAD` — full diff for deeper analysis
   - `gh pr view 2>/dev/null || true` — check if a PR already exists

2. PR Title: Describe the Outcome
   - The PR title should say what the change achieves, not what you did while coding. (≤72 chars total).

3. If a PR already exists, ask the user whether to update its description or stop.

4. PR Description (PR Message)
    - The description should help the reviewer understand the change quickly.
    - Problem: What was wrong?
    - Solution: What approach did you take?

5. Show the full draft PR title and body to the user and ask for confirmation before creating.

6. On confirmation:
   - Push the branch if not already pushed: `git push -u origin HEAD`
   - Write the PR body to a temp file, then create the PR:
     ```
     cat > /tmp/pr_body.md << 'EOF'
     <body content>
     EOF
     gh pr create --title "..." --base master --body-file /tmp/pr_body.md
     ```
   - Return the PR URL.
