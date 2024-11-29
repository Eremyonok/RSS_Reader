
import Foundation

struct BaseError: Error {
    
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
