import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var newItem = ""
    @State private var selectedCategory = "cities"

    let categories = ["cities", "hobbies", "books"]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add Favorite")) {
                    TextField("Enter name", text: $newItem)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category.capitalized)
                        }
                    }
                    Button("Add") {
                        Task {
                            await viewModel.addFavorite(name: newItem, category: selectedCategory)
                            newItem = ""
                        }
                    }
                }

                ForEach(categories, id: \.self) { category in
                    Section(header: Text(category.capitalized)) {
                        let items = category == "cities" ? viewModel.cities :
                                    category == "hobbies" ? viewModel.hobbies :
                                    viewModel.books
                        ForEach(items) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Button(role: .destructive) {
                                    Task { await viewModel.removeFavorite(item) }
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Favorites")
            .task { await viewModel.fetchFavorites() }
        }
    }
}
