
import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
    func initialViewController()
    func moveToNewsDetails(news: News)
    func popViewController()
}
