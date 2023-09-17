//
//  SearchBuilder.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//  
//

import UIKit

struct SearchBuilder {
    func build(
        listener: SearchRouterListener
    ) -> UIViewController {
        let interactor = SearchInteractor()
        let router = SearchRouter(listener: listener)
        let presenter = SearchPresenter(
            interactor: interactor,
            router: router
        )
        let viewController  = SearchViewController(presenter: presenter)
        presenter.view = viewController
        interactor.listener = presenter
        router.viewController = viewController
        return viewController
    }
}
