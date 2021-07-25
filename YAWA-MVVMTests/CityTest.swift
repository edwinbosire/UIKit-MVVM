//
//  CityTest.swift
//  YAWA-MVVMTests
//
//  Created by Edwin Bosire on 25/07/2021.
//

import XCTest
@testable import YAWA_MVVM

class CityTest: XCTestCase {

	func testCity_returnsCorrectStringValues_whenInitialised() {
		let aCity = City(name:"", latitude: 999, longitude: 444)

		XCTAssertEqual(aCity.latitude, "999.0")
		XCTAssertEqual(aCity.longitude, "444.0")
	}

}
