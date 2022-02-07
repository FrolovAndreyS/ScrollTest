//
//  ScrollPositionManager.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import Utils
import UIKit

/// Включает в себя необходимые параметры для cкролла
///
/// - Parameters:
///     - offset: включает в себя высоту элементов над клавиатурой в случае их существования.
///     - inset: позволяет дополнительно расширить область view, которая должна быть видимой.
struct ScrollParameters {

    // MARK: - Properties

    var offset: CGFloat
    var inset: CGFloat?
    weak var scrollView: UIScrollView?
    private(set) var previousScrollViewInsets: UIEdgeInsets

    // MARK: - Initialization

    init(scrollView: UIScrollView?, offset: CGFloat = 0) {
        self.scrollView = scrollView
        self.offset = offset
        previousScrollViewInsets = scrollView?.contentInset ?? .zero
    }

    // MARK: - Methods

    mutating func updateInitialInsets() {
        previousScrollViewInsets = scrollView?.contentInset ?? .zero
    }

}

protocol ParametersPositinable {

    associatedtype Parameters
    init(_ parameters: Parameters)

}


final class ScrollPositionManager: ParametersPositinable {

    // MARK: - Constants

    private enum Constants {
        static let defaultFieldInset: CGFloat = 30
        static let defaultDelayToUpdate: TimeInterval = 0.1
    }

    // MARK: - Private Properties

    private var parameters: ScrollParameters
    private var keyboardHeight: CGFloat = 0
    private var activeField: UIView? {
        didSet {
            checkScrollingNeeded()
        }
    }

    // MARK: - Initialization

    init(_ parameters: ScrollParameters) {
        self.parameters = parameters
    }

    // MARK: - Methods

    func updateContentInsets() {
        parameters.updateInitialInsets()
    }

    func setActiveField(_ view: UIView?, inset: CGFloat = 0) {
        activeField = view
        parameters.inset = inset + Constants.defaultFieldInset
    }

    func scrollIfNeeded() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.defaultDelayToUpdate) {
            self.scroll()
        }
    }

}

// MARK: - CommonKeyboardPresentable

extension ScrollPositionManager: CommonKeyboardPresentable {

    func keyboardWasShown(keyboardHeight: CGFloat, duration: TimeInterval) {
    }

    func keyboardWasHidden(duration: TimeInterval) {
    }

    func keyboardWillBeShown(keyboardHeight: CGFloat, duration: TimeInterval) {
        self.keyboardHeight = keyboardHeight
        self.scroll()
    }

    func keyboardWillBeHidden(duration: TimeInterval) {
        parameters.scrollView?.contentInset = parameters.previousScrollViewInsets
        self.keyboardHeight = 0
    }

}

// MARK: - Helpers

private extension ScrollPositionManager {

    func checkScrollingNeeded() {
        guard keyboardHeight > 0 else {
            return
        }
        DispatchQueue.main.async { [weak self, keyboardHeight] in
            guard keyboardHeight == self?.keyboardHeight else {
                return
            }
            self?.scroll()
        }
    }

    func scroll() {
        guard let view = activeField else {
            return
        }
        parameters.scrollView?.scrollToView(view, bottomIndent: keyboardHeight + parameters.offset, inset: parameters.inset ?? 0)
    }

}
