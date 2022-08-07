//
//  FileProviders.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

protocol ParserProviding {
    func parse(data: Data) -> [Decodable]
}


/// `NewsParser` initialises with a default `JSONDecoder()` but you can give specific `JSONDecoder` instances at initialisation when required
struct NewsParser: ParserProviding {
    
    private let decoder: JSONDecoder
    
    /// request a type of `decoder` at initialisation but give the option to use the default `JSONDecoder()`
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    /// - returns: If parsing failed, an empty array `[]`, otherwise the `[Story]` array with parsed data.
    func parse(data: Data) -> [Decodable] {
        return (try? decoder.decode([Story].self, from: data)) ?? []
    }
}

protocol DecodeProviding {
    
}

/// `decode` is functionality that will be the same for any structure that conforms to `DecodeProviding`, therefore we have created an extension to the protocol to create these specific implementations. The implementations supports decoding as a single element `T` or as an array `[T]`
extension DecodeProviding {
    fileprivate func decode<T: Decodable>(_ data: Data) throws -> T? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
                        
        } catch {
            throw error
        }
    }
    
    fileprivate func decode<T: Decodable>(_ data: Data) throws -> [T]? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: data)
                        
        } catch {
            throw error
        }
    }
}

struct FileProvider: DecodeProviding {
    // the signature of `load` is specific to `FileProvider` therefore this implementation is
    func load<T: Decodable>(_ filename: String) -> T? {
        
        let data: Data
        // 1. load the data from the project
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            assertionFailure(FileError.notFound(withText: filename).errorDescription)
            return nil
        }
        // 2. read the contents of the file
        do {
            data = try Data(contentsOf: file)
        } catch {
            assertionFailure( FileError.notLoaded(withText: filename).errorDescription + "\(error)")
            return nil
        }
        // 3. decode the contents of the file
        do {
            return try decode(data)
        } catch {
            assertionFailure(FileError.notParsed(withText: filename, withObject: T.self).errorDescription + "\(error)")
            return nil
        }
    }
    
}
