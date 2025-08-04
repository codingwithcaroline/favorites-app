import Foundation

struct FavoriteItem: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var category: String
}
