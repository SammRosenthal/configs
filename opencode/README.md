# opencode

| Repo path       | Linked to                            |
| --------------- | ------------------------------------ |
| `opencode.json` | `~/.config/opencode/opencode.json`   |
| `plugins/`      | `~/.config/opencode/plugins`         |

`node_modules`, `package.json` and the lockfiles in `~/.config/opencode` aren't
tracked; opencode installs its plugin SDK there itself.

## Settings (`opencode.json`)

- **Default agent: `plan`.** Sessions start in plan mode; switch agents with
  `Tab`.
- **External directories allowed** without prompting: `~/code/work/scholastic/**`,
  `~/.config/**` and `~/.opencode/**`.
- **Figma desktop MCP** (`http://127.0.0.1:3845/mcp`) is configured but disabled.
  Set `"enabled": true` while the Figma desktop app's MCP server is running.
- `.zshrc` sets `OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1`, so opencode doesn't load
  Claude Code skills.

## Plugins

| Plugin                  | Does                                                                           |
| ----------------------- | ------------------------------------------------------------------------------ |
| `window-title.js`       | Sets the terminal title to `opencode - <folder>`, so tabs are easy to tell apart |
| `notification-bell.js`  | Plays the macOS Glass sound when opencode asks for permission, asks a question, or goes idle. It rate-limits itself and stays quiet if you typed in the last 2.5 seconds |
