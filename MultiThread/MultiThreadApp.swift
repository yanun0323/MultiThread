//
//  MultiThreadApp.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import SwiftUI

@main
struct MultiThreadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
                CommandMenu("Edit") {
                    Section {
                        // MARK: - `Select All` -
                        Button("Select All") {
                            NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: nil)
                        }
                        .keyboardShortcut(.a)
                        
                        // MARK: - `Cut` -
                        Button("Cut") {
                            NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: nil)
                        }
                        .keyboardShortcut(.x)
                        
                        // MARK: - `Copy` -
                        Button("Copy") {
                            NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: nil)
                        }
                        .keyboardShortcut(.c)
                        
                        // MARK: - `Paste` -
                        Button("Paste") {
                            NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: nil)
                        }
                        .keyboardShortcut(.v)
                    }
                }
            }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    private var statusItem: NSStatusItem?
    private var popOver = NSPopover()
    private let persistenceController = PersistenceController.shared
    private var mainViewModel = MainViewModel()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        NSApp.appearance = mainViewModel.Setting.Appearance
        
        mainViewModel.PopOver = popOver
        popOver.setValue(true, forKeyPath: "shouldHideAnchor")
        popOver.contentSize = CGSize(width: mainViewModel.Setting.WindowsWidth,
                                     height: mainViewModel.Setting.WindowsHeight)
        popOver.behavior = .transient
        popOver.animates = true
        popOver.contentViewController = NSViewController()
        popOver.contentViewController = NSHostingController(rootView: ContentView()
            .environmentObject(mainViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        )
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        #if DEBUG
        var img = NSImage(systemSymbolName: "ladybug.fill", accessibilityDescription: nil)
        #else
        var img = NSImage(named: "multithread.fill")
        #endif
        
        var config = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
//        config = config.applying(.init(paletteColors: [.darkGray]))
        img = img?.withSymbolConfiguration(config)
        
        if let statusButton = statusItem?.button {
            statusButton.image = img
            statusButton.action = #selector(togglePopover)
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem?.button {
            self.popOver.show(relativeTo:  button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
    }
}


fileprivate struct KeyboardEventModifier: ViewModifier {
    enum Key: String {
        case a, c, v, x
    }
    
    let key: Key
    let modifiers: EventModifiers
    
    func body(content: Content) -> some View {
        content.keyboardShortcut(KeyEquivalent(Character(key.rawValue)), modifiers: modifiers)
    }
}

extension View {
    fileprivate func keyboardShortcut(_ key: KeyboardEventModifier.Key, modifiers: EventModifiers = .command) -> some View {
        modifier(KeyboardEventModifier(key: key, modifiers: modifiers))
    }
}
