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
    
    @Published var detailedStory: DetailedStory?
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStory() async {
        isFetching = true
        storyData = await networkProvider.parseData()
        if let result = storyData {
           // detailedStory = loadStory(fromData: result)
       }
        isFetching = false
    }
    
//    func loadStory(fromData data: StoryData) -> DetailedStory {
//        
//    }
    
    
    
}
