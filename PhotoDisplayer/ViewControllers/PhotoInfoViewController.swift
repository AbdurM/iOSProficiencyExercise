import UIKit

class PhotoInfoViewController: UIViewController
{
    //MARK: - Properties
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    private var imageView: UIImageView = {
        
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   private var descriptionTextView: UITextView = {
          
          var textView = UITextView()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.isScrollEnabled = true
          textView.isEditable = false
          textView.font = Constants.regularTextFont
          textView.textAlignment = .center
          return textView
          
      }()
    
    private var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fillEqually
        stackView.alignment = .fill
        stackView.spacing   = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.white
        return stackView
        
    }()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addViews()
        descriptionTextView.text = photo.photoDescription

        store.fetchImage(for: photo){
            (result) -> Void in
            
            switch result {
                
            case let .success(image):
                self.imageView.image = image
            
            case let .failure(error):
                print("Error fetching image for photo:\(error)")
                self.imageView.image = Constants.defaultCellImage
                self.descriptionTextView.text.append(Constants.imageNotFoundText)
            }
        }
      

    }
    
    private func addViews()
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
