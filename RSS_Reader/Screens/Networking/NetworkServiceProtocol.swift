//
//  NetworkServiceProtocol.swift
//  RSS_Reader
//
//  Created by Elizaveta Eremyonok on 27.11.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchNews(completion: @escaping(Result<[News], Error>) -> Void)
    func bindSection(_ text: String)
}
