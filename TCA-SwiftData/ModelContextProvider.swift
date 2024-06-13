//
//  ModelContextProvider.swift
//  TCA-SwiftData
//
//  Created by Patrick Lin on 2024/6/13.
//

import Dependencies
import SwiftData

struct ModelContextProvider {
    let container: ModelContainer
    let context: ModelContext

    init(container: ModelContainer, context: ModelContext) {
        self.container = container
        self.context = context
    }
}

extension ModelContextProvider: DependencyKey, TestDependencyKey {
    static var liveValue: ModelContextProvider {
        do {
            let config = ModelConfiguration(for: Item.self)
            let container = try ModelContainer(for: Item.self, configurations: config)
            let context = ModelContext(container)
            return ModelContextProvider(container: container, context: context)
        } catch {
            fatalError("Failed to create container \(error)")
        }
    }

    static var testValue: ModelContextProvider {
        do {
            let config = ModelConfiguration(for: Item.self, isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Item.self, configurations: config)
            let context = ModelContext(container)
            return ModelContextProvider(container: container, context: context)
        } catch {
            fatalError("Failed to create container \(error)")
        }
    }
}

extension DependencyValues {
    var modelContextProvider: ModelContextProvider {
        get { self[ModelContextProvider.self] }
        set { self[ModelContextProvider.self] = newValue }
    }
}
