//
//  main.swift
//  nextui
//
//  Created by Scott Devine on 1/15/21.
//

import Cocoa

class CustomView: NSView {
    private var currentContext : CGContext? {
        get {
            //assert(#available(OSX 10.10, *))
            return NSGraphicsContext.current?.cgContext
        }
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let context = self.currentContext {
            context.saveGState()
            context.translateBy(x: bounds.minX, y: bounds.minY)
            Draw(context, bounds.width, bounds.height)
            context.restoreGState()
            /*
               ctx.setAllowsAntialiasing(true)
               ctx.setShouldAntialias(true)
               ctx.setFillColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
               ctx.fill(bounds)
               ctx.setLineJoin(.round)
               ctx.setLineCap(.butt)
               ctx.setLineWidth(0.5)
             */
        }
    }
    override var acceptsFirstResponder: Bool { return true }
    func mouseEvent(_ event: NSEvent) {
        let mouseLocation = convert(event.locationInWindow, from: nil)
        //let mouseLocation = view.convert(event.locationInWindow, from: nil)
        if let type = event.cgEvent?.type {
            if MouseEvent(type, mouseLocation.x, mouseLocation.y) == 1 {
                setNeedsDisplay(bounds)
            }
        }
    }
    override func mouseDown(with event: NSEvent) { mouseEvent(event) }
    override func mouseDragged(with event: NSEvent) { mouseEvent(event) }
    override func mouseUp(with event: NSEvent) { mouseEvent(event) }
    override func rightMouseDown(with event: NSEvent) { mouseEvent(event) }
    override func rightMouseDragged(with event: NSEvent) { mouseEvent(event) }
    override func rightMouseUp(with event: NSEvent) { mouseEvent(event) }
    override func otherMouseDown(with event: NSEvent) { mouseEvent(event) }
    override func otherMouseDragged(with event: NSEvent) { mouseEvent(event) }
    override func otherMouseUp(with event: NSEvent) { mouseEvent(event) }
    override func mouseEntered(with event: NSEvent) { mouseEvent(event) }
    override func mouseMoved(with event: NSEvent) { mouseEvent(event) }
    override func mouseExited(with event: NSEvent) { mouseEvent(event) }
    override func keyDown(with event: NSEvent) {
        if let str = event.characters {
            if KeyDown(str) == 1 {
                setNeedsDisplay(bounds)
            }
        }
    }
}

class ViewController : NSViewController, NSWindowDelegate {
    override func loadView() {
        let view = CustomView(frame: NSMakeRect(10,10,100,100))
        //view.wantsLayer = true
        //view.layer?.borderWidth = 2
        //view.layer?.borderColor = NSColor.red.cgColor
        self.view = view
    }
    override func viewDidAppear() {
        self.view.window?.delegate = self
        Setup();
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApplication.shared.terminate(self)
        return true;
    }
    func windowDidResize(_ notification: Notification) {
        //print("windowDidResize")
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var newWindow: NSWindow?
    var controller: ViewController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        newWindow = NSWindow(contentRect: NSMakeRect(0, 100, 300, 300),
                             styleMask: [.miniaturizable,
                             .closable,
                             .resizable,
                             .titled],
                             backing: .buffered,
                             defer: false)

        let content = newWindow!.contentView! as NSView
        controller = ViewController()
        let view = controller!.view
        view.frame = content.bounds
        view.autoresizingMask = [.height, .width]
        content.addSubview(view)

        newWindow!.collectionBehavior = NSWindow.CollectionBehavior.fullScreenPrimary
        newWindow!.title = "A Random App"
        newWindow!.makeKeyAndOrderFront(nil)
    }
}

class AppMenu: NSMenu {
    private lazy var applicationName = ProcessInfo.processInfo.processName
    override init(title: String) {
        super.init(title: title)
        let appleMenuItem = NSMenuItem()
        appleMenuItem.submenu = NSMenu(title: "menuItemOne")

        let serviceMenuItem = NSMenuItem(title: "Services", action: nil, keyEquivalent: "")
        let serviceMenu = NSMenu()
        serviceMenuItem.submenu = serviceMenu
        NSApp.servicesMenu = serviceMenu

        appleMenuItem.submenu?.items = [serviceMenuItem,
                NSMenuItem(
                    title: "Quit \(applicationName)",
                    action: #selector(NSApplication.terminate(_:)),
                    keyEquivalent: "q")]
        items = [appleMenuItem]
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        print("here")
    }
}

let nsapp = NSApplication.shared
nsapp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
let delegate = AppDelegate()
nsapp.delegate = delegate
let menu = AppMenu()
nsapp.mainMenu = menu
//NSMenu.setMenuBarVisible(false)
//NSMenu.setMenuBarVisible(true)
nsapp.activate(ignoringOtherApps:true)
nsapp.run()
//_=NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)


