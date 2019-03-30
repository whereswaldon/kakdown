# This command will align the columns in a markdown table if your current selection is within that table.
define-command -override -docstring "Format the markdown table under the cursor" md-format-table %{
        # select the current "paragraph", which should map to a markdown table
        execute-keys <a-i>p
        # select all whitespace surrounding a pipe
        execute-keys s[<space>\t]*\|[<space>\t]*<ret>
        # collapse selections to single spaces before and after the pipe
        execute-keys c<space>|<space><esc>
        # adjust cursors to be selecting the pipes
        execute-keys 2h
        # align them
        execute-keys &
        # clear selections
        execute-keys <space>
        # select the current "paragraph", which should map to a markdown table
        execute-keys <a-i>p
        # delete leading and trailing whitespace at beginning and end of line
        execute-keys s(^<space>)|(<space>$)<ret>d
        # clear selections
        execute-keys <space>
}

# This command launches a new firefox tab to preview the current markdown document live.
# The preview will update every time you write the file.
# It depends on the `livemd` utility on Github
define-command -override -docstring "Start live-previewing this document" md-preview %{
        %sh{
        if ! which livemd > /dev/null 2>&1 ; then
        	echo "echo -debug 'missing dependency *livemd*'"
        	echo "echo -debug 'https://github.com/barakmich/livemd'"
		exit
    	fi
            livemd -port 9999 > $HOME/.cache/livemd.log < /dev/null 2>&1 &
            # This gross hack is apparently the only reliable way to open a new Firefox tab on a Mac.
            if uname -a | grep Darwin > /dev/null 2>&1; then # It's macOS
                cat > /tmp/ffnewtab.scpt <<EOF
on firefoxRunning()
	tell application "System Events" to (name of processes) contains "Firefox"
end firefoxRunning

on run argv

	if (firefoxRunning() = false) then
		do shell script "open -a Firefox " & (item 1 of argv)
	else
		tell application "Firefox" to activate

		tell application "System Events"
			keystroke "t" using {command down}
			keystroke item 1 of argv & return
		end tell
	end if
end run
EOF
            osascript /tmp/ffnewtab.scpt "localhost:9999/md/$(basename $kak_buffile)" > $HOME/.cache/firefox-livemd.log < /dev/null 2>&1 &
            else # Linux/BSD
                firefox -new-tab "localhost:9999/md/$(basename $kak_buffile)" > $HOME/.cache/firefox-livemd.log < /dev/null 2>&1 &
            fi
        }
}
