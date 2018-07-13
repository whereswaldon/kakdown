# kakdown

**WARNING:** This project is very new and experimental. Use at your own risk.

Tools for working with Markdown in [Kakoune](https://github.com/mawww/kakoune), including:

 - Simple live markdown rendering
 - Easy table formatting

## Dependencies

You need the [`livemd`](https://github.com/barakmich/livemd) markdown renderer to use the `md-preview` command.

If you have go installed, just run:

```
go get github.com/barakmich/livemd
```

Make sure that `$GOPATH/bin` is in your `$PATH`.

## Installation

Place `kakdown.kak` into `~/.config/kak/autoload/`.

## Commands

All commands are prefixed with `md-`. From normal mode, type `:md-` to see
the available markdown commands.

## Configuration

None is necessary, though you can write hooks to automatically launch
previewing when a markdown file is opened.

I also recommend creating a user mapping for the table format command.

Example configuration:
```
# Register custom hooks whenever I open a markdown file.
# Because the filename filter is a regex, the literal period
# must be escaped
hook global BufCreate .*\.md %{
    # Print in the debug buffer so that I can tell the hook fired
    echo -debug "Markdown Mode Enabled"

    # Automatically launch the preview
    md-preview

    # Create easy user-mode mapping to format tables
    map -docstring "format markdown table under cursor" buffer user t :eval<space>md-format-table<ret>
}
```

## Todo

- [ ] Implement previewing multiple documents at the same time
- [ ] Use a shared `livemd` process to preview all documents
- [ ] Implement a way to re-render on idle or when you exit insert mode

## Contribute

Feature requests and pull requests welcome!

## License

MIT
