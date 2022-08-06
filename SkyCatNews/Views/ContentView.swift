//
//  ContentView.swift
//  SkyCatNews
//
//  Created by David Garces on 05/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var contentHasScrolled = false
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
 
            content
                .background(Image(.blob1).offset(x: -100, y: -400))
        }
    }
    
    var content: some View {
        ScrollView {
            scrollDetection
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
        }
        .padding(.top, 60)
        .coordinateSpace(name: "scroll")
        .overlay(NavigationBar(title: .skyTitle, contentHasScrolled: $contentHasScrolled, showNavigation: .constant(true)))
    }
    
    /// Use `scrollDetection` to detect content scrolling. Store the value read by `GeometryReader` in a `ScrollPreferenceKey` and once this value changes, animate the `contentHasScrolled` state variable which will in turn animate our `NavigationBar`
    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
            // Text("test geometry reader: \(offset)")
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .preferredColorScheme(.dark)
    }
}
