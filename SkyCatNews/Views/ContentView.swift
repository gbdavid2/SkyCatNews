//
//  ContentView.swift
//  SkyCatNews
//
//  Created by David Garces on 05/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var contentHasScrolled = false
    @State var hideStatusBar = false
    
    @ObservedObject var storiesModel = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
    
    // - FIXME: Call this instead - when server is ready
    // @ObservedObject var storiesModel = StoriesModel(networkProvider: NetworkProvider(url: .newsListURL))
    
    /// `namespace` is used in this parent view to control animations between displaying `FeaturedStory` and `StoryView` (an expanded version of the `FeaturedStory`
    @Namespace var namespace
    @EnvironmentObject var model: NavigationModel
    
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            
            if model.showDetail {
                storyDetail
            } else {
                content
                    .background(
                        Image(.blob1)
                            .offset(x: .blobOffsetX, y: .blobOffsetY)
                            .accessibility(hidden: true)
                    )
            }
        }.task {
            await storiesModel.loadStories()
        }
        .refreshable {
            await storiesModel.loadStories()
        }
        .onChange(of: model.showDetail) { newValue in
            if newValue {
                model.showNavigation = false
                hideStatusBar = true
            } else {
                model.showNavigation = true
                hideStatusBar = false
            }
        }
        .statusBar(hidden: hideStatusBar)
    }
    
    var featuredStory: some View {
        FeaturedStory(story: storiesModel.getFeaturedStory(), namespace: namespace)
    }
    var storyDetail: some View {
        StoryView(namespace: namespace, storyModel: StoryModel(networkProvider: FileProvider(filename: .sampleStory)))
        // - FIXME: Call this instead - when server is ready
        // StoryView(namespace: namespace, storyModel: StoryModel(networkProvider: NetworkProvider(url: URL.storyURL(storyID: storiesModel.getFeaturedStory().id))))
    }
    
    var content: some View {
        ScrollView {
            scrollDetection
            
            VStack {
                
                Group {
                    if storiesModel.isFetching {
                        ProgressView()
                    } else {
                        featuredStory
                    }
                }
                .shadow(color: Color("Shadow").opacity(0.3),
                        radius: 30, x: 0, y: 30)
                .frame(height: 350)
                .padding([.horizontal,.bottom], .generalHorizontal)
                
                Text(verbatim: .newsSection.uppercased())
                    .sectionTitleModifier()
                StoriesView(storiesModel: storiesModel)
                    .background(.ultraThinMaterial)
                    .backgroundStyle()
                    .padding(.generalHorizontal)
                    .accessibilityIdentifier(.storiesViewIdentifier)
                
            }
        }
        .padding(.top, 60)
        .coordinateSpace(name: "scroll")
        .overlay(
            NavigationBar(contentHasScrolled: $contentHasScrolled)
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
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(NavigationModel())
        
    }
}
