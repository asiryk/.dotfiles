#!/usr/bin/swift
import AppKit

class ThemeObserver: NSObject {
    @objc func themeChanged(_ notification: Notification) {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["fish", "-lc", "on_macos_appearance_change"]
        task.launch()
    }
}

let observer = ThemeObserver()
DistributedNotificationCenter.default().addObserver(
    observer,
    selector: #selector(ThemeObserver.themeChanged(_:)),
    name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil
)

// Start the Cocoa run loop so notifications arrive
NSApplication.shared.run()
