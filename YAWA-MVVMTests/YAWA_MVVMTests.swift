//
//  YAWA_MVVMTests.swift
//  YAWA-MVVMTests
//
//  Created by Edwin Bosire on 25/07/2021.
//

import Foundation

func loadJSON(_ jsonFile: String, from bundle: Bundle) throws -> Data? {

	guard let url = bundle.url(forResource: jsonFile, withExtension: "json") else {
		fatalError("Missing file: User.json")
		return nil
	}

	return try Data(contentsOf: url)
}


enum TestErrors: Error {
	case runtimeError(String)
}
