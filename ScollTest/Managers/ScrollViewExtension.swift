//
//  ScrollViewExtension.swift
//  ScollTest
//
//  Created by frolov on 21.01.2022.
//

import UIKit

extension UIScrollView {

    // MARK: - Constants

    private enum Constants {
        static let defaultSetOffsetDuration: TimeInterval = 0.2
    }

    /// The method allows to update the state of the scroll view
    /// so that the transmitted view lying on it becomes visible and is not closed by the keyboard.
    ///
    /// - Parameters:
    ///     - view: View, which should not end up being closed by the keyboard.
    ///     - bottomIndent: bottom indent, includes the height of the keyboard and some elements above it if they exist.
    ///     - inset: makes it possible to further expand the area of view that should be visible.
    func scrollToView(_ view: UIView, bottomIndent: CGFloat, inset: CGFloat = 30) {
        guard let requiredInset = getInset(view, bottomIndent, inset),
            handleScrollUp(requiredInset, bottomIndent, inset) || handleScrollDown(requiredInset, bottomIndent, inset) else {
                return
        }
    }

    /// Set custom color above table
    func addTopBounceAreaView(color: UIColor = .white) {
        /// addtionalHeight is needed to fix problem with showing a stripe with background color on the top of scroll view
        /// for example, when view controller is scrolled fast on opening/closing
        let addtionalHeight: CGFloat = 3

        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height + addtionalHeight
        let view = UIView(frame: frame)
        view.backgroundColor = color
        addSubview(view)
    }

}

// MARK: - Helpers

private extension UIScrollView {

    typealias Insets = (regular: CGFloat, max: CGFloat)

    func getInset(_ view: UIView, _ bottomIndent: CGFloat, _ inset: CGFloat) -> Insets? {
        guard let window = UIApplication.shared.keyWindow, let superview = superview else {
            return nil
        }

        let keyboardMinY = window.bounds.height - bottomIndent
        let origin = CGPoint(x: .zero, y: inset)
        let viewMaxY = view.convert(origin, to: window).y + view.bounds.height

        let maxInset = superview.convert(CGPoint.zero, to: view).y

        return (viewMaxY - keyboardMinY, maxInset)
    }

    func handleScrollUp(_ insets: Insets, _ bottomIndent: CGFloat, _ inset: CGFloat) -> Bool {
        guard insets.max <= 0 else {
            return false
        }
        guard insets.regular > 0 else {
            return true
        }

        let scrollInset = min(-insets.max, insets.regular)
        setInset(scrollInset, bottomIndent, inset)

        return true
    }

    func handleScrollDown(_ insets: Insets, _ bottomIndent: CGFloat, _ inset: CGFloat) -> Bool {
        guard insets.max > 0 else {
            return false
        }
        setInset(-insets.max, bottomIndent, inset)

        return true
    }

    func setInset(_ value: CGFloat, _ bottomIndent: CGFloat, _ inset: CGFloat) {
        UIViewPropertyAnimator(duration: Constants.defaultSetOffsetDuration, curve: .linear) { [weak self] in
            self?.contentOffset.y += value
        }.startAnimation()
    }

}
