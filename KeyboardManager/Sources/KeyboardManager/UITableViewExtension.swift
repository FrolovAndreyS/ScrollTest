import UIKit

extension UITableView{
    
    private struct AssociatedKeys {
        static var scrollRectDisabled = "scrollRectDisabled"
    }

    @objc var scrollRectDisabled: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.scrollRectDisabled) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.scrollRectDisabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        guard !scrollRectDisabled else {
            return
        }
        super.scrollRectToVisible(rect, animated: animated)
    }
    
}
