//
//  ContentView.swift
//  SkyCatNews
//
//  Created by David Garces on 05/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var contentHasScrolled = false
    @State var title: String = .skyTitle
    @ObservedObject var storiesModel = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            content
                .background(
                    Image(.blob1)
                        .offset(x: .blobOffsetX, y: .blobOffsetY)
                        .accessibility(hidden: true)
                )
        }.task {
            await storiesModel.loadStories()
            
            
            if let theTitle = storiesModel.stories?.title {
                title = theTitle
            }
            print ("requested title: \(title)")
        }
    }
    
    var content: some View {
        ScrollView {
            scrollDetection
            
            VStack {
                Text("Hello, world!")
            }
        }
        .padding(.top, 60)
        .coordinateSpace(name: "scroll")
        .overlay(
            NavigationBar(title: $title, contentHasScrolled: $contentHasScrolled, showNavigation: .constant(true))
                .accessibilityAddTraits(.isHeader)
        )
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
