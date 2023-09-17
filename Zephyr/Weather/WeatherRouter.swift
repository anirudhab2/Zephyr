//
//  WeatherRouter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//  
//

import UIKit

// MARK: - WeatherRoutable
protocol WeatherRoutable {
    func navigateToSearch()
}

// MARK: - WeatherRouterListener
protocol WeatherRouterListener: AnyObject {
    func updateLocation(with location: Location)
}

// MARK: - WeatherRouter
final class WeatherRouter {

    weak var listener: WeatherRouterListener?
    weak var viewController: UIViewController?

    init() {
        
    }
}

// MARK: WeatherRoutable
extension WeatherRouter: WeatherRoutable {
    func navigateToSearch() {
        guard let source = viewController else { return }
        let searchVC = SearchBuilder().build(listener: self)
        let navController = UINavigationController(rootViewController: searchVC)
        source.present(navController, animated: true)
    }
}

// MARK: - SearchRouterListener
extension WeatherRouter: SearchRouterListener {
    func searchDidClose(with location: Location?) {
        guard let location else { return }
        listener?.updateLocation(with: location)
    }
}
