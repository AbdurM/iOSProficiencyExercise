extension Photo: Equatable
{
    static func == (lhs: Photo, rhs: Photo) -> Bool
    {
        return lhs.photoId == rhs.photoId
    }
}
