//
//  CitiesListContainerView.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import UIKit
import Combine

class CitiesListContainerView: UIViewController {
	let viewModel: CitiesListViewModel
	private var cancellable: Set<AnyCancellable> = []

	init(viewModel: CitiesListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		bindViewModel()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel.send(event: .onAppear)
	}

	func bindViewModel() {
		viewModel.$state
			.sink { [weak self] in self?.renderChildViews($0) }
			.store(in: &cancellable)
	}

	func renderChildViews(_ state: CitiesListViewModel.State) {
		var viewController = UIViewController()

		switch state {
			case .idle:
				viewController =  UIViewController()
			case .loading:  // present a UIActivitySpinner
				viewController =  UIViewController()
			case .error(let error): // present a UIAlertView
				viewController =  UIViewController()
			case .loaded(let cities):
				viewController =  CitiesListView(cities: cities)
		}

		/// 1. Remove the current view  from hierachy
		/// 2. Add viewController to container


	}

}
