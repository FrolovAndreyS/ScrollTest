import ReactiveDataDisplayManager
import UIKit

final class KeyboardPlugin: BaseTablePlugin<TableEvent> {

    private weak var tableView: UITableView?
    private weak var textField: UIView?
    private weak var scrollView: UIScrollView?
    private var keyboardFrame: CGRect?

    public override func setup(with manager: BaseTableManager?) {
        tableView = manager?.view
        configureEvents()
    }

    override func process(event: TableEvent, with manager: BaseTableManager?) {

    }

    private func configureEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(textBeginEditing(_:)),
                                               name: UITextField.textDidBeginEditingNotification, object: nil)
    }

    @objc
    func keyboardWillShow(_ notification: Notification?) {
        if let info = notification?.userInfo {
            if let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardFrame = kbFrame
            }
        }
    }

    @objc
    func textBeginEditing(_ notification: Notification?) {
        textField = notification?.object as? UIView
        scrollView = textField?.superviewOfClassType(UIScrollView.self) as? UIScrollView
        if let textField = textField, let kbFrame = keyboardFrame {
            scrollView?.scrollToView(textField, bottomIndent: kbFrame.height + 20)
        }
    }

}

private extension UIView {

    func superviewOfClassType(_ classType: UIView.Type, belowView: UIView? = nil) -> UIView? {

        var superView = superview

        while let unwrappedSuperView = superView {

            if unwrappedSuperView.isKind(of: classType) {

                //If it's UIScrollView, then validating for special cases
                if unwrappedSuperView.isKind(of: UIScrollView.self) {

                    let classNameString = NSStringFromClass(type(of: unwrappedSuperView.self))

                    //  If it's not UITableViewWrapperView class, this is internal class which is actually manage in UITableview. The speciality of this class is that it's superview is UITableView.
                    //  If it's not UITableViewCellScrollView class, this is internal class which is actually manage in UITableviewCell. The speciality of this class is that it's superview is UITableViewCell.
                    //If it's not _UIQueuingScrollView class, actually we validate for _ prefix which usually used by Apple internal classes
                    if unwrappedSuperView.superview?.isKind(of: UITableView.self) == false,
                        unwrappedSuperView.superview?.isKind(of: UITableViewCell.self) == false,
                        classNameString.hasPrefix("_") == false {
                        return superView
                    }
                } else {
                    return superView
                }
            } else if unwrappedSuperView == belowView {
                return nil
            }

            superView = unwrappedSuperView.superview
        }

        return nil
    }

}
