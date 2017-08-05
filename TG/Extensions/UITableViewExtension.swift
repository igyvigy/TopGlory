
import UIKit

extension UITableView {
    func register(_ cells: [UITableViewCell.Type]) {
        cells.forEach({
            let cellName = String(describing: $0)
            let nib = UINib(nibName: cellName, bundle: nil)
            register(nib, forCellReuseIdentifier: cellName)
        })
    }
}
