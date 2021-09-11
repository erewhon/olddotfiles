# write your script here
# tell application "Music" to pause
tell application "System Events"
   tell process "Amazon Music"
     click menu item 1 of menu 1 of menu bar item "Playback" of menu bar 1
   end tell
end tell
