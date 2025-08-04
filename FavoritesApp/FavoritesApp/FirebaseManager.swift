import Firebase
import Foundation

class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {
        FirebaseApp.configure()
    }
}
