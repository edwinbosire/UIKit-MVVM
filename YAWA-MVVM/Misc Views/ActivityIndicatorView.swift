//
//  ActivityIndicatorView.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import Foundation
import UIKit

final class ActivityIndicatorView: UIActivityIndicatorView {
	override init(style: UIActivityIndicatorView.Style) {
		super.init(style: style)

		setUp()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setUp() {
		color = .white
		backgroundColor = .darkGray
		layer.cornerRadius = 5.0
		hidesWhenStopped = true
	}
}
