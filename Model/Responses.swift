//
//  Responses.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 25/07/2021.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct WeatherResponse: Codable, Equatable, Hashable {
	let latitude, longitude: Double
	let timezone: String
	var currently: Currently
	var minutely: Minutely?
	var hourly: Hourly?
	var daily: Daily?
//	let flags: Flags
//	let offset: Int
}

// MARK: - Currently
struct Currently: Codable, Hashable {
	let time: Int
	let summary: String
	let icon: String
	let nearestStormDistance, nearestStormBearing: Int?
	let precipIntensity, precipProbability, temperature, apparentTemperature: Double
	let dewPoint, humidity, pressure, windSpeed: Double
	let windGust: Double
	let windBearing: Int
	let cloudCover: Double
	let uvIndex: Int
	let visibility, ozone: Double
	let precipType: String?
}


// MARK: - Daily
struct Daily: Codable, Equatable, Hashable {
	let summary: String
	let icon: String
	let data: [DailyDatum]
}

// MARK: - DailyDatum
struct DailyDatum: Codable, Equatable, Hashable {
	let time: Int
	let summary: String
	let icon: String
	var sunriseTime, sunsetTime: Int
	var moonPhase, precipIntensity, precipIntensityMax: Double?
	var precipIntensityMaxTime: Int?
	var precipProbability: Double?
	var precipType: String?
	var temperatureHigh: Double?
	var temperatureHighTime: Int?
	var temperatureLow: Double?
	var temperatureLowTime: Int?
	var apparentTemperatureHigh: Double?
	var apparentTemperatureHighTime: Int?
	var apparentTemperatureLow: Double?
	var apparentTemperatureLowTime: Int?
	var dewPoint, humidity, pressure, windSpeed: Double?
	var windGust: Double?
	var windGustTime, windBearing: Int?
	var cloudCover: Double?
	var uvIndex, uvIndexTime: Int?
	var visibility, ozone, temperatureMin: Double?
	var temperatureMinTime: Int?
	var temperatureMax: Double?
	var temperatureMaxTime: Int?
	var apparentTemperatureMin: Double?
	var apparentTemperatureMinTime: Int?
	var apparentTemperatureMax: Double?
	var apparentTemperatureMaxTime: Int?
}

// MARK: - Flags
struct Flags: Codable, Equatable, Hashable {
	var sources: [String]?
	var meteoalarmLicense: String?
	var nearestStation: Double?
	var units: String?

	enum CodingKeys: String, CodingKey {
		case sources
		case meteoalarmLicense = "meteoalarm-license"
		case nearestStation = "nearest-station"
		case units
	}
}

// MARK: - Hourly
struct Hourly: Codable, Equatable, Hashable {
	let summary: String
	let icon: String
	var data: [Currently]?
}

// MARK: - Minutely
struct Minutely: Codable, Equatable, Hashable {
	let summary: String
	let icon: String
	var data: [MinutelyDatum]?
}

// MARK: - MinutelyDatum
struct MinutelyDatum: Codable, Equatable, Hashable {
	let time: Int
	let precipIntensity, precipProbability: Double
	let precipIntensityError: Double?
	var precipType: String?
}
