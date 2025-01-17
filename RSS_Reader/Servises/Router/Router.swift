
import UIKit

class Router: RouterProtocol {
    var navigationController: UINavigationController
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        guard let viewController = assemblyBuilder?.createMainViewController(router: self) else { return }
        navigationController.viewControllers = [viewController]
    }
    
    func moveToNewsDetails(news: News) {
        guard let newsDetailsViewController = assemblyBuilder?.createNewsDetailsViewController(news: news, router: self) else { return }
        navigationController.pushViewController(newsDetailsViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
