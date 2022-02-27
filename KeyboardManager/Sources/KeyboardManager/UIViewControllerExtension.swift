import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var keyboardManager = "keyboardManager"
    }

    @objc var keyboardManager: KeyboardManager? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.keyboardManager) as? KeyboardManager
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.keyboardManager, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func enubleKeyboardManager(with rules: Set<KeyboardManagerRules>) {
        let manager = KeyboardManager(viewController: self)
        manager.enableRules(rules: rules)
        self.keyboardManager = manager
    }
    
}
