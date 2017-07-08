//
//  ViewController.swift
//  APIBlog
//
//  Created by Erica Millado on 7/6/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    //
    var photoStore: PhotoStore!
    
    var photosToDisplay: [Photo] = []
    
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        photoStore.fetchNASAPhotos { (photosResult) in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count)")
                self.photosToDisplay = photos
                print("these are the photos to display: \(self.photosToDisplay)")
                print("")
                dump(self.photosToDisplay)
            case let .failure(error):
                print("Error fetching nasa photos: \(error)")
            }
            self.collectionView.reloadData()
        }
        
    }
    
    
    //MARK: - Collection View Data Source Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosToDisplay.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "nasaCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? NasaCell
                
        let photo = photosToDisplay[indexPath.row]
        let data = try? Data(contentsOf: photo.img_src)
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell?.updateImageView(with: image)
        }
        return cell!
    }
    
    


}

