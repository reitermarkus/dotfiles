#!/usr/bin/env swift

import Cocoa

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    DistributedNotificationCenter.default.addObserver(
      self,
      selector: #selector(interfaceModeChanged(sender:)),
      name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil
    )
  }

  @objc func interfaceModeChanged(sender: NSNotification) {
    let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"

    let script: String!
    if mode == "Dark" {
      script = """
        tell application "Terminal"
          set default settings to settings set "Solarized Dark"
          set current settings of tabs of windows to settings set "Solarized Dark"
        end tell
      """
    } else {
      script = """
        tell application "Terminal"
          set default settings to settings set "Solarized Light"
          set current settings of tabs of windows to settings set "Solarized Light"
        end tell
      """
    }

    print(mode)

    var error: NSDictionary?
    NSAppleScript(source: script)!.executeAndReturnError(&error)

    if let error = error {
      fputs("\(error)\n", stderr)
    }
  }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
