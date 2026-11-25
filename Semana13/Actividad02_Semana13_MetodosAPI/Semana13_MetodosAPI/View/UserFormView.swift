//
//  UserFormView.swift
//  Semana13_MetodosAPI
//
//  Vista para agregar o modificar un usuario
//

import SwiftUI

struct UserFormView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var name: String
    @State var email: String
    var isEditing: Bool
    var onSubmit: (String, String) -> Void

    // Solo se permite guardar si ambos campos tienen contenido
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Datos del usuario")) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        TextField("Nombre", text: $name)
                    }
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationTitle(isEditing ? "Editar Usuario" : "Nuevo Usuario")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    onSubmit(name, email)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(!isValid)
            )
        }
    }
}
