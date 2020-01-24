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
            case let .failure(error):
                print("Error fetching photos \(error)")
                
            }

        }
    }
}
