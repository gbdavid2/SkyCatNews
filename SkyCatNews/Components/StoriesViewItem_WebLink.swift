//
//  StoriesViewItem_WebLink.swift
//  SkyCatNews
//
//  Created by David Garces on 12/08/2022.
//

import SwiftUI

struct StoriesViewItem_WebLink: View {
    
    var webLink: WebLink
    
    var body: some View {
        Link(destination: webLink.url) {
            HStack(spacing: 15) {
                MediaItemImage(url: webLink.teaserImage.imageURL)
                    .accessibilityValue(webLink.teaserImage.accessibilityText)
                    .frame(width: 50, height:50)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(webLink.headline)
                            .font(.headline)
                        Spacer()
                        Text(webLink.getShortUpdateText())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, .generalHorizontal)
            .frame(height: 100)
        }
        .tint(.primary)
    }
}

struct StoriesViewItem_WebLink_Previews: PreviewProvider {
    static var previews: some View {
        StoriesViewItem_WebLink(webLink: WebLinkMockedMaker.createSampleStory() as! WebLink)
    }
}
