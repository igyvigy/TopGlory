
import UIKit
import Whisper

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}
