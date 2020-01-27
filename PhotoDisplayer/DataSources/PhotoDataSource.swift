import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource
{
    //MARK: - Properties
    var photos = [Photo]()
    
    //MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let identifier = "photoCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        return cell
    }
    
    
    

    
}

