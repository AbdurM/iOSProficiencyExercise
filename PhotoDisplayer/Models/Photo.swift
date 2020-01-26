import Foundation


class Photo {
    
    let photoId: String
    let title: String
    let description: String
    let remoteURL: URL
    
    
    init(title: String, description: String, remoteURL: URL)
    {
        self.photoId = UUID.init().uuidString
        self.title = title
        self.description = description
        self.remoteURL = remoteURL
    }
    
}
