import UIKit

class PhotoInfoViewController: UIViewController
{
    //MARK: - Properties
    var imageView: UIImageView = {
        
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()

        store.fetchImage(for: photo){
            (result) -> Void in
            
            switch result {
                
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo:\(error)")
            }
        }
    }
    
    
    func addViews()
    {
        self.view.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}
