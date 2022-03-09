//
//  GalleryCollectionViewCell.swift
//  Assignment5
//
//  Created by Cezar Nicolae Gradinariu on 07.03.2022.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    var imageURL: URL?{
        didSet{
            image = nil
            if imageURL != nil{
                fetchImage()
            }
        }
    }
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set{
            imageView.image = newValue
        }
    }
    var width : CGFloat?
    var height : CGFloat?


    @IBOutlet weak var imageView: UIImageView!

    private func fetchImage(){
        if let url = imageURL{
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async { [self] in
                    if let imageData = urlContents {
                        print("AICI\(imageData)")
                        self?.image = UIImage(data: imageData)
                        self?.width = self?.image!.size.width
                        self?.height = self?.image!.size.height
                    }
            }
            }



    }
}
}
