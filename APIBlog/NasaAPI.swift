//
//  NasaAPI.swift
//  APIBlog
//
//  Created by Erica Millado on 7/6/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import Foundation

//https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=2&api_key=SkwW5KEaoj4DpytUZ0LNlQVCNKqHFuDPQMpDjmxl

//Optional(https://api.flickr.com/services/rest?api_key=a335bf5c5f2e090aee7d7f555107b388&method=flickr.photos.getRecent&format=json&nojsoncallback=1&extras=url_h,date_taken)


//5
enum Camera: String {
    case FHAZ = "fhaz"
    case RHAZ = "rhaz"
    case MAST = "mast"
    case CHEMCAM = "chemcam"
    case NAVCAM = "navcam"
}

//1
struct NasaAPI {
    //2
    private static let baseURLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
    //3
    private static let apiKey = "SkwW5KEaoj4DpytUZ0LNlQVCNKqHFuDPQMpDjmxl"
    
    //5 
    static var roverURL: URL {
        return nasaURL(camera: .FHAZ)
    }
    
    //4
    private static func nasaURL(camera: Camera) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParameters = [
            "camera": camera.rawValue,
            "sol": "1000",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
//        print("this is the url: \(components.url)")
        return components.url!
    }
    
    //
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any], let photosArray = jsonDictionary["photos"] as? [[String: Any]] else {
                return .failure(NasaError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()

            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(NasaError.invalidJSONData)
            }
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func photo(fromJSON json: [String: Any]) -> Photo? {

        
        guard let photoID = json["id"] as? Int, let urlString = json["img_src"] as? String, let url = URL(string: urlString), let earth_date = json["earth_date"] as? String else {
            return nil
        }
        let photoIDAsString = String(photoID)

        return Photo(img_src: url, photoID: photoIDAsString, earth_date: earth_date)
    }
    
    
    
}
