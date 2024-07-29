//
//  KeyEventHandlingView.swift
//  TetrisSwiftUI
//
//  Created by Adrian on 2024-07-29.
//

import SwiftUI

struct KeyEventHandlingView: NSViewRepresentable {
    var keyDownHandler: (NSEvent) -> Void

    class NSViewWithKeyHandling: NSView {
        var keyDownHandler: (NSEvent) -> Void

        init(frame frameRect: NSRect, keyDownHandler: @escaping (NSEvent) -> Void) {
            self.keyDownHandler = keyDownHandler
            super.init(frame: frameRect)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var acceptsFirstResponder: Bool {
            return true
        }

        override func keyDown(with event: NSEvent) {
            keyDownHandler(event)
        }
    }

    func makeNSView(context: Context) -> NSViewWithKeyHandling {
        let nsView = NSViewWithKeyHandling(frame: .zero, keyDownHandler: keyDownHandler)
        DispatchQueue.main.async {
            nsView.window?.makeFirstResponder(nsView)
        }
        return nsView
    }

    func updateNSView(_ nsView: NSViewWithKeyHandling, context: Context) {
        // No update needed
    }
}
