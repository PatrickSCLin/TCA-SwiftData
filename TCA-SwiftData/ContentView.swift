//
//  ContentView.swift
//  TCA-SwiftData
//
//  Created by Patrick Lin on 2024/6/13.
//

import ComposableArchitecture
import SwiftData
import SwiftUI

struct ContentView: View {
    @Bindable var store: StoreOf<ContentFeature>

    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(store.items, id: \.self) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .onChange(of: items, initial: true) { _, newValue in
                store.send(.itemsChanged(newValue))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        let newItem = Item(timestamp: Date())
        store.send(.addItem(newItem), animation: .default)
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            store.send(.deleteItem(items[index]), animation: .default)
        }
    }
}

#Preview {
    Group {
        @Dependency(\.modelContextProvider.context) var context
        ContentView(store: Store(initialState: ContentFeature.State(), reducer: {
            ContentFeature()
        }))
            .modelContext(context)
    }
}
