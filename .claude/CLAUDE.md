## Code Navigation — LSP Required

The `LSP` tool is deferred: it is NOT missing, just unloaded. Before your first code
search or navigation in a session, load it with ToolSearch `select:LSP`. Do not fall
back to grep/find because LSP "isn't listed" — load it first. (pyright and
typescript-language-server are installed.)

Once loaded, always prefer LSP operations over text search. This applies globally
to all tasks in this session. Grep is fine for non-symbol text (string literals,
config values, log messages, non-code files).

### Use LSP for these tasks (never grep/glob as a substitute):

| Task | Use |
|---|---|
| Find where a symbol is defined | `goToDefinition` |
| Find all usages of a symbol | `findReferences` |
| List all symbols in a file | `documentSymbol` |
| Find a class/function by name across project | `workspaceSymbol` |
| Get type info for a variable | `hover` |
| Find all implementations of an interface | `goToImplementation` |
| Trace who calls a function | `incomingCalls` / `outgoingCalls` |
| Check for errors after editing | `getDiagnostics` |

### Required workflow for refactoring:

Before renaming or moving any symbol:
1. Run `findReferences` to get the exact, complete list of usages
2. Make changes
3. Run `getDiagnostics` to confirm zero type errors

Never assume a grep result is complete. LSP references are exhaustive; grep results
are not.

### Diagnostics:

After every file edit, check LSP diagnostics before considering the task complete.
If diagnostics report errors, fix them in the same turn.
