import SwiftUI
import Firebase

@main
struct FavoritesApp: App {
    @StateObject private var authVM = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authVM.isAuthenticated {
                FavoritesView()
            } else {
                LoginView()
            }
        }
    }
}
