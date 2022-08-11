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
    
    @Published var stories = [MediaItem]()
    //@Published var stories = [NewsRepresentable]()
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStories() async {
        isFetching = true
        let storiesData: StoriesDataFeed? = await networkProvider.parseData()
        if let result = storiesData {
            title = result.title
            stories = result.data
            //stories = loadStories(fromData: result.data)
        }
        isFetching = false
    }
    
//    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> Story {
//        guard let headline = mediaItem.headline, updatedText
//    }
    
//    func loadStories(fromData data: [MediaItem]) -> [NewsRepresentable] {
//        // empty the list of stories
//        stories = [NewsRepresentable]()
//
//        for mediaData in data {
//            let story: NewsRepresentable
//            //stories.append(story)
//
//
//
////            let url = URL(mediaString: storyData.url ?? "")
////            switch storyData.type {
////            case .advert:
////                story = Advert(url: url)
////            case .story:
////
////                guard let headline = storyData.headline, updated =  else { break }
////
////                story = NewsRepresentable.create(fromData: storyData)
////            case .weblink:
////                story = Advert(url: url)
////            }
//
//        }
//        return stories
  
 //   }
}


extension StoriesModel {
    static var localStories = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
}
