//
//  File.swift
//  SkyCatNews
//
//  Created by David Garces on 10/08/2022.
//

import Foundation

/// A lightweight control class that is used widely within the app to control navigation and view presentation
class NavigationModel: ObservableObject {
    
    // Navigation Bar
    @Published var showNavigation: Bool = true
    
    // Detail View
    @Published var showDetail: Bool = false
    
}
