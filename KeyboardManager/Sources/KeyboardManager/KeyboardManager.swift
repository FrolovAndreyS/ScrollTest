import UIKit

class KeyboardManager: NSObject {
    
    private weak var viewController: UIViewController?
    private weak var tableView: UITableView?
    private var scrollMode: AutoScrollMode?
    private weak var constraint: NSLayoutConstraint?
    private var constraintOffset: CGFloat?
    private var constraintDefaultValue: CGFloat?
    private var taskPool: [(() -> Void)] = []
    private var keyboardFrame: CGRect?
    private weak var currentTextField: UIView?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func enableRules(rules: Set<KeyboardManagerRules>) {
        
        rules.forEach {
            switch $0 {
            case .autoScroll(let mode):
                scrollMode = mode
            case .encreaseConstraintAboveKeyboard(let constraint, let offset):
                self.constraint = constraint
                self.constraintOffset = offset
                self.constraintDefaultValue = constraint.constant
            }
        }
        
        registerNotifications()
    }
    
}

extension KeyboardManager {
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.textBeginEditing(_:)),
            name: UITextField.textDidBeginEditingNotification,
            object: nil
        )
    }
    
    func unregisterNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UITextField.textDidBeginEditingNotification,
            object: nil
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification?) {
        if let info = notification?.userInfo {
            if let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardFrame = kbFrame
            }
        }
        encreaseConstraint()
        taskPool.forEach {
            $0()
        }
        taskPool.removeAll()
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification?) {
        restoreConstraint()
    }
    
    @objc
    func textBeginEditing(_ notification: Notification?) {
        currentTextField = notification?.object as? UIView
        tableView = (currentTextField?.superviewOfClassType(UITableView.self) as? UITableView)
        tableView?.scrollRectDisabled = true
        adjastPosition()
    }
    
    func adjastPosition() {
        guard let keyboardFrame = keyboardFrame else {
            taskPool.append(adjastPosition)
            return
        }
        guard let textField = currentTextField,
              let tableView = tableView,
              let scrollMode = scrollMode
        else {
            return
        }
        
        switch scrollMode {
        case .toCenter(let offset):
            scrollToCenter(
                textField: textField,
                tableView: tableView,
                keyboardFrame: keyboardFrame,
                offset: offset
            )
        case .dontScrollIfVisible:
            return
        }
    }
    
    func scrollToCenter(
        textField: UIView,
        tableView: UITableView,
        keyboardFrame: CGRect,
        offset: CGFloat
    ) {
        let y = (tableView.frame.height - keyboardFrame.height) / 2 - textField.frame.height / 2 - offset
        let localY = textField.convert(.init(x: .zero, y: y), to: tableView).y
        let maxHeight = -tableView.contentInset.top + tableView.contentSize.height - tableView.frame.height
        let localYWithMin = max(localY, 0)
        let localYWithMinAndMax = min(localYWithMin, maxHeight)
        
        UIView.animate(withDuration: 0.3) {
            tableView.contentOffset.y = localYWithMinAndMax
        }
    }
    
    func encreaseConstraint() {
        guard let keyboardFrame = keyboardFrame,
              let constraint = constraint,
              let offset = constraintOffset
        else {
            return
        }
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? .zero
            constraint.constant = keyboardFrame.height + offset - bottomPadding
        } else {
            constraint.constant = keyboardFrame.height + offset
        }
        viewController?.view.layoutSubviews()
    }
    
    func restoreConstraint() {
        guard let constraint = constraint,
              let defaultValue = constraintDefaultValue
        else {
            return
        }
        constraint.constant = defaultValue
        viewController?.view.layoutSubviews()
    }
    
}
