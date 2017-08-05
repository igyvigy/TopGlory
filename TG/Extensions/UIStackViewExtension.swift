
import UIKit

extension UIStackView {

    func configureViews(for indices: [Int], isHidden: Bool, animated: Bool = true, completion: @escaping () -> Void) {
        guard !animated else {
            UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
                self.configureViews(for: indices, isHidden: isHidden)
            }) { _ in
                completion()
            }
            return
        }
        configureViews(for: indices, isHidden: isHidden)
        completion()
    }
    
    private func configureViews(for indices: [Int], isHidden: Bool) {
        indices.forEach({
            self.arrangedSubviews[safe: $0]?.isHidden = self.arrangedSubviews[$0].isHidden == isHidden ? self.arrangedSubviews[safe: $0]?.isHidden ?? false : isHidden
        })
        indices.forEach({ self.arrangedSubviews[safe: $0]?.alpha = isHidden ? 0 : 1 })
    }
}
