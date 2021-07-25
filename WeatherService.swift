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
	func weatherForecast(for city: City, period: ForecastPeriod) -> AnyPublisher<CurrentForecastResponse, WeatherError>
}

class WeatherService {
	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}
}

extension WeatherService: ForecastFetchable {
	func weatherForecast(for city: City, period: ForecastPeriod) -> AnyPublisher<CurrentForecastResponse, WeatherError> {
		forecast(with: ForecastAPI.makeForecastComponents(for: city, period: period))
	}


	private func forecast<T>(with components: URLComponents) -> AnyPublisher<T, WeatherError> where T: Decodable {
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

extension WeatherService {


}


/// Forecast.io API parameters
struct ForecastAPI {
	static let scheme = "https"
	static let host = "api.forecast.io"
	static let path = "/forecast"
	static let key = "d0f2d7b4f0e23a0bf37a386ad905fc03"
}

extension ForecastAPI {
	/// Build a URLComponent object that describes the fetching paramenters for a  forecast
	/// Takes the name of a city and a `Duration` object
	static func makeForecastComponents(for city: City, period: ForecastPeriod) -> URLComponents {
		var components = URLComponents()
		components.scheme = ForecastAPI.scheme
		components.host = ForecastAPI.host
		components.path = ForecastAPI.path

		components.queryItems = [
			URLQueryItem(name: "latitude", value: city.latitude ),
			URLQueryItem(name: "longitude", value: city.longitude),
			URLQueryItem(name: "units", value: "metric"),
			URLQueryItem(name: "api_key", value: ForecastAPI.key),
		]

		return components
	}
}
