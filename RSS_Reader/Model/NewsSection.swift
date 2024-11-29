
import Foundation

enum NewsSection: String, CaseIterable {
    case news
    case top7
    case last24
}

extension NewsSection {
    var title: String {
        switch self {
        case .news:
            return "News"
        case .top7:
            return "Top 7"
        case .last24:
            return "Last 24"
            
        }
    }
}
