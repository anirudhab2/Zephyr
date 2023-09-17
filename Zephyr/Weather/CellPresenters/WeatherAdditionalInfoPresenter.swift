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
            name = Constants.Messages.WeatherInfo.feelsLike
            value = formattedValue
            icon = Assets.Others.apparentTemperature

        case .humidity(let percent):
            name = Constants.Messages.WeatherInfo.humidity
            value = "\(percent)" + Constants.Units.percent
            icon = Assets.Others.humidity

        case .pressure(let pressure):
            name = Constants.Messages.WeatherInfo.pressure
            value = "\(pressure) \(Constants.Units.pressure)"
            icon = Assets.Others.pressure

        case .rain(let length):
            name = Constants.Messages.WeatherInfo.rain
            value = "\(length)" + Constants.Units.millimeters
            icon = Assets.Rain.showers

        case .snow(let length):
            name = Constants.Messages.WeatherInfo.snow
            value = "\(length)" + Constants.Units.millimeters
            icon = Assets.Others.snow

        case .sunrise(let time):
            guard let formattedValue = Formatters.time.format(time) else {
                return nil
            }
            name = Constants.Messages.WeatherInfo.sunrise
            value = formattedValue
            icon = Assets.Others.sunrise

        case .sunset(let time):
            guard let formattedValue = Formatters.time.format(time) else {
                return nil
            }
            name = Constants.Messages.WeatherInfo.sunset
            value = formattedValue
            icon = Assets.Others.sunset

        case .visibility(let distance):
            guard let formattedValue = Formatters.distance.format(distance, units: units) else {
                return nil
            }
            name = Constants.Messages.WeatherInfo.visibility
            value = formattedValue
            icon = Assets.Others.visibility


        case .wind(let speed):
            name = Constants.Messages.WeatherInfo.wind
            icon = Assets.Others.wind
            value = {
                switch units {
                case .metric:
                    return "\(speed) \(Constants.Units.meterPerSec)"
                case .imperial:
                    return "\(speed) \(Constants.Units.milesPerHour)"
                }
            }()
        }
    }
}

// MARK: - Info
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
