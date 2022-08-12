//
//  StoriesView.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import SwiftUI

struct StoriesView: View {
    
    @ObservedObject var storiesModel: StoriesModel
    
    var body: some View {
        VStack {
            if storiesModel.isFetching {
                ProgressView(String.loadingStories)
                    .frame(maxWidth: .infinity)
                    .frame(height: 400, alignment: .center)
            } else {
                VStack {
                    ForEach (Array(storiesModel.getMedia().enumerated()), id: \.offset) {
                        index, media in
                        if index != 0 { Divider() }
                        if let theStory = media as? Story {
                            StoriesViewItem(story: theStory)
                        }
                        if let theWebLink = media as? WebLink {
                            StoriesViewItem_WebLink(webLink: theWebLink)
                        }  
                    }
                }
            }
            
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        StoriesView(storiesModel: .localStories)
    }
}
