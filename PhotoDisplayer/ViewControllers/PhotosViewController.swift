import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout
{
    //MARK: - Properties
    
    var collectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Bundle.appName()
        setUpView()
        view.backgroundColor = UIColor.white
        updateDataSource()
    }
 
    
    private func setUpView()
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
    
   //MARK: - Pull to refresh methods
    
    @objc
   private func refresh() {
       updateDataSource()
     }

   private func stopRefresher() {

    guard let isRefreshing = self.collectionView.refreshControl?.isRefreshing, isRefreshing == true else
    {
        return
    }
    OperationQueue.main.addOperation {
        print(#function)
        self.collectionView.refreshControl?.endRefreshing()
     }
  }
    
    //MARK: - fetching photos
    
    private func updateDataSource()
    {
        store.fetchAllPhotos{
        
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
            
            self.stopRefresher()
            
            OperationQueue.main.addOperation {
                self.collectionView.reloadSections(IndexSet(integer:0))
            }
        }
    }
    
}

  

