//
//  ForecastAPITests.swift
//  YAWA-MVVMTests
//
//  Created by Edwin Bosire on 25/07/2021.
//

import XCTest
@testable import YAWA_MVVM

class ForecastAPITests: XCTestCase {

	/// Testing static vairable values just to make sure no typos are introduced
	func testAPI_urlComponentsHaveValidValues_whenInitialised() {
		XCTAssertEqual(ForecastAPI.scheme, "https")
		XCTAssertEqual(ForecastAPI.host, "api.forecast.io")
		XCTAssertEqual(ForecastAPI.path, "/forecast")
	}

	/// A valid API key must be used to make a successful request.
	func testAPI_defaultAPIKeyInUse() {
		XCTAssertEqual(ForecastAPI.key, "d0f2d7b4f0e23a0bf37a386ad905fc03")
	}

	func testAPI_returnsValidURLComponent_whenInitialisedWithCityAndPeriod() {

		let city = City(latitude: -34.9285, longitude: 138.6005)

		let components = ForecastAPI.makeForecastComponents(for: city, period: .today)

		let urlString = "https://api.forecast.io/forecast/d0f2d7b4f0e23a0bf37a386ad905fc03/" + "\(city.latitude),\(city.longitude)"
		let expectedComponent = URLComponents(string: urlString)

		XCTAssertEqual(components, expectedComponent, "A valid component with matching constituent parts expected")
	}

	func testAPI_returnsValidURLComponent_whenInitialisedForYesterday() {

		let city = City(latitude: -34.9285, longitude: 138.6005)

		let components = ForecastAPI.makeForecastComponents(for: city, period: .yesterday)

		let date = "\(Date.yesterday!.timeIntervalSince1970)"
		let urlString = "https://api.forecast.io/forecast/d0f2d7b4f0e23a0bf37a386ad905fc03/" + "\(city.latitude),\(city.longitude)" + "?date=\(date)"
		let expectedComponent = URLComponents(string: urlString)

		XCTAssertEqual(components, expectedComponent, "A valid component with matching constituent parts expected")
	}

}
