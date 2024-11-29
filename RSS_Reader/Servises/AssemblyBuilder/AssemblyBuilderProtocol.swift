
import UIKit

protocol AssemblyBuilderProtocol {
    func createMainViewController(router: RouterProtocol) -> UIViewController
    func createNewsDetailsViewController(news: News, router: RouterProtocol) -> UIViewController
}
