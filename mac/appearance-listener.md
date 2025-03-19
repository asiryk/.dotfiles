# Appearance Listener hook

A guide on how to run ./appearance-listener.swift automatically on system startup.

1. Create plist file

`~/Library/LaunchAgents/com.asiryk.appearance-change.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.asiryk.appearance-change</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/swift</string>
    <string>/Users/asiryk/.dotfiles/mac/appearance-listener.swift</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <!--<key>StandardOutPath</key><string>/tmp/appearance-change.out.log</string>-->
  <!--<key>StandardErrorPath</key><string>/tmp/appearance-change.err.log</string>-->
</dict>
</plist>
```

2. Reload it (should be added to login items

launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.asiryk.appearance-change.plist 2>/dev/null
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.asiryk.appearance-change.plist

---

Debugging:

1. Uncomment StandardOutPath, StandardErrorPath
2. `tail -n50 /tmp/appearance-change.err.log`

