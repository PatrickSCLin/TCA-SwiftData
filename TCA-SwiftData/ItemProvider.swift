//
//  ItemProvider.swift
//  TCA-SwiftData
//
//  Created by Patrick Lin on 2024/6/13.
//

import Dependencies
import SwiftData

enum ItemProviderError: Error {
    case queryError(Error)
}

struct ItemProvider {
    var fetchAll: @Sendable () throws -> [Item]
    var fetch: @Sendable (FetchDescriptor<Item>) throws -> [Item]
    var add: @Sendable (Item) -> Void
    var delete: @Sendable (Item) -> Void
}

extension ItemProvider: DependencyKey, TestDependencyKey {
    static var liveValue = Self {
        do {
            @Dependency(\.modelContextProvider.context) var context
            let descriptor = FetchDescriptor<Item>(sortBy: [.init(\.timestamp)])
            return try context.fetch(descriptor)
        } catch {
            throw ItemProviderError.queryError(error)
        }
    } fetch: { descriptor in
        do {
            @Dependency(\.modelContextProvider.context) var context
            return try context.fetch(descriptor)
        } catch {
            throw ItemProviderError.queryError(error)
        }
    } add: { item in
        @Dependency(\.modelContextProvider.context) var context
        context.insert(item)
    } delete: { item in
        @Dependency(\.modelContextProvider.context) var context
        context.delete(item)
    }

    static var testValue: ItemProvider = Self {
        do {
            @Dependency(\.modelContextProvider.context) var context
            let descriptor = FetchDescriptor<Item>(sortBy: [.init(\.timestamp)])
            return try context.fetch(descriptor)
        } catch {
            throw ItemProviderError.queryError(error)
        }
    } fetch: { descriptor in
        do {
            @Dependency(\.modelContextProvider.context) var context
            return try context.fetch(descriptor)
        } catch {
            throw ItemProviderError.queryError(error)
        }
    } add: { item in
        @Dependency(\.modelContextProvider.context) var context
        context.insert(item)
    } delete: { item in
        @Dependency(\.modelContextProvider.context) var context
        context.delete(item)
    }
}

extension DependencyValues {
    var itemProvider: ItemProvider {
        get { self[ItemProvider.self] }
        set { self[ItemProvider.self] = newValue }
    }
}

