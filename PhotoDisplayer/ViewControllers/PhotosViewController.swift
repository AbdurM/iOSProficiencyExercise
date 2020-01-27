import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout
{
    //MARK: - Properties
    var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        self.view.backgroundColor = UIColor.white
        fetchPhotos()
    }
        
  //MARK: - UICollectionViewDelegate methods
    
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         
         let photo = photoDataSource.photos[indexPath.row]
         
         //Download the image data which could take some time
         store.fetchImage(for: photo) {
             (result) -> Void in
            
            var cellImage: UIImage!
            
            switch result{
            case let .success(image):
                cellImage = image
            case let .failure(error):
                print("Image fetching failed due to \(error)")
                cellImage = Constants.defaultCellImage
             }
            
            //the index path of the photo might have changed between
            //the time request started and finished, so find the most
            //recent index path
                
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo) else
            {
             return
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
             
             //when the request finishes, only update the cell if it is still visible
             if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell
             {
                
                 cell.update(with: cellImage)
             }
             
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let photo = photoDataSource.photos[indexPath.row]
                      
        let photoInfoViewController = PhotoInfoViewController()
                      
        photoInfoViewController.photo = photo
        photoInfoViewController.store = store
        
        self.navigationController?.pushViewController(photoInfoViewController, animated: true)
        
    }
    
    func setUpView()
    {
        //setting up collection view
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout )
        collectionView.backgroundColor = UIColor.white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = photoDataSource
     
        //setting up UIRefresh control
        refreshControl = UIRefreshControl()
        collectionView!.alwaysBounceVertical = true
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
        
        view.addSubview(collectionView)
        
    }
    
    //MARK: - Pull to refresh methods
    @objc
    func refresh() {
       //self.collectionView!.refreshControl?.beginRefreshing()
       print(#function)
       fetchPhotos()
     }

    func stopRefresher() {
    
        OperationQueue.main.addOperation {
           
            guard let isRefreshing = self.collectionView.refreshControl?.isRefreshing
            else
            {
                    return
            }
            
            if isRefreshing
            {
                self.collectionView.refreshControl?.endRefreshing()
                self.view.layoutIfNeeded()
            }
            
     }
    }
    
    
    //MARK: - fetching photos
    
    func fetchPhotos()
    {
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
            
            OperationQueue.main.addOperation {
                self.stopRefresher()
                self.collectionView.reloadSections(IndexSet(integer:0))
            }
        }
    }
    
}

  

