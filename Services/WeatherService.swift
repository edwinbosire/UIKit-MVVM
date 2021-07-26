//
//  WeatherService.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 25/07/2021.
//

import Foundation
import Combine

enum ForecastPeriod {
	case today
	case yesterday
}

protocol ForecastFetchable {
	func weatherForecast(for city: City, period: ForecastPeriod) -> AnyPublisher<WeatherResponse, WeatherError>

	func weatherForecast(for cities: [City], period: ForecastPeriod) -> AnyPublisher<[WeatherResponse], WeatherError>

	func forecast<T>(with components: URLComponents) -> AnyPublisher<T, WeatherError> where T: Decodable
}


class WeatherService {
	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}
}

extension WeatherService: ForecastFetchable {
	func weatherForecast(for city: City, period: ForecastPeriod) -> AnyPublisher<WeatherResponse, WeatherError> {
		return forecast(with: ForecastAPI.makeForecastComponents(for: city, period: period))
	}

	func weatherForecast(for cities: [City], period: ForecastPeriod) -> AnyPublisher<[WeatherResponse], WeatherError> {

		return cities
			.publisher
			.flatMap { self.forecast(with: ForecastAPI.makeForecastComponents(for: $0, period: period))}
			.collect()
			.eraseToAnyPublisher()
	}

	internal func forecast<T>(with components: URLComponents) -> AnyPublisher<T, WeatherError> where T: Decodable {
		guard let url = components.url else {
			let error = WeatherError.network(description: "Failed to create valid URL")
			return Fail(error: error).eraseToAnyPublisher()
		}

		return session.dataTaskPublisher(for: url)
			.mapError({ .network(description: $0.localizedDescription)})
			.flatMap({decode($0.data)})
			.eraseToAnyPublisher()
	}
}
