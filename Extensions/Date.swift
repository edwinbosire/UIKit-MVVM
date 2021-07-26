//
//  Date.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import Foundation

extension Date {
	static var yesterday: Date? { return Date().dayBefore }
	static var tomorrow:  Date? { return Date().dayAfter }

	var dayBefore: Date? {
		guard let noon = noon else {
			fatalError("Failed to initialise today's date")
		}

		return Calendar.current.date(byAdding: .day, value: -1, to: noon)
	}

	var dayAfter: Date? {
		guard let noon = noon else {
			fatalError("Failed to initialise today's date")
		}
		return Calendar.current.date(byAdding: .day, value: 1, to: noon)
	}

	var noon: Date? {
		return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)
	}
}
