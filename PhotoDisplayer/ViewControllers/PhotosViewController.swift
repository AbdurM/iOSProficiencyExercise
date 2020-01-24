import UIKit

class PhotosViewController: UIViewController
{
    //MARK: - Properties
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        store.fetchPhotos{
        
            (photosResult) -> Void in
            
            switch photosResult
            {
            case let .success(photos):
                print("Successfully found \(photos.count)")
                self.photoDataSource.photos = photos
            
                
            case let .failure(error):
                print("Error fetching photos \(error)")
                self.photoDataSource.photos.removeAll()
                
            }
            
            self.collectionView.reloadSections(IndexSet(integer:0))
            }

        }
    }
  

