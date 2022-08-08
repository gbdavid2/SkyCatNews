//
//  FileProviders.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

/// `NewsParser` initialises with a default `JSONDecoder()` but you can give specific `JSONDecoder` instances at initialisation when required
//struct NewsParser: DecodeProviding {
//
//    private let decoder: JSONDecoder
//
//    /// request a type of `decoder` at initialisation but give the option to use the default `JSONDecoder()`
//    init(decoder: JSONDecoder = JSONDecoder()) {
//        self.decoder = decoder
//    }
//
//    /// - returns: If parsing failed, an empty array `[]`, otherwise the `[Story]` array with parsed data.
//    func decode(data: Data) -> Decodable? {
//        //return try decode(data: data)
//        return (try? decoder.decode([Story].self, from: data)) ?? []
//    }
//}


protocol DecodeProviding {
    func parseData<T: Decodable>() -> T?
}

/// `decode` is functionality that will be the same for any structure that conforms to `DecodeProviding`, therefore we have created an extension to the protocol to create these specific implementations. The implementations supports decoding as a generic element `T`
extension DecodeProviding {
    fileprivate func decode<T: Decodable>(_ data: Data) throws -> T? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
                        
        } catch {
            throw error
        }
    }
}

struct FileProvider: DecodeProviding {
    
    let filename: String
 
    // the signature of `load` is specific to `FileProvider` therefore this implementation is
    func parseData<T: Decodable>() -> T? {
        guard let data = getDataFromFile() else { return nil }
        // 3. decode the contents of the file
        do {
            return try decode(data)
        } catch {
            assertionFailure(FileError.notParsed(withText: filename, withObject: T.self).errorDescription + "\(error)")
            return nil
        }
    }
    
    /// `getDataFromFile` has the specific implementation for `FileProvider` which is to get data from a file. It's __private__ as it's for use within `FileProvider` only
     private func getDataFromFile() -> Data? {
        // 1. load the data from the project
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            assertionFailure(FileError.notFound(withText: filename).errorDescription)
            return nil
        }
        // 2. read the contents of the file
        do {
            return try Data(contentsOf: file)
        } catch {
            assertionFailure( FileError.notLoaded(withText: filename).errorDescription + "\(error)")
            return nil
        }
    }
    
}
