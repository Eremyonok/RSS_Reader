
import Foundation

protocol MainViewProtocol: AnyObject {
    func fetchNewsSuccess()
    func fetchNewsFailure(error: Error)
    func startIndicator()
}
