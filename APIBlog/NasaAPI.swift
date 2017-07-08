//
//  NasaAPI.swift
//  APIBlog
//
//  Created by Erica Millado on 7/6/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import Foundation

//1 -
enum Camera: String {
    case FHAZ = "fhaz"
    case RHAZ = "rhaz"
    case MAST = "mast"
    case CHEMCAM = "chemcam"
    case NAVCAM = "navcam"
}

//2
struct NasaAPI {
    //2
    private static let baseURLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
    //3
    private static let apiKey = "SkwW5KEaoj4DpytUZ0LNlQVCNKqHFuDPQMpDjmxl"
    
    //5 
    static var roverURL: URL {
//        return nasaURL(camera: .FHAZ)
        return nasaURL(camera: .RHAZ)
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
        print("this is the url: \(String(describing: components.url))")
        //this is the url: Optional(https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?camera=rhaz&api_key=SkwW5KEaoj4DpytUZ0LNlQVCNKqHFuDPQMpDjmxl&sol=1000)
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








