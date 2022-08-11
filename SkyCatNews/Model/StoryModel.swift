//
//  StoryModel.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation
import SwiftUI

class StoryModel: ObservableObject {
    
    var storyData: StoryData?
    var networkProvider: DecodeProviding
    
    @Published var isFetching: Bool = true
    //@Published var story: Story = Story(
    
    @Published var image: Image?
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    @MainActor
    func loadStory() async {
        isFetching = true
        storyData = await networkProvider.parseData()
//        if let result = storyData {
//            story = result
//        }
        isFetching = false
    }
    
    
    
}
