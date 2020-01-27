import Foundation

struct PhotosAPI {
   
    //MARK: - URL Creation
    static var photosURL: URL {
        
        let components = URLComponents(string: Constants.baseUrlString)!
        return components.url!
    }
    
    //MARK: - JSON Parsing
    static func photos(fromJSON data: Data) -> PhotosResult
    {
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard  let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photosArray = jsonDictionary[Constants.jsonRootKey] as? [[String: Any]]
                else{
                    return .failure(PhotosError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            
            for photoJSON in photosArray {
                
                if let photo = photo(fromJSON: photoJSON)
                {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty
            {
                //we were not able to parse any of the photos
                //may be the json format for photos has changed
                
                return .failure(PhotosError.invalidJSONData)
            }
            
            return .success(finalPhotos)
        }
        catch let error{
            
            return .failure(error)
        }
    }
    
    //parse json dictionary into photo instance
    private static func photo(fromJSON json: [String: Any]) -> Photo?
    {
        let title = json[Constants.jsonPhotoTitleKey] as? String ?? Constants.defaultTitle
        let description = json[Constants.jsonPhotoDescriptionKey] as? String ?? Constants.defaultDescription
        let photoURLString = json[Constants.jsonPhotoUrlStringKey] as? String ?? Constants.defaultUrlString
        let url = URL(string: photoURLString)
        
        return Photo(title: title, description: description, remoteURL: url)
    }
}



