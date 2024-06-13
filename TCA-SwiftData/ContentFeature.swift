//
//  ContentFeature.swift
//  TCA-SwiftData
//
//  Created by Patrick Lin on 2024/6/14.
//

import ComposableArchitecture
import Dependencies

@Reducer
struct ContentFeature {
    @ObservableState
    struct State: Equatable {
        var items: [Item] = []
    }

    enum Action {
        case itemsChanged([Item])
        case addItem(Item)
        case deleteItem(Item)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .itemsChanged(items):
                state.items = items
                return .none
            case let .addItem(item):
                itemProvider.add(item)
                return .none
            case let .deleteItem(item):
                itemProvider.delete(item)
                return .none
            }
        }
    }

    @Dependency(\.itemProvider) private var itemProvider
}
