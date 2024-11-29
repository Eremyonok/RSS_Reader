//
//  RealmManager.swift
//  RSS_Reader
//
//  Created by Elizaveta Eremyonok on 27.11.2024.
//

import Foundation
import RealmSwift

class NewsItem: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var publishedDate: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmManager {
    
    private lazy var realm: Realm = {
        do {
            return try Realm()  // Экземпляр Realm создается здесь
        } catch {
            fatalError("Error initializing Realm: \(error.localizedDescription)")
        }
    }()
    
    // Асинхронное сохранение новостей в Realm
    func saveNews(_ news: News, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let newsItem = NewsItem()
            newsItem.id = news.id
            newsItem.title = news.title
            newsItem.descriptionText = news.description
            newsItem.imageURL = news.pathForImage ?? ""
            newsItem.publishedDate = news.date
            
            DispatchQueue.main.async {
                do {
                    try self.realm.write {
                        self.realm.add(newsItem, update: .modified)  // Обновляем, если новость уже существует
                    }
                    completion(true)  // Возвращаем результат на главный поток
                } catch {
                    print("Error saving news to Realm: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    // Загрузка новостей с Realm
    func loadNews() -> [NewsItem] {
        // Получаем данные из Realm в текущем потоке
        let results = realm.objects(NewsItem.self)
        return Array(results)
    }
    
    // Очистка данных в Realm (если нужно)
    func clearNews() {
        DispatchQueue.global(qos: .background).async {
            do {
                try self.realm.write {
                    let allNews = self.realm.objects(NewsItem.self)
                    self.realm.delete(allNews)
                }
            } catch {
                print("Error clearing news from Realm: \(error.localizedDescription)")
            }
        }
    }
}
