//
//  GalleryCollectionViewController.swift
//  Assignment5
//
//  Created by Cezar Nicolae Gradinariu on 07.03.2022.
//

import UIKit
class GalleryCollectionViewController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate,
    UICollectionViewDelegateFlowLayout {


    struct gallImage {
        var imageURL : URL
        var aspectRatio: Double
    }
    private var gallImageURL = [gallImage](){
        didSet{
            gallCollectionView.reloadData()
            print(gallImageURL.count)
            print(gallImageURL[0])
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBOutlet var gallCollectionView: UICollectionView!{
        didSet{
                gallCollectionView.dataSource = self
                  gallCollectionView.delegate = self
                  gallCollectionView.dropDelegate = self
                  gallCollectionView.dragDelegate = self
            gallCollectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scales(_:))))
               }
    }

    @objc private func scales(_ recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
                case .changed, .ended:
                        self.aspectRatio *= recognizer.scale
                        recognizer.scale = 1.0
                flowLayout?.invalidateLayout()
                default:
                    break
                }
    }
//    @IBOutlet weak var gallCollectionView: UICollectionView!{
//        didSet{
//            gallCollectionView.dataSource = self
//            gallCollectionView.delegate = self
//            gallCollectionView.dropDelegate = self
//            gallCollectionView.dragDelegate = self
//        }
//    }

    // MARK: UICollectionViewDataSource
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let gallImageURL = (gallCollectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell)?.imageURL {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: gallImageURL as NSItemProviderWriting)) // this creates the drag item
            dragItem.localObject = dragItem // just grabbing the local object
            return [dragItem]
        } else {
            return []
        }
    }
// iteme pe care le furnizam cu drag?
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at:indexPath)
    }
    //item urile sunt bagate n drag
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
          return dragItems(at: indexPath)
      }

    ///
        /// Tell collectionView whether or not the dropSession is valid and we can receive it
        ///
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
           // Session must provide an attributed string
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
       }


    ///
       /// Perform the drop of an item into the collection view
       ///
    ///
    ///
    var aspectRatio = 1.0
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // Is this a local drag?
            if let sourceIndexPath = item.sourceIndexPath {
                if let url = item.dragItem.localObject as? URL {
                    collectionView.performBatchUpdates({ // neccessary if we do multiple adjustments to table or collection view
                        // it will do them all as one operation:
                        gallImageURL.remove(at: sourceIndexPath.item)
                        gallImageURL.insert(gallImage(imageURL:url,aspectRatio: 1.0), at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath) // is gonna drop
                }
            }
            // This is NOT a local drag (drop comes from somewhere else)
            else {

                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "SpinCell"))

                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            self.aspectRatio = Double(image.size.width/image.size.height)
                            print("ASPECT RATIO: \(image.size.width/image.size.height)")
                        }
                    }
                }

                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                //din utilities
                                self.gallImageURL.insert(gallImage(imageURL:url.imageURL,aspectRatio: self.aspectRatio), at: insertionIndexPath.item)
                                //AICI!!!

                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return gallImageURL.count
    }
    var width = CGFloat()
    var height = CGFloat()
   // Asks your data source object for the cell that corresponds to the specified item in the collection view.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath)
        if let gallCell = cell as? GalleryCollectionViewCell {
            gallCell.imageURL = gallImageURL[indexPath.item].imageURL
        }
        // Configure the cell
        return cell
    }

    // Size for item at indexPath
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("MARIME : INDEXPATH: \(indexPath)")
//        var height = CGFloat()
//        var width = CGFloat()
//
//        if let cell = (gallCollectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell){
//            height = cell.height!
//            width = cell.width!
//        }

        //return CGSize(width: width, height: height)
        print("aspectRatio: \(self.aspectRatio)")
        return CGSize(width: 400,height: 400*self.aspectRatio)
       }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        // Drag must be URL and UIImage. (Using NSURL because this is an objective-c api. Although we
        // have automatic-bridging between objective-c's NSURL and swift's URL, we must use NSURL.self
        // because we're passing the specific class to `canLoadObjects`)
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSURL.self)
    }
    var flowLayout: UICollectionViewFlowLayout? {
              return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
   }

}

//extension GalleryCollectionViewController: UIDropInteractionDelegate {
//    ///
//    /// Return whether the delegate is interested in the given session
//    ///
//    ///
//    ///cerinta 2?
//    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        // Drag must be URL and UIImage. (Using NSURL because this is an objective-c api. Although we
//        // have automatic-bridging between objective-c's NSURL and swift's URL, we must use NSURL.self
//        // because we're passing the specific class to `canLoadObjects`)
//        return session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSURL.self)
//    }
//
//    ///
//    /// Tells the delegate the drop session has changed.
//    ///
//    /// You must implement this method if the drop interaction’s view can accept drop activities. If
//    /// you don’t provide this method, the view cannot accept any drop activities.
//    ///
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        // Copy whatever is being dropped into the view
//        return UIDropProposal(operation: .copy)
//    }
//
//    ///
//    /// Tells the delegate it can request the item provider data from the session’s drag items.
//    ///
//    /// You can request a drag item's itemProvider data within the scope of this method only and
//    /// not at any other time.
//    ///
////    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
////
////        // Image fetcher allows to fetch an image in the background based on given URL
////        imageFetcher = ImageFetcher() { (url, image) in
////            DispatchQueue.main.async {
////                self.emojiArtBackgroundImage = image
////            }
////        }
////
////        // Process the array of URL's
////        session.loadObjects(ofClass: NSURL.self) { nsurls in
////            // We only care about the first one. If there were others, ignore them.
////            if let url = nsurls.first as? URL {
////                // Asynchronously fetch the image based on the given url.
////                self.imageFetcher.fetch(url)
////            }
////        }
////
////        // Process the array of images
////        session.loadObjects(ofClass: UIImage.self) { images in
////            // We only care about the first one. If there were others, ignore them.
////            if let image = images.first as? UIImage {
////                // Set the image as the fetcher's backup
////                self.imageFetcher.backup = image
////            }
////        }
////    }
//}
