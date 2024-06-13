//
//  TCA_SwiftDataApp.swift
//  TCA-SwiftData
//
//  Created by Patrick Lin on 2024/6/13.
//

import ComposableArchitecture
import Dependencies
import SwiftUI
import SwiftData

@main
struct TCA_SwiftDataApp: App {
    @Dependency(\.modelContextProvider.container) var container

    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: ContentFeature.State(), reducer: {
                ContentFeature()
            }))
                .modelContainer(container)
        }
    }
}
