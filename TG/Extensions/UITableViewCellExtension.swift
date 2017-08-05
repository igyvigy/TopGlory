
import UIKit

protocol CellInitializer {}
extension UITableViewCell: CellInitializer {}

extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension CellInitializer where Self: UITableViewCell {
    static func dequeued(with identifier: String, by tableView: UITableView) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError("no cell for identifier: \(identifier) on tableView: \(tableView)")
        }
        return cell as! Self
    }
    
    static func dequeued(by tableView: UITableView) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) else {
            fatalError("no cell for identifier: \(self.cellIdentifier) on tableView: \(tableView)")
        }
        return cell as! Self
    }
}
