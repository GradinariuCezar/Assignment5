//
//  DetailImageViewController.swift
//  Assignment5
//
//  Created by Cezar Nicolae Gradinariu on 10.03.2022.
//

import Foundation
import UIKit


class DetailImageViewController: UIViewController, UIScrollViewDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    {
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }


    var imageURL: URL?{
        didSet{
            image = nil
            if view.window != nil{
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
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }



    private var imageView = UIImageView()

    private func fetchImage(){
        print("am intrat")
        if let url = imageURL{
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                let urlContents = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let imageData = urlContents {
                            print("AICI\(imageData)")
                            self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    ///
    /// Handle the fact that the view did appear on screen
    ///
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check if we need to fetch the image
        if imageView.image == nil {
            fetchImage()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
