//
//  WeatherServiceTests.swift
//  YAWA-MVVMTests
//
//  Created by Edwin Bosire on 26/07/2021.
//

import XCTest
import Combine
@testable import YAWA_MVVM

class WeatherServiceTests: XCTestCase {
	var urlSession: URLSession!

	override func setUpWithError() throws {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		urlSession = URLSession(configuration: config)
	}

	private var cancellable = Set<AnyCancellable>()

	func testService_canRetrieveForecast() throws {

		// inject custom session
		let service = WeatherService(session: urlSession)

		// create mock data
		guard let mockData = try? loadJSONData() else {
				  throw TestErrors.runtimeError("failed to decode sample json data")
			  }

		guard let mockWeatherResponse = try? JSONDecoder().decode(Welcome.self, from: mockData) else {
			throw TestErrors.runtimeError("Error parsing jsonData")
		}

		// return mock data in URLSession response
		MockURLProtocol.requestHandler = { request in
			return (HTTPURLResponse(), mockData)
		}

		let expectation = XCTestExpectation(description: "Forecast.io response")


		service.weatherForecast(for: testCity, period: .today)
			.sink { completion in
				switch completion {
					case .finished:
						print("finished")
					case .failure(let decodeError):
						XCTFail(decodeError.localizedDescription)
				}
				expectation.fulfill()
			} receiveValue: { response in
				XCTAssertEqual(response.latitude, mockWeatherResponse.latitude)
				XCTAssertEqual(response.longitude, mockWeatherResponse.longitude)
				XCTAssertEqual(response.currently, mockWeatherResponse.currently)
				expectation.fulfill()
			}
			.store(in: &cancellable)




		wait(for: [expectation], timeout: 2)

	}

	private var testCity: City {
		City(latitude: -34.9285, longitude: 138.6005)
	}



	private func loadJSONData() throws -> Data? {
		let bundle = Bundle(for: type(of: self))

		guard let url = bundle.url(forResource: "forecastAPIResponse", withExtension: "json") else {
			XCTFail("Missing file: User.json")
			return nil
		}

		return try Data(contentsOf: url)
	}
}

private enum TestErrors: Error {
	case runtimeError(String)
}

extension XCTestCase {
	func xctAwait<T: Publisher>(
		_ publisher: T,
		timeout: TimeInterval = 10,
		file: StaticString = #file,
		line: UInt = #line
	) throws -> T.Output {
		// This time, we use Swift's Result type to keep track
		// of the result of our Combine pipeline:
		var result: Result<T.Output, Error>?
		let expectation = self.expectation(description: "Awaiting publisher")

		let cancellable = publisher.sink(
			receiveCompletion: { completion in
				switch completion {
				case .failure(let error):
					result = .failure(error)
				case .finished:
					break
				}

				expectation.fulfill()
			},
			receiveValue: { value in
				result = .success(value)
			}
		)

		// Just like before, we await the expectation that we
		// created at the top of our test, and once done, we
		// also cancel our cancellable to avoid getting any
		// unused variable warnings:
		waitForExpectations(timeout: timeout)
		cancellable.cancel()

		// Here we pass the original file and line number that
		// our utility was called at, to tell XCTest to report
		// any encountered errors at that original call site:
		let unwrappedResult = try XCTUnwrap(
			result,
			"Awaited publisher did not produce any output",
			file: file,
			line: line
		)

		return try unwrappedResult.get()
	}
}
