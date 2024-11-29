//
//  MainPresenter.swift
//  RSS_Reader
//
//  Created by Elizaveta Eremyonok on 27.11.2024.
//

import Foundation

class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewProtocol?
    private let router: RouterProtocol
    private let networkService: NetworkServiceProtocol
    private let realmManager = RealmManager()  // Добавляем правильное использование RealmManager
    private let userDefaults = UserDefaults.standard
    var news = [News]()
    var viewedNews = [String]()
    static let key = "viewedNewsKey"
    
    required init(view: MainViewProtocol, router: RouterProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        fetchNews()
        self.viewedNews = loadViewedNews()
    }
    
    func fetchNews() {
        networkService.fetchNews { result in
            switch result {
            case .success(let news):
                self.news = news
                DispatchQueue.global(qos: .background).async {
                    self.news.forEach { newsItem in
                        // Передаем completion handler, который сообщит об успешном сохранении
                        self.realmManager.saveNews(newsItem) { success in
                            if success {
                                print("News item saved successfully: \(newsItem.title)")
                            } else {
                                print("Failed to save news item: \(newsItem.title)")
                            }
                        }
                    }
                }
                self.view?.fetchNewsSuccess()
            case .failure(let error):
                self.news = self.realmManager.loadNews().map { newsItem in
                    // Преобразуем объекты из Realm в объекты News
                    News(id: newsItem.id, title: newsItem.title, description: newsItem.descriptionText, date: newsItem.publishedDate, pathForImage: newsItem.imageURL)
                }
                self.view?.fetchNewsFailure(error: error)
            }
        }
    }
    
    func checkArticleViewed(with id: String) -> Bool {
        return viewedNews.contains(id)
    }
    
    func moveToNewsDetails(news: News) {
        router.moveToNewsDetails(news: news)
    }
    
    func saveViewedNews(_ news: [String]) {
        userDefaults.set(news, forKey: MainPresenter.key)
    }
    
    func loadViewedNews() -> [String] {
        return userDefaults.stringArray(forKey: MainPresenter.key) ?? []
    }
    
    func changeNewsSection(_ newsSection: NewsSection) {
        networkService.bindSection(newsSection.rawValue)
        self.view?.startIndicator()
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            self.fetchNews()
        }
    }
}
