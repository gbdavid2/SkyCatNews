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
    @EnvironmentObject var model: NavigationModel
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()
            AsyncImage(url: URL.randomImageURL) { image in
                image
                    .resizable()
                    .frame(width: 26, height: 26)
                    .cornerRadius(10)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
            } placeholder: {
                ProgressView()
            }
            
            Text(story.headline)
                .font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(String.storyTeaserText)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(sizeCategory > .large ? 1 : 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(String.storyHeadline)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top,5)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .frame(height: 350)
        .background(.ultraThinMaterial)
        .backgroundColor(opacity: 0.5)
        .onTapGesture {
            withAnimation(.openStory) {
                model.showDetail = true
            }
        }
    }
}

struct FeaturedStory_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeaturedStory(story: Story.sampleStory)
            FeaturedStory(story: Story.sampleStory)
                .environment(\.sizeCategory, .accessibilityLarge)
        }
        .environmentObject(NavigationModel())
    }
}

