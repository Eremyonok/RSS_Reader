//
//  Parser.swift
//  RSS_Reader
//
//  Created by Elizaveta Eremyonok on 27.11.2024.
//

import Foundation

class Parser {
    
    private var news: [News] = []
    private var currentTitle: String = ""
    private var currentDescription: String = ""
    private var currentPubDate: String = ""
    private var currentImageURL: String = ""
    private var currentElement: String = ""
    
    // Функция для получения массива новостей
    func unbindNews() -> [News] {
        return news
    }

    // Парсинг XML строки
    func parse(xmlString: String) {
        let itemPattern = "<item>(.*?)</item>"
        let titlePattern = "<title>(.*?)</title>"
        let descriptionPattern = "<description>(.*?)</description>"
        let pubDatePattern = "<pubDate>(.*?)</pubDate>"
        let enclosurePattern = "<enclosure url=\"(.*?)\""

        do {
            let itemRegex = try NSRegularExpression(pattern: itemPattern, options: [])
            let titleRegex = try NSRegularExpression(pattern: titlePattern, options: [])
            let descriptionRegex = try NSRegularExpression(pattern: descriptionPattern, options: [])
            let pubDateRegex = try NSRegularExpression(pattern: pubDatePattern, options: [])
            let enclosureRegex = try NSRegularExpression(pattern: enclosurePattern, options: [])
            
            let itemMatches = itemRegex.matches(in: xmlString, options: [], range: NSRange(location: 0, length: xmlString.utf16.count))
            
            for itemMatch in itemMatches {
                let itemString = (xmlString as NSString).substring(with: itemMatch.range(at: 1))
                
                // Извлекаем данные для каждого <item>
                let titleMatches = titleRegex.matches(in: itemString, options: [], range: NSRange(location: 0, length: itemString.utf16.count))
                currentTitle = titleMatches.first.map { (itemString as NSString).substring(with: $0.range(at: 1)) } ?? "No title"
                
                let descriptionMatches = descriptionRegex.matches(in: itemString, options: [], range: NSRange(location: 0, length: itemString.utf16.count))
                currentDescription = descriptionMatches.first.map { (itemString as NSString).substring(with: $0.range(at: 1)) } ?? "No description"
                
                let pubDateMatches = pubDateRegex.matches(in: itemString, options: [], range: NSRange(location: 0, length: itemString.utf16.count))
                currentPubDate = pubDateMatches.first.map { (itemString as NSString).substring(with: $0.range(at: 1)) } ?? "No date"
                
                let enclosureMatches = enclosureRegex.matches(in: itemString, options: [], range: NSRange(location: 0, length: itemString.utf16.count))
                currentImageURL = enclosureMatches.first.map { (itemString as NSString).substring(with: $0.range(at: 1)) } ?? "No image"
                
                // Создаём объект News и добавляем его в массив
                let newsItem = News(id: currentElement, title: currentTitle, description: currentDescription, date: currentPubDate, pathForImage: currentImageURL)
                news.append(newsItem)
            }
        } catch {
            print("Parsing failed with error: \(error.localizedDescription)")
        }
    }
}

