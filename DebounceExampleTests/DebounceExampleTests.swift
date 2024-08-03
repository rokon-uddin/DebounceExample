//
//  DebounceExampleTests.swift
//  DebounceExampleTests
//
//  Created by Mohammed Rokon Uddin on 8/3/24.
//

import Combine
import XCTest

@testable import DebounceExample

final class DebounceExampleTests: XCTestCase {

  var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    super.setUp()
    cancellables = []
  }

  override func tearDown() {
    cancellables.forEach { $0.cancel() }
    super.tearDown()
  }

  // Test the debounce functionality with a delay
  func testDebouncedState() {
    // Expectation for async code
    let expectation = XCTestExpectation(
      description: "Debounce should delay the assignment of new values")

    // Setup the property wrapper with debounce
    let delay = 0.3
    var testObject = OperatorState(initialValue: "", .debounce(delay: delay))

    // Initial value test
    XCTAssertEqual(testObject.wrappedValue, "", "Initial value should be set correctly")

    // Update value and expect debounced output to change after the specified delay
    testObject.wrappedValue = "Hello"
    XCTAssertEqual(testObject.wrappedValue, "", "Value should not immediately change due to debounce")

    // Debouncing takes effect here
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {

    XCTAssertEqual(testObject.wrappedValue, "Hello", "Debounced value should be updated after delay")
      expectation.fulfill()
    }
    
    // Wait for expectations
    wait(for: [expectation], timeout: delay + 0.1)
  }
  
  
}
