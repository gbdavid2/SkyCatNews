//
//  StoryModel.swift
//  SkyCatNews
//
//  Created by David Garces on 09/08/2022.
//

import Foundation

class StoryModel: ObservableObject {
    
    var storyData: Story?
    var networkProvider: DecodeProviding
    
    @Published var isFetching: Bool = true
    //@Published var story: Story = Story(
    
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
