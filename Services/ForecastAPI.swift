//
//  ForecastAPI.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import Foundation


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
		components.path = ForecastAPI.path + "/\(ForecastAPI.key)" + "/\(city.latitude),\(city.longitude)"

		if period == .yesterday {
			if let yesterdayDate = Date.yesterday {
				let date = "\(yesterdayDate.timeIntervalSince1970)"
				components.queryItems = [
				  URLQueryItem(name: "date", value: date),
				]
			}
		}
		return components
	}
}
