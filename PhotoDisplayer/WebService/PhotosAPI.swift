import Foundation
import CoreData

struct PhotosAPI {
   
    //MARK: - URL Creation
    
    static var photosURL: URL {
        
        let components = URLComponents(string: Constants.baseUrlString)!
        return components.url!
    }

    //MARK: - JSON Parsing
    
    static func photos(fromJSON data: Data, into context: NSManagedObjectContext) -> PhotosResult
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
                
                if let photo = photo(fromJSON: photoJSON, into: context)
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
    private static func photo(fromJSON json: [String: Any], into context: NSManagedObjectContext) -> Photo?
    {
        let title = json[Constants.jsonPhotoTitleKey] as? String ?? Constants.defaultTitle
        let description = json[Constants.jsonPhotoDescriptionKey] as? String ?? Constants.defaultDescription
        let photoURLString = json[Constants.jsonPhotoUrlStringKey] as? String ?? Constants.defaultPhotoUrl
        let url = URL(string: photoURLString)
        let photoId = UUID.init().uuidString
        
        //check if the photo already exists
        if let existingPhoto = fetchFromCoreData(title: title, context: context)
        {
            return existingPhoto
        }
        
         var photo: Photo!
        //Synchronous operation
        context.performAndWait {
            
            photo = Photo(context: context)
            photo.title = title
            photo.photoDescription = description
            photo.photoId = photoId
            if let url = url
            {
            photo.remoteURL = url as NSURL
            }
            
        }
        
        return photo
        
    }
    
   private static func fetchFromCoreData(title: String, context:NSManagedObjectContext)->Photo?
   {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Photo.title)) == %@",title)
        fetchRequest.predicate = predicate
                 
          var fetchedPhotos: [Photo]?
                 
         context.performAndWait {
        
             fetchedPhotos = try? fetchRequest.execute()
        
         }
         if let existingPhoto = fetchedPhotos?.first
         {
             return existingPhoto
         }
    return nil
   }
}



