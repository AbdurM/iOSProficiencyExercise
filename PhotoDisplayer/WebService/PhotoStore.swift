import Foundation
import UIKit
import CoreData

class PhotoStore
{
    //MARK: - Properties
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //CoreData - NSPersistenceContainer
    let persistenceContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PhotoDisplayer")
        
        container.loadPersistentStores
        { (description, error) in
            
            if let error = error {
                print("Error setting up Core data: \(error)")
            }
                
        }
        return container
    }()
    
    func fetchAllPhotos(completion: @escaping(PhotosResult)->Void){
        
        //fetching the photos from core data if available
        
        let fetchRequest : NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let viewContext = persistenceContainer.viewContext
        
        //asynchnorous
        viewContext.perform {
            do
            {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            }
            catch
            {
                completion(.failure(error))
            }
        }
        
        let url = PhotosAPI.photosURL
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data, let utf8Data = String(decoding: jsonData, as: UTF8.self).data(using: .utf8)
            {
                var result = self.processPhotosRequest(data: utf8Data, error: error)
               
                //NSManagedObject does not persist the changes until you tell the context to save the changes
                
                if case .success = result
                {
                    do
                    {
                        try self.persistenceContainer.viewContext.save()
                    }
                    catch
                    {
                        result = .failure(error)
                    }
                }
                
                
                //because this is a UIOperation and by default URLSessionDataTask runs the completion handler on a background thread
                OperationQueue.main.addOperation {
                        completion(result)
                }
            }
    }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult
    {
        guard let jsonData = data else
        {
            return .failure(error!)
        }
        
        return PhotosAPI.photos(fromJSON: jsonData, into: persistenceContainer.viewContext)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult)-> Void)
    {
        guard let photoKey = photo.photoId else
        {
            preconditionFailure("Photo is expected to have a photoId")
        }
        
        //loading from cache
       if let image = imageStore.image(forkey: photoKey)
       {
           OperationQueue.main.addOperation {
               completion(.success(image))
           }
       }
        
       guard let photoUrl = photo.remoteURL else
       {
         OperationQueue.main.addOperation {
            completion(.failure(PhotoError.missingUrlError))
        }
            return
       }
        
        //the compiler knows that NSURL and URL are related, so it handles the bridging conversion
        let request = URLRequest(url: photoUrl as URL)
        
        let task = session.dataTask(with: request)
        {
            (data, response, error)-> Void in
            
            let result = self.processImageRequest(data: data, error: error)
           
            if case let .success(image) = result {
                self.imageStore.SetImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult
    {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
            else{
                if data == nil{
                    return .failure(error!)
                }
                else{
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success(image)
    }
    
}
