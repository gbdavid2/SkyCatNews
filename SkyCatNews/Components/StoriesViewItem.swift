//
//  StoriesViewItem.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import SwiftUI

struct StoriesViewItem: View {
    
    var story: MediaItem
    
    var body: some View {
        HStack(spacing: 15) {
            MediaItemImage(url: URL.randomImageURL)
                .frame(width: 50, height:50)

            VStack(alignment: .leading) {
                HStack {
                    Text(String.storyHeadline)
                        .font(.headline)
                    Spacer()
                    Text("36m ago")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(String.storyTeaserText)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, .generalHorizontal)
        .frame(height: 100)
    }
}

struct StoriesViewItem_Previews: PreviewProvider {
    static var previews: some View {
        StoriesViewItem(story: MediaItem.sampleMediaItem())
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
