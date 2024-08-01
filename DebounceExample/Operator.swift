//
//  Operator.swift
//  DebounceExample
//
//  Created by Mohammed Rokon Uddin on 8/1/24.
//

import Combine
import SwiftUI

protocol Operator {
  associatedtype Value
  func callAsFunction(_ publisher: Published<Value>.Publisher) -> AnyPublisher<Value, Never>
}

struct DebounceOperator<Value>: Operator {
  let delay: Double
  func callAsFunction(_ publisher: Published<Value>.Publisher) -> AnyPublisher<Value, Never> {
    publisher.debounce(for: .seconds(delay), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

struct ThrottleOperator<Value>: Operator {
  let delay: Double
  func callAsFunction(_ publisher: Published<Value>.Publisher) -> AnyPublisher<Value, Never> {
    publisher
          .throttle(for: .seconds(delay), scheduler: RunLoop.main, latest: false)
          .eraseToAnyPublisher()
  }
}

@propertyWrapper
struct OperatorState<CustomOperator: Operator>: DynamicProperty {

  @StateObject private var state: OperatingState

  init(initialValue: CustomOperator.Value, _ operate: CustomOperator) {
    self.init(wrappedValue: initialValue, operate)
  }

  init(wrappedValue: CustomOperator.Value, _ operate: CustomOperator) {
    let state = OperatingState(initialValue: wrappedValue, operate)
    self._state = StateObject(wrappedValue: state)
  }

  private class OperatingState: ObservableObject {
    @Published var currentValue: CustomOperator.Value
    @Published var operatedValue: CustomOperator.Value

    init(initialValue: CustomOperator.Value, _ operate: CustomOperator) {
      _currentValue = Published(initialValue: initialValue)
      _operatedValue = Published(initialValue: initialValue)

      operate($currentValue)
        .assign(to: &$operatedValue)
    }
  }

  var wrappedValue: CustomOperator.Value {
    get { state.operatedValue }
    set { state.currentValue = newValue }
  }

  var projectedValue: Binding<CustomOperator.Value> {
    $state.currentValue
  }
}

extension Operator {
  static func throttle<CustomOperator>(delay: Double = 0.3) -> Self where Self == ThrottleOperator<CustomOperator> {
    ThrottleOperator(delay: delay)
  }
}

extension Operator {
  static func debounce<CustomOperator>(delay: Double = 0.3) -> Self where Self == DebounceOperator<CustomOperator> {
    DebounceOperator(delay: delay)
  }
}
