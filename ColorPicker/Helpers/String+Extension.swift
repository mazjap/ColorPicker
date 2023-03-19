import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
    var removingAllWhitespace: Self {
        filter { !$0.isWhitespace }
    }
    
    mutating func removeAllWhitespace() {
        removeAll(where: \.isWhitespace)
    }
}
