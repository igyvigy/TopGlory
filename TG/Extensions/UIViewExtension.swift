
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
}
