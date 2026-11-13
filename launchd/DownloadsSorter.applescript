-- Wrapper app for bin/sort-downloads. macOS only lets an app (not a bare shell script started by
-- launchd) read ~/Downloads, so the LaunchAgent opens this app and the app runs the script.
-- install.sh fills in __SCRIPT__ and __LOG__.
on run
	do shell script "/bin/zsh " & quoted form of "__SCRIPT__" & " >> " & quoted form of "__LOG__" & " 2>&1"
end run
