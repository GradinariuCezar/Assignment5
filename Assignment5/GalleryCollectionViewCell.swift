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



    @IBOutlet weak var imageView: UIImageView!
    
    private func fetchImage(){
        print("am intrat")
        if let url = imageURL{
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                if let urlContents = try? Data(contentsOf: url){
                    let imageData = urlContents
                        print("AICI\(imageData)")
                        self?.image = UIImage(data: imageData)


            }
                else{
                    self?.image = "😥".toImage()                }
            }



    }
}
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
