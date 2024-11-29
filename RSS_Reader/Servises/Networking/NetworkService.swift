//
//  NetworkService.swift
//  RSS_Reader
//
//  Created by Elizaveta Eremyonok on 27.11.2024.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    private let baseURL1 = "https://www.vedomosti.ru/info/rss/"
    private let baseURL2 = "http://static.feed.rbc.ru/rbc/internal/rss.rbc.ru/rbc.ru/news.rss/"
    private var newsSection = NewsSection.allCases.first?.rawValue

    func fetchNews(completion: @escaping(Result<[News], Error>) -> Void) {
        guard let newsSection = newsSection else {
            completion(.failure(BaseError(message: "Failed to update data. Try again")))
            return
        }
        
        // Формируем URL для первого источника
        let urlString1 = baseURL1 + newsSection
        // Второй источник использует фиксированный URL, не требующий добавления newsSection
        let urlString2 = baseURL2
        
        guard let url1 = URL(string: urlString1), let url2 = URL(string: urlString2) else {
            completion(.failure(BaseError(message: "Invalid URL")))
            return
        }
        
        // Создаем DispatchGroup для выполнения двух запросов параллельно
        let group = DispatchGroup()
        var fetchedNews1: [News] = []
        var fetchedNews2: [News] = []
        var errorOccurred: Error?

        // Первый запрос
        group.enter()
        fetchData(from: url1) { result in
            switch result {
            case .success(let news):
                fetchedNews1 = news
            case .failure(let error):
                errorOccurred = error
            }
            group.leave()
        }

        // Второй запрос
        group.enter()
        fetchData(from: url2) { result in
            switch result {
            case .success(let news):
                fetchedNews2 = news
            case .failure(let error):
                errorOccurred = error
            }
            group.leave()
        }
        
        // Ожидаем завершения обеих задач
        group.notify(queue: .main) {
            if let error = errorOccurred {
                completion(.failure(error))
                return
            }
            
            // Объединяем новости из обоих источников
            let allFetchedNews = fetchedNews1 + fetchedNews2
            
            if !allFetchedNews.isEmpty {
                completion(.success(allFetchedNews))
            } else {
                completion(.failure(BaseError(message: "No news found from both sources")))
            }
        }
    }
    
    private func fetchData(from url: URL, completion: @escaping (Result<[News], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(BaseError(message: "No data received")))
                return
            }
            
            // Парсинг данных
            let parser = Parser()
            let xmlString = String(data: data, encoding: .utf8) ?? ""
            parser.parse(xmlString: xmlString)
            
            let news = parser.unbindNews()
            completion(.success(news))
        }.resume()
    }
    
    func bindSection(_ text: String) {
        newsSection = text
    }
}
