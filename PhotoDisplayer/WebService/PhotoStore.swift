import Foundation

class PhotoStore
{
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
                completion(result)
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
}
