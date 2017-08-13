
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

protocol Blurable {
    var isBlurred: Bool { get set }
}

protocol Roundable: class {
    var borderColor: UIColor { get set }
    var borderWidth: CGFloat { get set }
    var cornerRadius: CGFloat { get set }
    var shadowRadius: CGFloat { get set }
    var shadowColor: UIColor { get set }
    var shadowOffset: CGSize { get set }
    var shadowOpacity: Float { get set }
}

extension UIView: Blurable {
    //MARK: - adds ability to blur a UIView
    
    @IBInspectable internal var isBlurred: Bool {
        get {
            return self is UIVisualEffectView
        }
        set {
            guard newValue != isBlurred else { return }
            if newValue {
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.frame
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                backgroundColor = UIColor.clear
                if subviews.count > 0 {
                    insertSubview(blurEffectView, at: 0)
                } else {
                    addSubview(blurEffectView)
                }
            } else {
                subviews.forEach({
                    if $0 is UIVisualEffectView {
                        $0.removeFromSuperview()
                    }
                })
            }
        }
    }
}

//GRADIENT VIEW
internal class GradientViewConfig: NSObject {
    var color1: UIColor = .clear
    var color2: UIColor = .clear
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    var locations: [NSNumber]?
}

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

extension GradientView {
    private struct AssociatedKeys {
        static var gradientConfig = "gradientConfig"
    }
    
    internal var gradientConfig: GradientViewConfig {
        get {
            if let config = objc_getAssociatedObject(self, &AssociatedKeys.gradientConfig) as? GradientViewConfig {
                return config
            }
            let config = GradientViewConfig()
            self.gradientConfig = config
            return config
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.gradientConfig, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @IBInspectable public var grColor1: UIColor {
        get { return gradientConfig.color1 }
        set {
            gradientConfig.color1 = newValue
            apply()
        }
    }
    
    @IBInspectable public var grColor2: UIColor {
        get { return gradientConfig.color2 }
        set {
            gradientConfig.color2 = newValue
            apply()
        }
    }
    
    @IBInspectable public var startPoint: CGPoint {
        get { return gradientConfig.startPoint }
        set {
            gradientConfig.startPoint = newValue
            apply()
        }
    }
    
    @IBInspectable public var endPoint: CGPoint {
        get { return gradientConfig.endPoint }
        set {
            gradientConfig.endPoint = newValue
            apply()
        }
    }
    public var locations: [NSNumber]? {
        get { return gradientConfig.locations }
        set {
            gradientConfig.locations = newValue
            apply()
        }
    }
    private func apply() {
        if let layer = layer as? CAGradientLayer {
            layer.colors = [grColor1.cgColor, grColor2.cgColor]
            layer.startPoint = startPoint
            layer.endPoint = endPoint
            layer.locations = locations
        }
    }
}
