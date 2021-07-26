//
//  CitiesRowViewModel.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import Foundation

struct CityRowViewModel: Hashable {

	var location: String
	var temperature: String
	var time: String
	var summary: String
	private let weather: WeatherResponse
	init(model: WeatherResponse) {
		self.weather = model

		self.location = model.timezone
		self.temperature = "\(model.currently.temperature) ºF" //converted to ºF
		self.summary = model.currently.summary

		let dateFormatter = DateFormatter()
		let date = Date(timeIntervalSince1970: TimeInterval(model.currently.time))
		self.time = dateFormatter.string(from: date)

	}

	static func == (lhs: CityRowViewModel, rhs: CityRowViewModel) -> Bool {
		lhs.weather.latitude == rhs.weather.latitude && lhs.weather.longitude == rhs.weather.latitude
	}

}
