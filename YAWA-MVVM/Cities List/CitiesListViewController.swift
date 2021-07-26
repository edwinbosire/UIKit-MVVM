//
//  CitiesListViewController.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import UIKit
import Combine

class CitiesListViewController: UIViewController {
	private var cancellable: Set<AnyCancellable> = []
	private typealias DataSource = UICollectionViewDiffableDataSource<CitiesListViewModel.Section, CityRowViewModel>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<CitiesListViewModel.Section, CityRowViewModel>

	private lazy var contentView = CitiesListView()
	private let viewModel: CitiesListViewModel
	private var bindings = Set<AnyCancellable>()

	private var dataSource: DataSource!

	init(viewModel: CitiesListViewModel = CitiesListViewModel()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = contentView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .darkGray

		setUpTableView()
		configureDataSource()
		setUpBindings()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel.send(event: .onAppear)
	}

	private func setUpTableView() {
		contentView.collectionView.register(
			ForecastCollectionCell.self,
			forCellWithReuseIdentifier: ForecastCollectionCell.identifier)
	}

	func setUpBindings() {

		let stateValueHandler: (CitiesListViewModel.State) -> Void = { [weak self] state in
			switch state {
				case .idle:
					print("Not implemented yet")
			case .loading:
				self?.contentView.startLoading()
				case .loaded( let data):
					print(data)
					self?.contentView.finishLoading()
					self?.updateSections(with: data)
			case .error(let error):
				self?.contentView.finishLoading()
				self?.showError(error)
			}
		}

		viewModel.$state
			.receive(on: RunLoop.main)
			.sink(receiveValue: stateValueHandler)
			.store(in: &cancellable)
	}


	private func updateSections(with data: [CityRowViewModel]) {
		var snapshot = Snapshot()
		snapshot.appendSections([CitiesListViewModel.Section.cities])
		snapshot.appendItems(data)
		dataSource.apply(snapshot, animatingDifferences: true)
	}

}

extension CitiesListViewController {
	private func showError(_ error: Error) {
		let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
			self.dismiss(animated: true, completion: nil)
		}
		alertController.addAction(alertAction)
		present(alertController, animated: true, completion: nil)
	}
}

// MARK: - UICollectionViewDataSource

extension CitiesListViewController {
	private func configureDataSource() {
		dataSource = DataSource(
			collectionView: contentView.collectionView,
			cellProvider: { (collectionView, indexPath, forecast) -> UICollectionViewCell? in
				let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: ForecastCollectionCell.identifier,
					for: indexPath) as? ForecastCollectionCell
			cell?.viewModel = forecast
				return cell
			})
	}
}
