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
    @Published var stories: Stories?
    @Published var isFetching: Bool = true
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStories() async {
        isFetching = true
        stories = await networkProvider.parseData()
        isFetching = false
    }
}


extension StoriesModel {
    static var localStories = StoriesModel(networkProvider: FileProvider(filename: .sampleList))
}
