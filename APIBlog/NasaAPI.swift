//
//  NasaAPI.swift
//  APIBlog
//
//  Created by Erica Millado on 7/6/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import Foundation

//2 -
enum Camera: String {
    case FHAZ = "fhaz"
    case RHAZ = "rhaz"
    case MAST = "mast"
    case CHEMCAM = "chemcam"
    case NAVCAM = "navcam"
}

//4
struct NasaAPI {
    //5
    private static let baseURLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
    //6
    private static let apiKey = "SkwW5KEaoj4DpytUZ0LNlQVCNKqHFuDPQMpDjmxl"
    
    //14
    static var roverURL: URL {
        return nasaURL(camera: .MAST)
    }
    
    //7
    private static func nasaURL(camera: Camera) -> URL {
        //8
        var components = URLComponents(string: baseURLString)!
        //9
        var queryItems = [URLQueryItem]()
        //10
        let baseParameters = [
            "camera": camera.rawValue,
            "sol": "1000",
            "api_key": apiKey
        ]
        //11
        for (key, value) in baseParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        //12
        components.queryItems = queryItems
        
        print("this is the url: \(String(describing: components.url))")
        //this is the url: Optional(https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?camera=rhaz&api_key=SkwW5KEaoj4DpytUZ0LNlQVCNKqHFuDPQMpDjmxl&sol=1000)
        //13
        return components.url!
    }
    
    //21
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            //22
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            //23
            guard let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photosArray = jsonDictionary["photos"] as? [[String: Any]] else {
                return .failure(NasaError.invalidJSONData)
            }
            
            //24
            var finalPhotos = [Photo]()

            //25
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            //26
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(NasaError.invalidJSONData)
            }
            //27
            return .success(finalPhotos)
        } catch let error {
            //28
            return .failure(error)
        }
    }
    
    //15
    private static func photo(fromJSON json: [String: Any]) -> Photo? {
        
        //16
        guard let photoID = json["id"] as? Int,
            let urlString = json["img_src"] as? String,
            let url = URL(string: urlString),
            let earth_date = json["earth_date"] as? String else {
            return nil
        }
        let photoIDAsString = String(photoID)
        
        //17
        return Photo(img_src: url, photoID: photoIDAsString, earth_date: earth_date)
    }
    
    
    
}








