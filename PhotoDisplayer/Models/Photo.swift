import Foundation


class Photo {
    
    let title: String
    let description: String
    let remoteURL: URL
    
    init(title: String, description: String, remoteURL: URL)
    {
        self.title = title
        self.description = description
        self.remoteURL = remoteURL
    }
}
