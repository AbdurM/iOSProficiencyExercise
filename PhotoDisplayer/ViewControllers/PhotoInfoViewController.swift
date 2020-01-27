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
    
    var descriptionTextView: UITextView = {
          
          var textView = UITextView()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.isScrollEnabled = true
          textView.isEditable = false
          return textView
          
      }()
    
    
    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fill
        stackView.alignment = .fill
        stackView.spacing   = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.white
        return stackView
        
    }()
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
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
        print(photo.description)
       descriptionTextView.text = photo.description

    }
    
    
    func addViews()
    {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionTextView)
        
        self.view.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
}
