//
//  KeyboardManager.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import Utils
import CoreGraphics
import Foundation

final class KeyboardPositionManager: KeyboardObservable {

    // MARK: - Private Properties

    private var handlers: [CommonKeyboardPresentable] = []

    // MARK: - Initialization

    init(_ handlers: [CommonKeyboardPresentable]) {
        self.handlers = handlers
    }

}

// MARK: - CommonKeyboardPresentable

extension KeyboardPositionManager: CommonKeyboardPresentable {

    func keyboardWillBeShown(keyboardHeight: CGFloat, duration: TimeInterval) {
        handlers.forEach { $0.keyboardWillBeShown(keyboardHeight: keyboardHeight, duration: duration) }
    }

    func keyboardWillBeHidden(duration: TimeInterval) {
        handlers.forEach { $0.keyboardWillBeHidden(duration: duration) }
    }

}
