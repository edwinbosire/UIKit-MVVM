//
//  CitiesListViewModel.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

import Foundation
import Combine
import UIKit


class CitiesListViewModel: ObservableObject {

	@Published private(set) var state: State = .idle
	@Published private(set) var cities: [CityRowViewModel] = []

	private var cancellables = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event, Never>()
	private let weatherService: ForecastFetchable

	init(weatherService: ForecastFetchable) {
		self.weatherService = weatherService

		Publishers.system(initial: state,
						  reduce: Self.reduce,
						  scheduler: RunLoop.main,
						  feedbacks: [
							Self.whenLoading(with: weatherService),
							Self.userInput(input: input.eraseToAnyPublisher())
						  ]
		)
			.assign(to: \.state, on: self)
			.store(in: &cancellables)
	}

	/// Fetches lates weather data
	func fetch() {
		self.state = .loading
	}

	func send(event: Event) {
		input.send(event)
	}

	static func whenLoading(with service: ForecastFetchable) -> Feedback<State, Event> {
	  Feedback { (state: State) -> AnyPublisher<Event, Never> in

		  guard case .loading = state else { return Empty().eraseToAnyPublisher() }

		  let defaultCities = City.defaultCities()

		  return service.weatherForecast(for: defaultCities, period: .today)
			  .map { $0.map(CityRowViewModel.init) }
			  .map(Event.onWeatherLoaded)
			  .catch { Just(Event.onFailedToLoadWeather($0)) }
			  .eraseToAnyPublisher()
	  }
	}

}

extension CitiesListViewModel {
	enum State: Equatable {
		case idle
		case loading
		case loaded([CityRowViewModel])
		case error(Error)

		static func == (lhs: CitiesListViewModel.State, rhs: CitiesListViewModel.State) -> Bool {
			switch(lhs, rhs) {
				case (let .loaded(lhsCities), let .loaded(rhsCities)):
					return lhsCities == rhsCities
				case (let .error(lhsError), let .error(rhsError)):
					return lhsError.localizedDescription == rhsError.localizedDescription
				default:
					return false
			}
		}
	}

	enum Event {
		case onAppear
		case onSelectCity(CityRowViewModel)
		case onWeatherLoaded([CityRowViewModel])
		case onFailedToLoadWeather(Error)
	}
}

extension CitiesListViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		switch state {
		case .idle:
			switch event {
			case .onAppear:
				return .loading
			default:
				return state
			}
		case .loading:
			switch event {
			case .onFailedToLoadWeather(let error):
				return .error(error)
			case .onWeatherLoaded(let citiesWeather):
				return .loaded(citiesWeather)
			default:
				return state
			}
		case .loaded:
			return state
		case .error:
			return state
		}
	}
}

extension CitiesListViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
			Feedback { _ in input }
		}
}

extension CitiesListViewModel {
//	func currentView() -> UIViewController {
//		switch state {
//			case .idle:
//				return UIViewController()
//			case .loading:
//				return UIViewController()
//			case .error(let error):
//				return UIViewController()
//			case .loaded(let cities):
//				return CitiesListView(viewModel: self)
//		}
//	}
}
