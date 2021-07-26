//
//  Feedback.swift
//  YAWA-MVVM
//
//  Created by Edwin Bosire on 26/07/2021.
//

/// This code is based on https://github.com/sergdort/CombineFeedback/blob/9e92e55/Sources/CombineFeedback/Feedback.swift
///
/// 
import Combine
struct Feedback<State, Event> {
	let run: (AnyPublisher<State, Never>) -> AnyPublisher<Event, Never>
}

extension Feedback {
	init<Effect: Publisher>(effects: @escaping (State) -> Effect) where Effect.Output == Event, Effect.Failure == Never {
		self.run = { state -> AnyPublisher<Event, Never> in
			state
				.map { effects($0) }
				.switchToLatest()
				.eraseToAnyPublisher()
		}
	}
}
