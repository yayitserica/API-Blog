//
//  PhotoStore.swift
//  APIBlog
//
//  Created by Erica Millado on 7/7/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

//
import UIKit

//18
enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

//19
enum NasaError: Error {
    case invalidJSONData
}

//20
class PhotoStore {
    
    //29
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //30
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        
        //31
        guard let jsonData = data else { return .failure(error!) }
        //32
        return NasaAPI.photos(fromJSON: jsonData)
    }
    
    //33
    func fetchNASAPhotos(completion: @escaping (PhotosResult) -> Void) {
        //34
        let url = NasaAPI.roverURL
        //35
        let request = URLRequest(url: url)
        //36
        let task = session.dataTask(with: request) { (data, response, error) in
            //47
            let result = self.processPhotosRequest(data: data, error: error)
            //38
            OperationQueue.main.addOperation {
                completion(result)
            }
            
        }
        //39
        task.resume()
    }
    

}
