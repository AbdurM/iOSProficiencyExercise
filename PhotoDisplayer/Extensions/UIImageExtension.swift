import Foundation
import UIKit
extension UIImage {
    
    class func createImageWithText(text: String, image: UIImage) -> UIImage {
        
        let imageSize = image.size
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = text
        
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, 2.0)
          let currentView = UIView.init(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
          let currentImage = UIImageView.init(image: image)
          currentImage.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
          currentView.addSubview(currentImage)
          currentView.addSubview(label)
          currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return image!
      }

}
