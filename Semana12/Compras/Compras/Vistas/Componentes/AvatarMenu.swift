import SwiftUI

/// Avatar con las iniciales del usuario conectado. Su menú muestra nombre y rol
/// y tiene el botón Cerrar sesión (aparece en todas las pantallas).
struct AvatarMenu: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        if let usuario = sesion.usuario {
            Menu {
                Section("\(usuario.nombre) · @\(usuario.usuario)") {
                    Label(usuario.rol, systemImage: usuario.esSupervisor ? "checkmark.shield" : "cart")
                }
                Button(role: .destructive) {
                    sesion.cerrar()
                } label: {
                    Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                }
            } label: {
                Text(usuario.iniciales)
                    .font(.footnote.bold())
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(usuario.esSupervisor ? Color.indigo : Color.teal))
                    .accessibilityLabel("Cuenta de \(usuario.nombre)")
            }
        }
    }
}
