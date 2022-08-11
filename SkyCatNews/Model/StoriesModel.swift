//
//  NewsModel.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

class StoriesModel: ObservableObject {
    
    var networkProvider: DecodeProviding
    
    @Published var isFetching: Bool = true
    @Published var title: String = .skyTitle

    @Published var stories = [NewsRepresentable]()
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStories() async {
        isFetching = true
        let storiesData: StoriesDataFeed? = await networkProvider.parseData()
        if let result = storiesData {
            title = result.title
            stories = loadStories(fromData: result.data)
        }
        isFetching = false
    }
    
    
    func loadStories(fromData data: [MediaItem]) -> [NewsRepresentable] {
        // empty the list of stories
        stories = [NewsRepresentable]()

        for mediaData in data {
            let story: NewsRepresentable
            let mediaMaker: MediaMaker

            switch mediaData.type {
            case .advert:
                mediaMaker = AdvertMockedMaker()
            case .story:
                mediaMaker = StoryMockedMaker()
            case .weblink:
               mediaMaker = WebLinkMockedMaker()
            }
            
            story = mediaMaker.createNewsRespresentable(fromMediaItem: mediaData)
            stories.append(story)

        }
        return stories
  
    }
}

extension StoriesModel {
    static var localStories = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
}
