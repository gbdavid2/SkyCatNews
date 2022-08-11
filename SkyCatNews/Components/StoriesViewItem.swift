//
//  StoriesViewItem.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import SwiftUI

struct StoriesViewItem: View {
    
    var story: Story
    
    var body: some View {
        HStack(spacing: 15) {
            MediaItemImage(url: story.teaserImage.imageURL)
                .accessibilityValue(story.teaserImage.accessibilityText)
                .frame(width: 50, height:50)

            VStack(alignment: .leading) {
                HStack {
                    Text(story.headline)
                        .font(.headline)
                    Spacer()
                    Text(story.getShortUpdateText())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(story.teaserText)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, .generalHorizontal)
        .frame(height: 100)
    }
}

struct StoriesViewItem_Previews: PreviewProvider {
    
    static var previews: some View {
        StoriesViewItem(story: StoryMaker.sampleStory() as! Story)
    }
}


struct MediaItemImage: View {
    var url: URL
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .accessibilityElement()
        .accessibilityLabel(String.mediaItemImage)
        .accessibilityAddTraits(.isImage)
        .accessibilityIdentifier(String.mediaItemImageIdentifier)
    }
}
