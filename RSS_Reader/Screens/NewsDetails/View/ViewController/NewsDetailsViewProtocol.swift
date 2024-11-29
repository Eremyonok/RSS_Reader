

import Foundation

protocol NewsDetailsViewProtocol: AnyObject {
    func fetchArticleSuccess()
    func fetchArticleFailure(error: Error)
}
