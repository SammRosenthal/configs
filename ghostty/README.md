# ghostty

`config` is linked to `~/.config/ghostty/config`.

- **Theme:** GitHub Dark.
- **Font:** Osaka-Mono with ligatures turned off (`-calt`, `-liga`, `-dlig`).
- **Shift+Enter** sends `Esc` + `Enter`. Claude Code reads that as a
  newline in the prompt rather than "submit".

## Handy

The `ghostty` CLI isn't on PATH. It's at
`/Applications/Ghostty.app/Contents/MacOS/ghostty`.

| Action                   | How                                      |
| ------------------------ | ---------------------------------------- |
| Reload the config        | `Cmd+Shift+,`                            |
| Check the config         | `ghostty +validate-config`               |
| List themes              | `ghostty +list-themes`                   |
| See all default keybinds | `ghostty +list-keybinds --default`       |
| See every option         | `ghostty +show-config --default --docs`  |

Don't recreate `~/Library/Application Support/com.mitchellh.ghostty/config`.
Ghostty reads it after the XDG file, so its settings would override this one.
