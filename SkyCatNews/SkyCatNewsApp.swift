//
//  SkyCatNewsApp.swift
//  SkyCatNews
//
//  Created by David Garces on 05/08/2022.
//

import SwiftUI

@main
struct SkyCatNewsApp: App {
    /// `NavigationModel` is a navigation object that needs to be used in multiple areas. It's also very light, so we can introduce it to our App via an `environmentObject`
    @StateObject var model = NavigationModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
