import UIKit

class PhotosViewController: UIViewController
{
    //MARK: - Properties
    @IBOutlet var imageView: UIImageView!
    
    var store: PhotoStore!
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchPhotos{
        
            (photosResult) -> Void in
            
            switch photosResult
            {
            case let .success(photos):
                print("Successfully found \(photos.count)")
                
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
                
            case let .failure(error):
                print("Error fetching photos \(error)")
                
            }

        }
    }
    //MARK: - Updating the imageview
    func updateImageView(for photo: Photo)
     {
         store.fetchImage(for: photo){
             (imageResult) -> Void in
             
             switch imageResult {
                 
             case let .success(image):
                 self.imageView.image = image
             case let .failure(error):
                 print("Error downloading the image: \(error)")
             }
         }
     }
}
