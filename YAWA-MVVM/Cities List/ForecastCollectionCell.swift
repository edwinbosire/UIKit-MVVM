//
//  CityRowView.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import UIKit
import Combine

final class ForecastCollectionCell: UICollectionViewCell {
	static let identifier = "ForecastCollectionCell"

	var viewModel: CityRowViewModel! {
		didSet { setUpViewModel() }
	}

	lazy var locationName = UILabel()
	lazy var temperature = UILabel()
	lazy var time = UILabel()
	lazy var summary: UILabel = {
		var label = UILabel()
		label.font = UIFont.systemFont(ofSize: 12.0)
		label.textColor = .gray
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: .zero)

		addSubiews()
		setUpConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func addSubiews() {
		let subviews = [locationName, temperature, time, summary]

		subviews.forEach {
			contentView.addSubview($0)
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
	}

	private func setUpConstraints() {
		NSLayoutConstraint.activate([
			locationName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
			locationName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18.0),
//			locationName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),

			summary.topAnchor.constraint(equalTo: locationName.bottomAnchor, constant: 5.0),
			summary.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18.0),
			summary.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),

			temperature.centerYAnchor.constraint(equalTo: locationName.centerYAnchor),
			temperature.leadingAnchor.constraint(equalTo: locationName.trailingAnchor, constant: 10.0),
			temperature.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
			temperature.heightAnchor.constraint(equalTo: locationName.heightAnchor)
		])
	}

	private func setUpViewModel() {
		locationName.text = viewModel.location
		temperature.text = viewModel.temperature
		time.text = viewModel.time
		summary.text = viewModel.summary
	}
}

