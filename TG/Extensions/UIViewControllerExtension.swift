
import Foundation
import UIKit
import Whisper

typealias TGOwner = UIViewController

let alertTintColorConstant = UIColor.blue

extension UIViewController {
    func showCreationAlert(with message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "a title for error message popup"), message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("OK", comment: "a label preceding the ok button in a error message popup"), style: .default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.view.tintColor = TGColors.darkGreen
        present(alertController, animated: true, completion: nil)
    }
    
    func showActionConfirmation(with title: String = NSLocalizedString("You sure?", comment: "the default message title for a case when user needs to confirm an action"),
                                message: String? = nil,
                                confirmationTitle: String = NSLocalizedString("OK", comment: "a label preceding the default ok button in a confirmation popup"),
                                confirmationStyle: UIAlertActionStyle = .default,
                                confirmationHandler: @escaping Completion) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmationTitle, style: confirmationStyle) { _ in
            confirmationHandler()
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "a label preceding the cancelation button in a confirmation popup"), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = TGColors.darkGreen
        present(alertController, animated: true, completion: nil)
    }
    
    func removeTitleFromNavigationBarBackButton() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    func showLoader(message: String) {
        let murmur = Murmur(title: message, backgroundColor: TGColors.blue, titleColor: .white) {
        }
        Whisper.show(whistle: murmur, action: .present)
    }
    
    func showError(message: String, completion: Completion? = nil) {
        let interval: TimeInterval = 2
        let murmur = Murmur(title: message, backgroundColor: UIColor(hexString: "#E5A9A9"), titleColor: UIColor.white)
        Whisper.show(whistle: murmur, action: .show(interval))
        DispatchQueue.main.asyncAfter(deadline: .now() + interval + 0.25) {
            completion?()
        }
    }
    
    func hideCurrentWhisper(completion: Completion? = nil) {
        let interval: TimeInterval = 0.5
        Whisper.hide(whistleAfter: interval)
        DispatchQueue.main.asyncAfter(deadline: .now() + interval + 0.25) {
            completion?()
        }
    }
    
    static func presentedVC() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}

protocol KeyboardHandlingViewControllerDelegate: class {
    func keyboardWillAppear(withFrame keyboardFrame: CGRect?)
    func keyboardWillChange(frame keyboardFrame: CGRect?)
    func keyboardWillHide()
}

class KeyboardHandlingViewController: UIViewController {
    weak var keyboardHandlingDelegate: KeyboardHandlingViewControllerDelegate?
}

extension KeyboardHandlingViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_: )), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_: )), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_: )), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            keyboardHandlingDelegate?.keyboardWillChange(frame: endFrame)
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func keyboardWillShow(_ notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        keyboardHandlingDelegate?.keyboardWillAppear(withFrame: keyboardFrame)
    }
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHandlingDelegate?.keyboardWillHide()
    }
}
