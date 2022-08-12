//
//  NewsModel.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation
import SwiftUI

class StoriesModel: ObservableObject {
    
    let networkProvider: DecodeProviding
    
    @Published var isFetching: Bool = true
    @Published var media = [NewsRepresentable]()
    
    @AppStorage(.title) var title: String = .skyTitle
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStories() async {
        isFetching = true
        let storiesData: StoriesDataFeed? = await networkProvider.parseData()
        if let result = storiesData {
            title = result.title
            media = loadMedia(fromData: result.data)
        }
        isFetching = false
    }
    
    func getFeaturedStory() -> Story {
        guard let story = media.first(where: { $0.getMediaType() == .story }) as? Story else {
            preconditionFailure(.invalidStoriesArray)
        }
        return story
    }
    
    func getStories() -> [Story] {
        let mediaStories = media.filter { $0.getMediaType() == .story }
        guard let resultMediaStores = mediaStories as? [Story] else {
            preconditionFailure(.invalidStoriesArray)
        }
        
        let sortedStories = resultMediaStores.sorted() { $0.updated > $1.updated }
        
        return sortedStories
    }
    func getWebLinks() -> [WebLink] {
        let mediaLinks = media.filter { $0.getMediaType() == .weblink }
        guard let resultMediaLinks = mediaLinks as? [WebLink] else {
            preconditionFailure(.invalidStoriesArray)
        }
        
        let sortedLinks = resultMediaLinks.sorted() { $0.updated > $1.updated }
        
        return sortedLinks
    }
    
    func loadMedia(fromData data: [MediaItem]) -> [NewsRepresentable] {
        // empty the list of stories
        media = [NewsRepresentable]()

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
            media.append(story)

        }
        return media
    }
}

extension StoriesModel {
    static var localStories = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
}
