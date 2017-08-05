
import UIKit

extension UIFont {
    var baseFontName: String {
        return fontName.components(separatedBy: "-").first ?? fontName
    }
    
    var light: UIFont {
        return UIFont(name: baseFontName+"-Light", size: pointSize) ?? self
    }
}
