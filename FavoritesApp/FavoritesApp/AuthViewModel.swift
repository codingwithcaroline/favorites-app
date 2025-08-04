import FirebaseAuth
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false

    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.isAuthenticated = user != nil
        }
    }

    func signIn(email: String, password: String) async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            print("Login error: \(error)")
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
    }
}
