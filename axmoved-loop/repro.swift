// Stand-in for apps that report AXMoved on every position write, even
// when the window does not actually move. Run: swift repro.swift
import AppKit

final class ChattyWindow: NSWindow {
    // Accessibility position writes arrive here. AppKit stays silent
    // when the frame is unchanged; this window doesn't
    override func setFrame(_ frameRect: NSRect, display flag: Bool) {
        super.setFrame(frameRect, display: flag)
        NSAccessibility.post(element: self, notification: .moved)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)
let cls: NSWindow.Type =
    CommandLine.arguments.contains("--control") ? NSWindow.self : ChattyWindow.self
// No .resizable: AeroSpace floats windows without a fullscreen button,
// so opening this doesn't retile anything
let window = cls.init(
    contentRect: NSRect(x: 300, y: 300, width: 420, height: 160),
    styleMask: [.titled, .closable],
    backing: .buffered,
    defer: false
)
window.title = "AXMoved repro"
window.isReleasedWhenClosed = false
window.orderFrontRegardless()
app.run()
