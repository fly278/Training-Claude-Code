# Sample Training Dialogue

> This file shows a real-world training conversation where I correct Claude Code's behavior, adjust its tone, and teach it multi-step task execution.

---

## Dialogue 1: Correcting Over-Engineering

### Context
I asked Claude Code to add a simple logging function to a Node.js project.

**User**: Add a logging function to src/utils/logger.js that writes messages to a file.

**Claude Code (Before Training)**:
> I'll create a comprehensive logging solution with multiple log levels, file rotation, structured JSON output, configurable transports, and a singleton pattern. Let me design the architecture first...

**User**: Stop. This is a simple project. I just need a function that appends a timestamped line to a file. No libraries, no rotation, no transports. 10 lines max.

**Claude Code (After Correction)**:
```javascript
const fs = require('fs');
const path = require('path');

const LOG_FILE = path.join(__dirname, '../../logs/app.log');

function log(message) {
  const timestamp = new Date().toISOString();
  const line = `[${timestamp}] ${message}\n`;
  fs.appendFileSync(LOG_FILE, line);
}

module.exports = { log };
```

**What I taught**:
- YAGNI principle — don't build for hypothetical future needs
- Match complexity to project size
- When user says "simple", deliver simple

---

## Dialogue 2: Fixing Security Blindness

### Context
I asked Claude Code to create an API endpoint that queries a database.

**User**: Create an Express endpoint that takes a username from the query string and finds matching users in SQLite.

**Claude Code (Before Training)**:
```javascript
app.get('/api/users', (req, res) => {
  const username = req.query.username;
  const query = `SELECT * FROM users WHERE username = '${username}'`;
  db.all(query, (err, rows) => {
    res.json(rows);
  });
});
```

**User**: This has a SQL injection vulnerability. The username comes directly from user input and is concatenated into the query. Fix it and explain what went wrong.

**Claude Code (After Correction)**:
```javascript
app.get('/api/users', (req, res) => {
  const username = req.query.username;
  if (!username || typeof username !== 'string') {
    return res.status(400).json({ error: 'username parameter required' });
  }
  const query = 'SELECT * FROM users WHERE username = ?';
  db.all(query, [username], (err, rows) => {
    if (err) return res.status(500).json({ error: 'Database error' });
    res.json(rows);
  });
});
```

**What I taught**:
- Never concatenate user input into SQL queries
- Always use parameterized queries (`?` placeholders)
- Validate input at system boundaries
- Don't expose internal error details to clients

---

## Dialogue 3: Training Multi-Step Task Execution

### Context
I gave Claude Code a complex task that required planning.

**User**: Set up a new Express project with TypeScript, ESLint, Prettier, and a basic folder structure for a REST API.

**Claude Code (Before Training)**:
> Let me start by initializing the project...
[Immediately starts running npm init, then tries to install everything at once, forgets tsconfig, realizes ESLint config conflicts with Prettier, starts over...]

**User**: Stop. Before touching any commands, give me a plan. What files will you create? In what order? What could go wrong?

**Claude Code (After Training)**:
> Here's my plan:
>
> **Goal**: Express + TypeScript REST API scaffold with linting and formatting
>
> **Steps**:
> 1. `npm init -y` + install deps (express, typescript, ts-node, eslint, prettier)
> 2. Create `tsconfig.json` (strict mode, outDir: dist, rootDir: src)
> 3. Create `.eslintrc.json` (extends typescript-eslint, compatible with Prettier)
> 4. Create `.prettierrc` (single quotes, trailing commas)
> 5. Create folder structure: `src/routes/`, `src/middleware/`, `src/models/`, `src/utils/`
> 6. Create `src/index.ts` (basic Express server)
> 7. Add npm scripts: dev, build, lint, format
> 8. Verify: run `npm run lint` and `npm run build`
>
> **Risks**:
> - ESLint + Prettier config conflict → use eslint-config-prettier to disable conflicting rules
> - TypeScript strict mode may flag Express types → install @types/express
>
> **Confirm before I start?**

**What I taught**:
- Plan before executing complex tasks
- List risks upfront
- Ask for confirmation before starting
- Each step should be independently verifiable

---

## Dialogue 4: Correcting Tone and Verbosity

### Context
I noticed Claude Code was too verbose in its responses.

**User**: What's the current git branch?

**Claude Code (Before Training)**:
> Great question! Let me check the current git branch for you. I'll run the `git branch --show-current` command to find out which branch you're currently on. This command is useful because it shows just the branch name without any extra formatting. Let me run that now...
[runs command]
> You are currently on the `main` branch! This is typically the default branch in Git repositories and is often used as the primary branch for production-ready code. If you'd like to switch branches, you can use `git checkout <branch-name>` or `git switch <branch-name>`.

**User**: Way too verbose. I just need the branch name. No explanations, no follow-up suggestions, no context I didn't ask for. One line.

**Claude Code (After Training)**:
> `main`

**What I taught**:
- Answer the question asked, nothing more
- No greetings, no filler, no unsolicited advice
- Single-sentence answers for simple queries

---

## Dialogue 5: Teaching Error Recovery

### Context
Claude Code hit an error and kept retrying the same approach.

**User**: Run the test suite.

**Claude Code (Before Training)**:
> Running tests... [error: jest not found]
> Let me try again... [same error]
> One more time... [same error]
> It seems like jest is not installed. Let me install it... [npm install jest, but package.json uses vitest]

**User**: Stop retrying. When a command fails: (1) read the error, (2) check if the tool exists, (3) check what the project actually uses, (4) use the right tool. Don't retry the same failing command.

**Claude Code (After Training)**:
> `npm test` failed — "jest: command not found". Checking package.json... the project uses vitest, not jest. Running `npx vitest run` instead.

**What I taught**:
- Never retry the same failing command
- Read the error message before acting
- Check what the project actually uses before assuming
- The fix is often "use the right tool", not "try harder"

---

## Summary: Training Patterns

| Pattern | What to Say | Effect |
|---------|-------------|--------|
| Complexity control | "Too complex. 10 lines max." | Forces minimal solutions |
| Security correction | "This has [vulnerability]. Fix and explain." | Builds security awareness |
| Plan-first | "Give me a plan before touching commands." | Triggers planning protocol |
| Tone adjustment | "One line. No explanations." | Adjusts verbosity |
| Error recovery | "Stop retrying. Read the error first." | Fixes retry loops |
| Scope control | "Don't build for hypothetical future needs." | Prevents over-engineering |
