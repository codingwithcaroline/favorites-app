import SwiftUI

struct LoginView: View {
    @StateObject private var authVM = AuthViewModel()
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Login") {
                Task { await authVM.signIn(email: email, password: password) }
            }
        }
        .padding()
    }
}
