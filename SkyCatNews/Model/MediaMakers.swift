//
//  MediaMakers.swift
//  SkyCatNews
//
//  Created by David Garces on 11/08/2022.
//

import Foundation

/// All media maker implementations need to create a `NesRepresentable` that will be used by the presentation layer
protocol MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable
}

struct StoryMaker: MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable {
        guard let id = mediaItem.id, let headline = mediaItem.headline, let creationDate = mediaItem.creationDate, let modifiedDate = mediaItem.modifiedDate, let teaserText = mediaItem.teaserText, let mediaTeaserImage = mediaItem.teaserImage, let imageText = mediaItem.accessibilityText else {
            preconditionFailure(.invalidServerData)
        }
        let convertedID = Int(id) ?? 0
        let imageURL = mediaTeaserImage._links.url.href
        let updated = Date.calculateMostRecentDate(date1: creationDate, date2: modifiedDate)
        let teaserImage = NewsImage(imageURL: URL(mediaString: imageURL), accessibilityText: imageText)
        
        let story = Story(id: convertedID, headline: headline, updated: updated, teaserText: teaserText, teaserImage: teaserImage)
        return story
    }
}

struct WebLinkMaker: MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable {
        guard let headline = mediaItem.headline, let creationDate = mediaItem.creationDate, let modifiedDate = mediaItem.modifiedDate, let mediaTeaserImage = mediaItem.teaserImage, let imageText = mediaItem.accessibilityText, let weblinkUrl = mediaItem.weblinkUrl else {
            preconditionFailure(.invalidServerData)
        }
        
        let imageURL = mediaTeaserImage._links.url.href
        let updated = Date.calculateMostRecentDate(date1: creationDate, date2: modifiedDate)
        let teaserImage = NewsImage(imageURL: URL(mediaString: imageURL), accessibilityText: imageText)
        let webURL = URL(mediaString: weblinkUrl)
        
        
        let weblink = WebLink(headline: headline, updated: updated, url: webURL, teaserImage: teaserImage)
        return weblink
    }
}

struct AdvertMaker: MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable {
        guard let url = mediaItem.url else {
            preconditionFailure(.invalidServerData)
        }
        
        let advertURL = URL(mediaString: url)

        let advert = Advert(url: advertURL)
        return advert
    }
}

// MARK: Stample static data

extension StoryMaker {
    static func sampleStory() -> NewsRepresentable {
        let storyMaker = StoryMockedMaker()
        return storyMaker.createNewsRespresentable(fromMediaItem: MediaItem.sampleMediaItem())
    }
}

// MARK: Mocked makers

struct StoryMockedMaker: MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable {
        guard let creationDate = mediaItem.creationDate, let modifiedDate = mediaItem.modifiedDate else {
            preconditionFailure(.invalidServerData)
        }
        
        let updated = Date.calculateMostRecentDate(date1: creationDate, date2: modifiedDate)
        let teaserImage = NewsImage(imageURL: .randomImageURL_small, accessibilityText: .accessibilityText)
        
        let story = Story(id: 1, headline: .storyHeadline, updated: updated, teaserText: .storyTeaserText, teaserImage: teaserImage)
        return story
    }
}

struct WebLinkMockedMaker: MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable {
        guard let headline = mediaItem.headline, let creationDate = mediaItem.creationDate, let modifiedDate = mediaItem.modifiedDate else {
            preconditionFailure(.invalidServerData)
        }
        
        let updated = Date.calculateMostRecentDate(date1: creationDate, date2: modifiedDate)
        let teaserImage = NewsImage(imageURL: .randomImageURL_small, accessibilityText: .accessibilityText)
        let webURL = URL(mediaString: URL.randomImageURL_large.absoluteString)
        
        
        let weblink = WebLink(headline: headline, updated: updated, url: webURL, teaserImage: teaserImage)
        return weblink
    }
}

struct AdvertMockedMaker: MediaMaker {
    func createNewsRespresentable(fromMediaItem mediaItem: MediaItem) -> NewsRepresentable {
        
        let advertURL = URL(mediaString: URL.randomImageURL_large.absoluteString)

        let advert = Advert(url: advertURL)
        return advert
    }
}


// MARK: Detailed Story Implementations - these don't use the MediaMaker protocol (perhaps we could make the protocol use a generic signature such as: `func createNewsRespresentabled<T: Decodable>(fromMediaItem mediaItem: T) -> NewsRepresentable` to fix this issue

struct DetailedStoryMaker {
    func createDetailedStoryRespresentable(fromStoryData storyData: StoryData) -> DetailedStory {

        let convertedID = Int(storyData.id) ?? 0
        let imageURL = storyData.heroImage.imageUrl
        let accessibilityText = storyData.heroImage.accessibilityText
        let updated = Date.calculateMostRecentDate(date1: storyData.creationDate, date2: storyData.modifiedDate)
        let heroImage = NewsImage(imageURL: URL(mediaString: imageURL), accessibilityText: accessibilityText)
        var content = [StoryRepresentable]()
        
        for item in storyData.contents {
            let contentItem: StoryRepresentable
            switch item.type {
            case .image:
                contentItem = createImageContent(storyContentItem: item)
            case .paragraph:
                contentItem = createParagraphContent(storyContentItem: item)
            }
            content.append(contentItem)
        }
        
        let story = DetailedStory(id: convertedID, headline: storyData.headline, updated: updated, heroImage: heroImage, content: content)
        return story
    }
    
    func createImageContent(storyContentItem item: StoryDataContent) -> StoryRepresentable {
        guard let imageURL = item.url, let accessibilityText = item.accessibilityText else {
            preconditionFailure(.invalidServerData)
        }
        let newsImage = NewsImage(imageURL: URL(mediaString: imageURL), accessibilityText: accessibilityText)
        return newsImage
    }
    
    func createParagraphContent(storyContentItem item: StoryDataContent) -> StoryRepresentable {
        guard let text = item.text else {
            preconditionFailure(.invalidServerData)
        }
        return NewsParagraph(text: text)
    }
}
