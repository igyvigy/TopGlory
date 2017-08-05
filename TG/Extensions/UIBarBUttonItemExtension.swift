
import UIKit

protocol Control: class {
    var isControlEnabled: Bool { get set }
}

extension UIBarButtonItem: Control {
    var isControlEnabled: Bool {
        get {
            return isEnabled
        }
        set {
            isEnabled = newValue
        }
    }
}

extension UIControl: Control {
    var isControlEnabled: Bool {
        get {
            return isEnabled
        }
        set {
            isEnabled = newValue
        }
    }
}
