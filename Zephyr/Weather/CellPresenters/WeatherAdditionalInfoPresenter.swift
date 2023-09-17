//
//  WeatherAdditionalInfoPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

protocol WeatherAdditionalInfoPresentable {
    var name: String { get }
    var value: String { get }
    var icon: UIImage? { get }
}

struct WeatherAdditionalInfoPresenter: WeatherAdditionalInfoPresentable {
    let name: String
    let value: String
    let icon: UIImage?

    init?(info: Info, units: Units) {
        switch info {
        case .apparentTemperature(let temp):
            guard let formattedValue = Formatters.temperature.format(temp, unit: units) else {
                return nil
            }
            name = "Feels like"
            value = formattedValue
            icon = Assets.Others.apparentTemperature

        case .humidity(let percent):
            name = "Humidity"
            value = "\(percent)%"
            icon = Assets.Others.humidity

        case .pressure(let pressure):
            name = "Pressure"
            value = "\(pressure) hPa"
            icon = Assets.Others.pressure

        case .rain(let length):
            name = "Rain"
            value = "\(length)mm"
            icon = Assets.Rain.showers

        case .snow(let length):
            name = "Snow"
            value = "\(length)mm"
            icon = Assets.Others.snow

        case .sunrise(let time):
            guard let formattedValue = Formatters.time.format(time) else {
                return nil
            }
            name = "Sunrise"
            value = formattedValue
            icon = Assets.Others.sunrise

        case .sunset(let time):
            guard let formattedValue = Formatters.time.format(time) else {
                return nil
            }
            name = "Sunset"
            value = formattedValue
            icon = Assets.Others.sunset

        case .visibility(let distance):
            return nil

        case .wind(let speed):
            return nil
        }
    }
}

extension WeatherAdditionalInfoPresenter {
    enum Info {
        case apparentTemperature(Double)
        case humidity(Int)
        case pressure(Int)
        case rain(Double)
        case snow(Double)
        case sunrise(Date)
        case sunset(Date)
        case visibility(Int)
        case wind(Double)
    }
}

extension WeatherAdditionalInfoPresenter: WeatherInfoCellPresenter {
    func cellIdentifier() -> String {
        WeatherAdditionalInfoCell.reuseIdentifier
    }

    func configure(cell: UICollectionViewCell) {
        guard let cell = cell as? WeatherAdditionalInfoCell else { return }
        cell.configure(with: self)
    }
}
