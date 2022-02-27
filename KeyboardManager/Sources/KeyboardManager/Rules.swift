import UIKit

public enum AutoScrollMode: Hashable {
    case toCenter(offset: CGFloat)
    case dontScrollIfVisible
}

public enum KeyboardManagerRules: Hashable {
    case autoScroll(mode: AutoScrollMode)
    case encreaseConstraintAboveKeyboard(constraint: NSLayoutConstraint, offset: CGFloat)
}
