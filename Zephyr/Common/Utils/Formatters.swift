//
//  Formatters.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import Foundation

enum Formatters {
    static let temperature = Temperature()
    static let time = Time()
    static let distance = Distance()
}

// MARK: - Temperature
extension Formatters {
    struct Temperature {
        private let formatter: MeasurementFormatter

        init() {
            let formatter = MeasurementFormatter()
            formatter.unitOptions = .providedUnit
            formatter.unitStyle = .medium
            formatter.numberFormatter.minimumFractionDigits = 0
            formatter.numberFormatter.maximumFractionDigits = 1
            self.formatter = formatter
        }

        func format(_ value: Double, unit: UnitTemperature) -> String? {
            let measurement = Measurement(value: value, unit: unit)
            return formatter.string(from: measurement)
        }

        func format(_ value: Double, unit: Units) -> String? {
            let tempUnit: UnitTemperature = {
                switch unit {
                case .metric:
                    return .celsius
                case .imperial:
                    return .fahrenheit
                }
            }()
            return format(value, unit: tempUnit)
        }
    }
}

// MARK: - Time
extension Formatters {
    struct Time {
        private let formatter: DateFormatter

        init() {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            self.formatter = formatter
        }

        func format(_ value: Date) -> String? {
            formatter.string(from: value)
        }
    }
}

// MARK: - Distance
extension Formatters {
    struct Distance {
        private let formatter: MeasurementFormatter

        init() {
            let formatter = MeasurementFormatter()
            formatter.unitOptions = .providedUnit
            formatter.unitStyle = .medium
            formatter.numberFormatter.minimumFractionDigits = 0
            formatter.numberFormatter.maximumFractionDigits = 1
            self.formatter = formatter
        }

        func format(_ value: Int, units: Units) -> String? {
            let distance = Double(value)
            var measurement = Measurement(value: distance, unit: UnitLength.meters)
            switch units {
            case .metric:
                if distance >= 1000 {
                    let kilometers = measurement.converted(to: UnitLength.kilometers)
                    measurement = Measurement(value: kilometers.value, unit: UnitLength.kilometers)
                }

            case .imperial:
                let miles = measurement.converted(to: UnitLength.miles)
                measurement = Measurement(value: miles.value, unit: UnitLength.miles)
            }

            return formatter.string(from: measurement)
        }
    }
}
