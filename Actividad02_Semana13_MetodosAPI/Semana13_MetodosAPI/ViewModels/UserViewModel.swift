import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var searchText: String = ""

    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { user in
                user.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // GET: Obtener todos los usuarios
    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                    }
                }
            }
        }.resume()
    }

    // POST: Crear un nuevo usuario
    func createUser(name: String, email: String) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newUser = User(id: 0, name: name, email: email) // id lo ignora el servidor

        do {
            request.httpBody = try JSONEncoder().encode(newUser)
        } catch {
            print("Error al codificar el usuario")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let createdUser = try? JSONDecoder().decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        // JSONPlaceholder siempre devuelve id 11, por eso se asigna
                        // un id local único para que la lista no tenga ids repetidos
                        let nextId = (self.users.map { $0.id }.max() ?? 0) + 1
                        let localUser = User(id: max(createdUser.id, nextId),
                                             name: createdUser.name,
                                             email: createdUser.email)
                        self.users.append(localUser)
                    }
                }
            }
        }.resume()
    }
}
