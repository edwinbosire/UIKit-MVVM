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

/// This is temporary. Consider storing this in a database or file to allow the user to change these
extension City {
	static func defaultCities() -> [City] {
		[City(name: "London", latitude: 26.4636, longitude: -0.127758),
		 City(name: "Nairobi", latitude: -1.292066, longitude: 36.821946),
		 City(name: "Cairo", latitude: 30.04442, longitude: 31.235712),
		 City(name: "San Fransisco", latitude: 37.77493, longitude: -114.109497),
		 City(name: "Hong Kong", latitude: 22.396428, longitude: 114.109497)]
	}
}
