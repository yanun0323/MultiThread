//
//  NSTextView.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/23.
//

import AppKit

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
            enclosingScrollView?.drawsBackground = false
            enclosingScrollView?.hasVerticalScroller = false
            enclosingScrollView?.hasHorizontalScroller = false
        }
    }
}
