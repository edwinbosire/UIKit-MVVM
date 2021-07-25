//
//  Parser.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 25/07/2021.
//

import Foundation
import Combine

enum WeatherError: Error {
	case parsing(description: String)
	case network(description: String)
}

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, WeatherError> {
	let decoder = JSONDecoder()
	decoder.dateDecodingStrategy = .secondsSince1970

	return Just(data)
		.decode(type: T.self, decoder: decoder)
		.mapError( { .parsing(description: $0.localizedDescription) })
		.eraseToAnyPublisher()
}

