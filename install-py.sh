#!/bin/bash

# sudo installer -pkg "./python-3.9.1-macos11.0.pkg" -target "$HOME/Documents/Image-Line/Python-3.9.1" ||:
# osascript -e "tell application \"Installer\" to open POSIX file \"$PWD/python-3.9.1-macos11.0.pkg\"" ||:


PACKAGE_PATH="$PWD/python-3.9.1-macos11.0.pkg"


open "$PACKAGE_PATH"

until pgrep "Python Installer" > /dev/null; do sleep 1; done
while pgrep "Installer" > /dev/null; do sleep 2; done



# Open the package with Installer application using osascript
# osascript -e "tell application \"Installer\" to open POSIX file \"$PACKAGE_PATH\""

# osascript -e "delay 5"


# osascript <<EOF
# tell application "System Events"
#     repeat
#         set pythonWindows to every window of every process whose name contains "Install Python"
#         if pythonWindows is {} then exit repeat
#         delay 2 -- Check every 2 seconds
#     end repeat
# end tell
# EOF

echo "The 'Install Python' Installer window has been closed."

# # Launch the Installer and wait until the "Install Python" window is closed
# osascript <<EOF
# tell application "Finder"
#     open POSIX file "$PACKAGE_PATH" with application "Installer"
# end tell
# delay 5 -- Wait for the Installer app to open the window

# tell application "System Events"
#     repeat until not (exists (window "Install Python" of process "Installer"))
#         delay 2 -- Check every 2 seconds
#     end repeat
# end tell
# EOF

# echo "The 'Install Python' Installer window has been closed."
