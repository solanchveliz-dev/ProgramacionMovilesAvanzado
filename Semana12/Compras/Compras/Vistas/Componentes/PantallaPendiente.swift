import SwiftUI

/// Pantalla temporal para las pestañas que aún no se construyen.
/// Se va reemplazando en los siguientes commits (B3 a B9).
struct PantallaPendiente: View {
    let titulo: String
    let icono: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(titulo, systemImage: icono,
                                   description: Text("Esta pantalla se construye en el siguiente commit."))
                .navigationTitle(titulo)
                .toolbar { ToolbarItem(placement: .topBarTrailing) { AvatarMenu() } }
        }
    }
}
