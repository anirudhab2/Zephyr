//
//  RemoteModel.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

enum RemoteModel<Model, Error> {
    case notFetched
    case fetching
    case fetched(Model)
    case failed(Error)
}
