
import Foundation

extension Array {
    ///Returns an array containing only the non-nil results
    public static func nonNil(_ array: [Element?]) -> [Element] {
        return array.flatMap { $0 }
    }
}

extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
