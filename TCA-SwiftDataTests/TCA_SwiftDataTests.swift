//
//  TCA_SwiftDataTests.swift
//  TCA-SwiftDataTests
//
//  Created by Patrick Lin on 2024/6/14.
//

import Dependencies
import ComposableArchitecture
import SwiftData
import XCTest

final class TCA_SwiftDataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSwiftData() throws {
        @Dependency(\.modelContextProvider.context) var context
        
        let items1 = try context.fetch(FetchDescriptor<Item>.init(sortBy: [.init(\.timestamp)]))
        assert(items1.count == 0, "count of items should be 0")

        context.insert(Item(timestamp: .now))

        let items2 = try context.fetch(FetchDescriptor<Item>.init(sortBy: [.init(\.timestamp)]))
        assert(items2.count == 1, "count of items should be 1")
    }

    @MainActor
    func testContentFeature() async throws {
        @Dependency(\.modelContextProvider.context) var context

        let store = TestStore(initialState: ContentFeature.State()) {
            ContentFeature()
        }

        for _ in 0..<10 {
            let item = Item(timestamp: .now)
            context.insert(item)
        }

        let items1 = try context.fetch(FetchDescriptor<Item>.init(sortBy: [.init(\.timestamp)]))

        await store.send(.itemsChanged(items1)) {
            $0.items = items1
        }

        await store.send(.addItem(.init(timestamp: .now)))

        let items2 = try context.fetch(FetchDescriptor<Item>.init(sortBy: [.init(\.timestamp)]))

        assert(items2.count == 11, "count of items should be 11")

        await store.send(.deleteItem(items2[3]))

        let items3 = try context.fetch(FetchDescriptor<Item>.init(sortBy: [.init(\.timestamp)]))

        assert(items3.count == 10, "count of items should be 10")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
