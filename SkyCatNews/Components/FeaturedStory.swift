//
//  FeaturedStory.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation
import SwiftUI

struct FeaturedStory: View {
    
    var story: Story
    var namespace: Namespace.ID
    
    @EnvironmentObject var model: NavigationModel
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack {
            Color.clear
                .frame(height: 180)
                .background(
                    AsyncImage(url: URL.randomImageURL_large) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .matchedGeometryEffect(id: "background_image", in: namespace)
                )
            VStack (alignment: .leading, spacing: 8) {
                Spacer()
                Text(story.headline)
                    .font(.title).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: "headline", in: namespace)
                
                Text(String.storyTeaserText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(sizeCategory > .large ? 1 : 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("8 min ago")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.top,5)
                    .matchedGeometryEffect(id: "time", in: namespace)
            }
            .padding([.bottom,.horizontal], .general)
        }
        .background(.ultraThinMaterial)
        .mask(
            RoundedRectangle(cornerRadius: 30)
                .matchedGeometryEffect(id: "mask", in: namespace)
        )
        .onTapGesture {
            withAnimation(.openStory) {
                model.showDetail = true
            }
        }
    }
}

struct FeaturedStory_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        Group {
            FeaturedStory(story: StoryMaker.sampleStory() as! Story, namespace: namespace)
            FeaturedStory(story: StoryMaker.sampleStory() as! Story, namespace: namespace)
                .environment(\.sizeCategory, .accessibilityLarge)
        }.shadow(color: Color("Shadow").opacity(0.3),
                 radius: 30, x: 0, y: 30)
        .padding(20)
        .frame(height: 350)
        .environmentObject(NavigationModel())
    }
}

