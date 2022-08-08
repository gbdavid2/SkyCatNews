//
//  NewsModel.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

class NewsModel: ObservableObject {
    
    var networkProvider: DecodeProviding
    
    // TODO: does this direct dependency break the Dependency-inversion principle?
    @Published var stories: Stories?
    
    init(networkProvider: DecodeProviding) {
        self.networkProvider = networkProvider
    }
    
    
    
}
