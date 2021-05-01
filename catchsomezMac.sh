#!/usr/bin/env bash
#
# author    : felipe mattos
# date      : Feb 2021
# version   : 0.2
#
# purpose   : make macos sleep when battery reaches some level
# remarks   : runs each 60sec, check battery status and if level reaches the defined (set at 15 - you can customize)
#           then warns the user for low level battery; if no action taken in 180sec, system is sent to bed.
# require   : na
#
# how to    : 
#   clone the repo
#   place both com.user.catchsomezmac.plist and catchsomezMac.sh files at ~/Library/LaunchAgents/
#   then:
#   edit ~/Library/LaunchAgents/com.user.catchsomezmac.plist with full catchsomezMac.sh path (line 11)
#   chmod +x ~/Library/LaunchAgents/catchsomezMac.sh
#   launchctl load -w ~/Library/LaunchAgents/com.user.catchsomezmac.plist
#   launchctl list | grep catchsomezmac # confirm it's on launchagents list
#   launchctl start com.user.catchsomezmac # put it in action right away
#
#   uninstall - why would you do that?
#   launchctl stop com.user.catchsomezmac
#   launchctl unload -w ~/Library/LaunchAgents/com.user.catchsomezmac.plist
#   launchctl list 
#   rm ~/Library/LaunchAgents/*catchsomezmac*

# define battery porcentage_limit
_battery_threshold=35

_tstamp=$(date +%m%d%Y%H%M)
# only go on if running on battery
if (pmset -g batt | grep -q "drawing.*from.*Battery"); then
    _current_battery=$(pmset -g batt | grep -o "[0-9]*%" | grep -o "[0-9][0-9]*")
    echo "[INFO]|${_tstamp}|current battery level at ${_current_battery}%" 2>&1
    if [[ "${_current_battery}" -lt "${_battery_threshold}" ]]; then
        # gotcha the battery is lower than defined thold
        echo "[WARN]|${_tstamp}|battery below danger threshold of ${_battery_threshold}%" 2>&1
        _dialog_resp=$(osascript -e 'display dialog "Your battery is dying!\nYour computer will sleep in 3min.\n\nPlug in the AC adapter!" with title "Catch some Z Mac!" with icon stop buttons {"No"} giving up after 180
        if button returned of result = "No" then
            return 1
        end if') 2> /dev/null
        if ((_dialog_resp)); then
            # user said NO
            echo "[INFO]|${_tstamp}|user didnt let me go sleep" 2>&1
            false
        else
            # give up has been reached - check if system still on battery, if so then go to sleep
            if (pmset -g batt | grep -q "drawing.*from.*Battery"); then
                echo "[INFO]|${_tstamp}|Im off to bed... sleeping..." 2>&1
                pmset sleepnow
            fi
        fi
    fi
fi
