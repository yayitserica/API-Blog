//
//  PhotoStore.swift
//  APIBlog
//
//  Created by Erica Millado on 7/7/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

//6
import UIKit

//7
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

//?
enum NasaError: Error {
    case invalidJSONData
}

//?
class PhotoStore {
    
    //
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //
    func fetchNASAPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = NasaAPI.roverURL
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let result = self.processPhotosRequest(data: data, error: error)
            
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        }
        task.resume()
    }
    
    //
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        
       
        
        
        ////DELETE ABOVE
        guard let jsonData = data else { return .failure(error!) }

        return NasaAPI.photos(fromJSON: jsonData)
    }
}
