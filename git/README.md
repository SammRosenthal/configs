# git

| Repo file                  | Linked to                 |
| -------------------------- | ------------------------- |
| `gitconfig`                | `~/.gitconfig`            |
| `ignore`                   | `~/.config/git/ignore`    |
| `gitconfig-work.example`   | template for `~/.gitconfig-work` (untracked) |

## What the config does

- **Signed commits and tags** with an SSH key (`~/.ssh/id_ed25519_signing.pub`).
  GitHub shows them as Verified once that key is added as a *signing* key.
- **Merge commits always:** `merge.ff = no` and `pull.ff = no`. `git pull`
  creates a merge commit rather than fast-forwarding. Use `git pull --rebase`
  or `git pull --ff-only` for a one-off.
- **delta** as the pager for `diff`, `log -p` and `show`, with line numbers and
  the Monokai Extended theme.
- **Work identity:** inside `~/code/work/scholastic/`, git also reads
  `~/.gitconfig-work`, which overrides `user.email`. Check which identity a repo
  uses with `git config user.email`.

## Global ignore

Ignored in every repo: `.DS_Store`, `.vscode`, Java IDE metadata (`.project`,
`.classpath`, `.factorypath`, `.settings/`), and AI tooling and notes (`.claude`,
`CLAUDE.local.md`, `AGENTS.md`, `.cursorrules`, `local-docs/`).

Because `.claude` is ignored globally, a project that wants to commit its
`.claude/settings.json` has to un-ignore it in its own `.gitignore`
(`!.claude/`) or add the file with `git add -f`.

`git check-ignore -v <path>` shows which rule ignores a file.
