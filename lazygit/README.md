# lazygit

`config.yml` is linked to `~/.config/lazygit/config.yml`. Start it with `lg`
(zsh alias).

The only customisation: `e` opens the selected file in **nvim**
(`editPreset: nvim`).

## Keys worth remembering

| Key        | Does                                          |
| ---------- | --------------------------------------------- |
| `?`        | Keybindings for the current panel             |
| `1`–`5`    | Jump to a panel (status, files, branches, commits, stash) |
| `space`    | Stage / unstage a file or hunk                |
| `a`        | Stage / unstage everything                    |
| `Enter`    | Open a file to stage individual hunks or lines |
| `c`        | Commit                                        |
| `A`        | Amend the last commit                         |
| `P` / `p`  | Push / pull                                   |
| `n`        | New branch (in branches)                      |
| `r`        | Rebase onto the selected branch (in branches) |
| `s`        | Squash into the commit below (in commits)     |
| `z` / `Z`  | Undo / redo (reflog-based)                    |
| `e`        | Edit the file in nvim                         |
| `q`        | Quit                                          |
