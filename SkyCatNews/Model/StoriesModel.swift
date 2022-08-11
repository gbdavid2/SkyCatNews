//
//  NewsModel.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

class StoriesModel: ObservableObject {
    
    var networkProvider: DecodeProviding
    
    // TODO: does this direct dependency break the Dependency-inversion principle?
    var storiesData: StoriesDataFeed?
    @Published var isFetching: Bool = true
    @Published var title: String = .skyTitle
    @Published var stories = [MediaItem]()
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStories() async {
        isFetching = true
        storiesData = await networkProvider.parseData()
        if let result = storiesData {
            title = result.title
            stories = result.data
        }
        isFetching = false
    }
}


extension StoriesModel {
    static var localStories = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
}
