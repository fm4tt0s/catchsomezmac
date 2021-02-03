# Catch Some Zs Mac

Make MacOS catch some Zs (whereas 'sleep') when X battery level is reached

# what?

Runs each 60sec, and if running on battery check its status and in case level reaches the defined  threshold (set at 35 - you can customize it thru _battery_threshold variable on top of catchsomezMac.sh script - shoots a dialog asking to sleep.

# how to

- clone the repo
- place both com.user.catchsomezmac.plist and catchsomezMac.sh files at ~/Library/LaunchAgents/
- edit ~/Library/LaunchAgents/com.user.catchsomezmac.plist with full catchsomezMac.sh path (line 11)

<pre>chmod +x ~/Library/LaunchAgents/catchsomezMac.sh
launchctl load -w ~/Library/LaunchAgents/com.user.catchsomezmac.plist
launchctl list | grep catchsomezmac # confirm it's on launchagents list
launchctl start com.user.catchsomezmac # put it in action right away</pre>

## uninstall

why would you do that?

<pre>launchctl stop com.user.catchsomezmac
launchctl unload -w ~/Library/LaunchAgents/com.user.catchsomezmac.plist
launchctl list | grep catchsomezmac # confirm it gone from launchagents list
rm ~/Library/LaunchAgents/*catchsomez*</pre>
