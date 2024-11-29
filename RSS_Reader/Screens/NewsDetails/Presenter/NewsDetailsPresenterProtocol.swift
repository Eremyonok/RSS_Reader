import Foundation

protocol NewsDetailsPresenterProtocol: AnyObject {
    init(view: NewsDetailsViewProtocol, router: RouterProtocol, news: News?)
    var news: News? { get }
    func backButtonTap()
}
