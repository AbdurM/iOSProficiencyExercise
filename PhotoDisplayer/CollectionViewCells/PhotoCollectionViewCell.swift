import UIKit

class PhotoCollectionViewCell: UICollectionViewCell
{
    //MARK: - Properties
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    //MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
    func update(with image: UIImage?)
    {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }
        else
        {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}

