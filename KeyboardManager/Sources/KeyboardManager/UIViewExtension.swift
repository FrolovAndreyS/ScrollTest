import UIKit

extension UIView {
    
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
