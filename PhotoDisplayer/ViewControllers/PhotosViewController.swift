import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout
{
    //MARK: - Properties
    
    var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view loaded")
        setUpCollectionView()
        self.view.backgroundColor = UIColor.white
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier
        {
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first
            {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    //MARK: - UICollectionViewDelegate methods
    
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         
         let photo = photoDataSource.photos[indexPath.row]
         
         //Download the image data which could take some time
         store.fetchImage(for: photo){
             (result) -> Void in
             
             //the index path of the photo might have changed between
             //the time request started and finished, so find the most
             //recent index path
             
             guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
                 case let .success(image) = result
                else {
                    return
             }
             
             let photoIndexPath = IndexPath(item: photoIndex, section: 0)
             
             //when the request finishes, only update the cell if it is still visible
             if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell
             {
                 cell.update(with: image)
             }
             
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func setUpCollectionView()
    {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout )
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
         collectionView.delegate = self
        collectionView.dataSource = photoDataSource
     
        
        self.view.addSubview(collectionView)
        
    }
    
}

  

