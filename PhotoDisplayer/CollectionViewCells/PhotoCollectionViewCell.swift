import UIKit

class PhotoCollectionViewCell: UICollectionViewCell
{
    //MARK: - Properties
    
    var imageView: UIImageView = {
       
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var spinner: UIActivityIndicatorView = {
       
        var spinner = UIActivityIndicatorView()
        spinner.color = UIColor.black
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        update(with: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
 
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
    func addViews()
    {
        backgroundColor = UIColor.lightGray
        
        addSubview(imageView)
        addSubview(spinner)
        
        //adding and activating constraints
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
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

