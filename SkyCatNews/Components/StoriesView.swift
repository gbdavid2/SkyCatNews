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
                    ForEach (Array(storiesModel.getStories().enumerated()), id: \.offset) {
                        index, story in
                        if index != 0 { Divider() }
                        StoriesViewItem(story: story)
                    }
                    ForEach (Array(storiesModel.getWebLinks().enumerated()), id: \.offset) {
                        index, weblink in
                        if index != 0 { Divider() }
                        StoriesViewItem_WebLink(webLink: weblink)
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
