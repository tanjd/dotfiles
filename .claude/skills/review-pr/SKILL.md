Review the current branch's changes by spawning a dedicated code review agent.

## Steps

1. Gather context by running in parallel:
   - `git branch --show-current`
   - `git log master...HEAD --oneline`
   - `git diff master...HEAD --stat`
   - `git diff master...HEAD`

2. Use the **Task tool** to launch a `general-purpose` subagent with the following prompt (fill in the actual diff and commit list):

```
You are a senior engineer doing a thorough code review. Review the following changes from branch `<branch-name>`.

## Commits
<insert the actual output of `git log master...HEAD --oneline` from step 1>

## Diff
<insert the actual output of `git diff master...HEAD` from step 1>

## Review criteria — check each area:

### Correctness
- Logic errors, off-by-one, nil pointer risks, unhandled errors
- Are error returns checked? Are errors wrapped with context?

### Security
- Input validation at system boundaries (HTTP handlers, CLI args)
- No credentials, tokens, or PII in logs or error messages
- SQL/command injection, SSRF, insecure deserialization risks
- Auth/authz changes: are they intentional and safe?

### Code quality (KISS / SOLID / idiomatic Go)
- Functions do one thing; packages have single responsibility
- No premature abstractions or over-engineering
- Interfaces defined at the consumer, not the producer
- Dependencies injected explicitly (no hidden globals)
- Early returns, minimal nesting, consistent error handling
- Naming: clear, idiomatic, no unnecessary abbreviations

### Tests
- Is new behavior covered by unit tests?
- Are edge cases and error paths tested?

### Observability
- Are meaningful log lines added?

### Performance
- Any obvious N+1 queries, unbounded allocations, or unnecessary blocking calls?

## Output format
Return a structured review with:
1. **Summary**: 2–3 sentence overall assessment
2. **Must Fix** (blocking): numbered list, each with file:line reference and explanation
3. **Should Fix** (non-blocking but important): same format
4. **Suggestions** (optional improvements): same format
5. **Positives**: what was done well

Be specific and actionable. Reference file paths and line numbers where possible.
```

3. Present the subagent's full review output to the user.
4. Ask if the user wants to address any of the findings now.
