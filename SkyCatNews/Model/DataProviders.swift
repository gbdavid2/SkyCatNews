//
//  FileProviders.swift
//  SkyCatNews
//
//  Created by David Garces on 06/08/2022.
//

import Foundation

protocol DecodeProviding {
    func parseData<T: Decodable>() async -> T?
}

/// `decode` is functionality that will be the same for any structure that conforms to `DecodeProviding`, therefore we have created an extension to the protocol to create these specific implementations. The implementations supports decoding as a __generic__ element `T`, thus we can easily decode `Story` or `Stories` or other new data structures when required.
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
    
    // the signature of `parseData` is specific to `FileProvider` therefore this implementation is specified below
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

struct NetworkProvider: DecodeProviding, NetworkProviding {
    var url: URL
    func parseData<T: Decodable>() async -> T? {
            var result: T? = nil
            let data = await fetchFromServer()
            
            guard let resultData = data else { return result }

            do {
                result = try decode(resultData)
                return result
            } catch {
                assertionFailure( NetworkError.notParsed(withText: url.absoluteString, withObject: T.self).errorDescription + "\(error)")
                return nil
            }
    }
    
}

/// This is an unimplemented version of a mocked network provider. Since we have implemented a `FileProvider` that allows us to do mock tests with local data, we might not need to implement this `MockedNetworkProvider`. However, for testing purposes we could make a call to a new instance of the `FileProvider` within the `parseData` of the `MockedNetworkProvider` to simulate __async__ calls within unit tests while we retrieve local data.
struct MockedNetworkProvider: DecodeProviding {
    func parseData<T: Decodable>() async -> T? {
        print("FAKE data requested")
        return nil
    }
}

protocol NetworkProviding {
    var url: URL {get set}
}
extension NetworkProviding {
    fileprivate func fetchFromServer() async -> Data? {
        do {
            print("Fetching data...")
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        catch {
            assertionFailure( NetworkError.notFetched(withText: url.absoluteString).errorDescription + "\(error)")
            preconditionFailure("Network Error - \(String(describing: error))")
        }
    }
}
