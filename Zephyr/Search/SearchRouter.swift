//
//  SearchRouter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//  
//

import UIKit

// MARK: - SearchRoutable
protocol SearchRoutable {
    func navigateBack(with location: Location?)
}

// MARK: - SearchRouterListener
protocol SearchRouterListener: AnyObject {
    func searchDidClose(with location: Location?)
}

// MARK: - SearchRouter
final class SearchRouter {

    weak var listener: SearchRouterListener?
    weak var viewController: UIViewController?

    init(listener: SearchRouterListener) {
        self.listener = listener
    }
}

// MARK: SearchRoutable
extension SearchRouter: SearchRoutable {
    func navigateBack(with location: Location?) {
        guard let viewController else { return }
        viewController.dismiss(animated: true) { [weak self] in
            self?.listener?.searchDidClose(with: location)
        }
    }
}
