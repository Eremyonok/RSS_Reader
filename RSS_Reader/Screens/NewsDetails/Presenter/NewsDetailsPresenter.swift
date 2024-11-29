//
//  NewsDetailsPresenter.swift
//  RSS_Reader
//
//  Created by Elizaveta Eremyonok on 27.11.2024.
//

import Foundation

class NewsDetailsPresenter: NewsDetailsPresenterProtocol {
    
    weak var view: NewsDetailsViewProtocol?
    private let router: RouterProtocol
    var news: News?
    
    required init(view: NewsDetailsViewProtocol, router: RouterProtocol, news: News?) {
        self.view = view
        self.router = router
        self.news = news
    }
    
    func backButtonTap() {
        router.popViewController()
    }
}
