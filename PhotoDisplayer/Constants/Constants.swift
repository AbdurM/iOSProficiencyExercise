import UIKit

struct Constants
{
    //for ingesting json
    static let baseUrlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let jsonRootKey = "rows"
    static let jsonPhotoTitleKey = "title"
    static let jsonPhotoDescriptionKey = "description"
    static let jsonPhotoUrlStringKey = "imageHref"
    
    //default photo values
    static let defaultTitle = "No title"
    static let defaultDescription = "No description available"
    static let defaultUrlString = ""
    
    
    static let defaultCellImage = UIImage(systemName: "x.circle.fill")
    
    //errorMessages
    static let imageNotFoundText = "\n(Image Unavailable)"
    
    //fonts
    static let regularTextFont = UIFont.systemFont(ofSize: 16)
    static let stackViewSpacing = CGFloat(16)
    
}
