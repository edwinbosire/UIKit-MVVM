//
//  CitiesListViewModelTests.swift
//  YAWA-MVVMTests
//
//  Created by Edwin Bosire on 26/07/2021.
//

import XCTest
@testable import YAWA_MVVM
import Combine

class CitiesListViewModelTests: XCTestCase {

	var viewModel: CitiesListViewModel?
    override func setUpWithError() throws {

//		let service = WeatherServiceMock()
//		viewModel = CitiesListViewModel(weatherService: service)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_stateChange_whenViewDidAppear() throws {
		let expectation = XCTestExpectation(description: self.debugDescription)
		let cancellable = viewModel?.$state
			.sink { state in
				XCTAssertTrue(state == .idle)
			}

		wait(for: [expectation], timeout: 1.0)
		XCTAssertNotNil(cancellable)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class WeatherServiceMock {


	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func weatherForecast(for city: City, period: ForecastPeriod) -> AnyPublisher<WeatherResponse, WeatherError> {
		return forecast(with: ForecastAPI.makeForecastComponents(for: city, period: period))
	}

	func weatherForecast(for cities: [City], period: ForecastPeriod) -> AnyPublisher<[WeatherResponse], WeatherError> {
		return cities.publisher
			.flatMap { self.forecast(with: ForecastAPI.makeForecastComponents(for: $0, period: period)) }
			.collect()
			.eraseToAnyPublisher()
	}

	internal func forecast<T>(with components: URLComponents) -> AnyPublisher<T, WeatherError> where T : Decodable {
//		let fail = Fail<T, WeatherError>(error: WeatherError.parsing(description: "Could not load file"))
//		// create mock data
//		let bundle = Bundle(for: type(of: self))
//		guard let mockData = try? loadJSON("forecastAPIResponse", from: bundle) else {
//			return fail.eraseToAnyPublisher()
//		}
//
//		guard let mockWeatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: mockData) else {
//			return fail.eraseToAnyPublisher()
//		}
//
//		return CurrentValueSubject<T, WeatherError>(mockWeatherResponse as! T).eraseToAnyPublisher()

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
