import Foundation
import UIKit

class PhotoStore
{
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        
        return URLSession(configuration: config)
    }()
    
    
    func fetchPhotos(completion: @escaping(PhotosResult)->Void){
        
        let url = PhotosAPI.photosURL
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data, let utf8Data = String(decoding: jsonData, as: UTF8.self).data(using: .utf8)
            {
                let result = self.processPhotosRequest(data: utf8Data, error: error)
               
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
        
        return PhotosAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult)-> Void)
    {
        let photoKey = photo.photoId
        
        //loading from cache
       if let image = imageStore.image(forkey: photoKey)
       {
           OperationQueue.main.addOperation {
               completion(.success(image))
           }
       }
        
        let photoUrl = photo.remoteURL
        let request = URLRequest(url: photoUrl)
        
        let task = session.dataTask(with: request)
        {
            (data, response, error)-> Void in
            
            let result = self.processImageRequest(data: data, error: error)
           
            if case let .success(image) = result {
                self.imageStore.SetImage(image, forKey: photoKey)
            }
            
            //because this is a UIOperation and by default URLSessionDataTask runs the completion handler on a background thread
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
