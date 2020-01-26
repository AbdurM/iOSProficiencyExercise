import Foundation

struct PhotosAPI {
   
    //MARK: - Constants
   private static let baseURLString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
 
    //MARK: - URL Creation
    static var photosURL: URL {
        
        var components = URLComponents(string: baseURLString)!
        return components.url!
    }
    
    //MARK: - JSON Parsing
    static func photos(fromJSON data: Data) -> PhotosResult
    {
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard  let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photosArray = jsonDictionary["rows"] as? [[String: Any]]
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
        let title = json["title"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let photoURLString = json["imageHref"] as? String ?? ""
        let url = URL(string: photoURLString)
        
        return Photo(title: title, description: description, remoteURL: url)
    }
}



