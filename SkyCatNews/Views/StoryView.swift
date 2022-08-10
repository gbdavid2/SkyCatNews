//
//  StoryView.swift
//  SkyCatNews
//
//  Created by David Garces on 10/08/2022.
//

import SwiftUI

struct StoryView: View {
    
    var namespace: Namespace.ID
    @Binding var story: Story
    var isAnimated = true
    
    @State var viewState: CGSize = .zero
    @State var showSection = false
    @State var appear = [false, false, false]
    // @State var selectedSection = storySection[0]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
            }
        }
    }
    
    var cover: some View {
        GeometryReader { proxy in
            
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY: 500)
            .background(
                AsyncImage(url: URL.randomImageURL_small) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                        .matchedGeometryEffect(id: "background", in: namespace)
                        .offset(y: scrollY > 0 ? -scrollY:0)
                } placeholder: {
                    ProgressView()
                }
            )
            
            Text("hi")
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        StoryView(namespace: namespace, story: .constant(Story.sampleStory))
    }
}
