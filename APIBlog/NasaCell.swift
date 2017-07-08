//
//  NasaCell.swift
//  APIBlog
//
//  Created by Erica Millado on 7/8/17.
//  Copyright © 2017 Erica Millado. All rights reserved.
//

//
import UIKit

class NasaCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    func updateImageView(with image: UIImage?) {
        self.imageView.image = image
    }
}
