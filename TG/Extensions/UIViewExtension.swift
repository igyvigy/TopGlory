
import UIKit

extension UIView {
    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else { return nil }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    func createAndConfigureSubview(_ view: UIView?) {
        guard let view = view else { return }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        view.frame = self.frame
        self.addSubview(view)
    }
    
    func addSubview(withConstraints subview:UIView){
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subview
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", metrics: nil, views: viewBindingsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", metrics: nil, views: viewBindingsDict))
    }
    
    func addSubview(centered subview:UIView){
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["superview"] = self
        viewBindingsDict["subview"] = subview
        let centerXOption = NSLayoutFormatOptions.alignAllCenterX
        let centerYOption = NSLayoutFormatOptions.alignAllCenterY
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(<=1)-[subview]", options: centerYOption, metrics: nil, views: viewBindingsDict))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[superview]-(<=1)-[subview]", options: centerXOption, metrics: nil, views: viewBindingsDict))
        NSLayoutConstraint.activate(constraints)
    }
    
    func addSizeConstraint(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}
