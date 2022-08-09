//
//  ErrorProviders.swift
//  SkyCatNews
//
//  Created by David Garces on 07/08/2022.
//

import Foundation
import SwiftUI

protocol ErrorProviding: Error {
    var errorDescription: String { get }
}

enum NetworkError: ErrorProviding {
    case notFetched(withText: String)
    case notParsed(withText: String, withObject: Any)

    var errorDescription: String {
        switch self {
        case .notFetched(withText: let url):
            return "Couldn't fetch from URL: \(url)"
        case .notParsed(withText: let url, withObject: let object):
            return "Couldn't parse \(url) as \(object.self)"
        }
    }
}

enum FileError: ErrorProviding {
    
    case notFound(withText: String)
    case notLoaded(withText: String)
    case notParsed(withText: String, withObject: Any)

    var errorDescription: String {
        switch self {
        case .notFound(withText: let fileName):
            return "Couldn't find \(fileName) in main bundle."
        case .notLoaded(withText: let fileName):
            return "Couldn't find \(fileName) in main bundle."
        case .notParsed(withText: let fileName, withObject: let object):
            return "Couldn't parse \(fileName) as \(object.self)"
        
        }
    }
}
