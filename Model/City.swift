//
//  City.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 25/07/2021.
//

import Foundation

struct City {
	let name: String
	private let lat: Double
	private let lon: Double

	init(name: String = "-", latitude: Double, longitude: Double) {
		self.name = name
		self.lat = latitude
		self.lon = longitude
	}

	var latitude: String {
		"\(self.lat)"
	}

	var longitude: String {
		"\(self.lon)"
	}
}
