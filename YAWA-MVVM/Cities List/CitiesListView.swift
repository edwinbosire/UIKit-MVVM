//
//  ViewController.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 25/07/2021.
//

import UIKit
import Combine

class CitiesListView: UIViewController {
	var cities = [CityRowViewModel]()
	private var cancellable: Set<AnyCancellable> = []

	init(cities: [CityRowViewModel]) {
		self.cities = cities

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	func bindViewModel() {
	}

	func renderCities(_ citiesViewModel: [CityRowViewModel]) {

	}
}

