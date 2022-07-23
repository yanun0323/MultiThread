//
//  NSTableView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import AppKit
import SwiftUI

extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        backgroundColor = NSColor.clear
        enclosingScrollView!.drawsBackground = false
        enclosingScrollView!.hasVerticalScroller = false
        enclosingScrollView!.hasHorizontalScroller = false
    }
}
