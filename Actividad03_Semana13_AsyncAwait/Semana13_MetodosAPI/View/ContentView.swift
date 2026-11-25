//
//  ContentView.swift
//  Semana13_MetodosAPI
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    @State private var showingForm = false
    @State private var editingUser: User? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar usuario por nombre", text: $viewModel.searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.top, 8)

                // Contador de resultados
                HStack {
                    Text("\(viewModel.filteredUsers.count) usuarios")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Desliza ← para editar o eliminar")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                List(viewModel.filteredUsers) { user in
                    HStack(spacing: 12) {
                        AvatarView(name: user.name)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline).foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteUser(id: user.id)
                            }
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }

                        Button {
                            editingUser = user
                            showingForm = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }.tint(.blue)
                    }
                }
                .listStyle(InsetGroupedListStyle())

                // Botón principal para agregar
                Button {
                    editingUser = nil
                    showingForm = true
                } label: {
                    Label("Agregar Usuario", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .padding()
            }
            .navigationTitle("Usuarios")
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
            }
            .sheet(isPresented: $showingForm) {
                if let user = editingUser {
                    UserFormView(name: user.name, email: user.email, isEditing: true) { name, email in
                        let updated = User(id: user.id, name: name, email: email)
                        Task {
                            await viewModel.updateUser(user: updated)
                        }
                    }
                } else {
                    UserFormView(name: "", email: "", isEditing: false) { name, email in
                        Task {
                            await viewModel.createUser(name: name, email: email)
                        }
                    }
                }
            }
        }
    }
}

// Avatar circular con las iniciales del usuario
struct AvatarView: View {
    let name: String

    private var initials: String {
        let letters = name.split(separator: " ").prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }

    var body: some View {
        Text(initials)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 42, height: 42)
            .background(
                Circle().fill(
                    LinearGradient(colors: [.blue, .purple],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
            )
    }
}

#Preview {
    ContentView()
}
