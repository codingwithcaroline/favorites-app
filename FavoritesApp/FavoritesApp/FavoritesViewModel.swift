import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var cities: [FavoriteItem] = []
    @Published var hobbies: [FavoriteItem] = []
    @Published var books: [FavoriteItem] = []

    private var db = Firestore.firestore()
    private var userID: String? {
        Auth.auth().currentUser?.uid
    }

    func fetchFavorites() async {
        guard let uid = userID else { return }
        do {
            let snapshot = try await db.collection("users").document(uid).collection("favorites").getDocuments()
            let items = snapshot.documents.compactMap {
                try? $0.data(as: FavoriteItem.self)
            }
            cities = items.filter { $0.category == "cities" }
            hobbies = items.filter { $0.category == "hobbies" }
            books = items.filter { $0.category == "books" }
        } catch {
            print("Error fetching favorites: \(error)")
        }
    }

    func addFavorite(name: String, category: String) async {
        guard let uid = userID else { return }
        let item = FavoriteItem(name: name, category: category)
        do {
            try db.collection("users").document(uid)
                .collection("favorites").document(item.id).setData(from: item)
            await fetchFavorites()
        } catch {
            print("Error adding favorite: \(error)")
        }
    }

    func removeFavorite(_ item: FavoriteItem) async {
        guard let uid = userID else { return }
        do {
            try await db.collection("users").document(uid)
                .collection("favorites").document(item.id).delete()
            await fetchFavorites()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
}
