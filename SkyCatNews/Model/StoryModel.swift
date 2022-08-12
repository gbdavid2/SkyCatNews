//
//  StoryModel.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation
import SwiftUI

class StoryModel: ObservableObject {
    
    var story: Story?
    var storyData: StoryData?
    var networkProvider: DecodeProviding
    
    @Published var isFetching: Bool = true
    
    // FIXME: At initialisation the model is creating a mock story - this should be changed when live server is ready
    @Published var detailedStory = DetailedStoryMockedMaker.createDetailedStoryRespresentable()
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStory() async {
        isFetching = true
        storyData = await networkProvider.parseData()
        if let result = storyData {
            detailedStory = loadStory(fromData: result)
       }
        isFetching = false
    }
    
    func loadStory(fromData data: StoryData) -> DetailedStory {
       return DetailedStoryMockedMaker.createDetailedStoryRespresentable()
        // FIXME: Use details below instead when live server is ready
        // let storyMaker = DetailedStoryMaker()
       // return storyMaker.createDetailedStoryRespresentable(fromStoryData: data)
        
    }
    
    
    
}
