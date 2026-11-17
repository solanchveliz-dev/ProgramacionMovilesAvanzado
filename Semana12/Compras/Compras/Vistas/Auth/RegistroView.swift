import SwiftUI
import SwiftData

/// B2 · Crear cuenta
struct RegistroView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol: Rol = .comprador
    @State private var error: String?

    // ③ Aviso en vivo si el usuario ya existe
    private var usuarioRepetido: Bool {
        ServicioAuth.existeUsuario(usuario, en: contexto)
    }
    private var claveCorta: Bool {
        !clave.isEmpty && clave.count < ServicioAuth.longitudMinimaClave
    }
    private var noCoinciden: Bool {
        !confirmacion.isEmpty && clave != confirmacion
    }
    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && !usuario.isEmpty
            && !usuarioRepetido && clave.count >= ServicioAuth.longitudMinimaClave && clave == confirmacion
    }

    var body: some View {
        Form {
            // ② Nombre completo
            Section("Datos personales") {
                TextField("Nombre completo", text: $nombre)
                    .textInputAutocapitalization(.words)
            }

            // ③ Usuario único
            Section {
                TextField("Usuario", text: $usuario)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } header: {
                Text("Usuario")
            } footer: {
                if usuarioRepetido {
                    Label("Ese usuario ya existe.", systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                } else if !usuario.isEmpty {
                    Label("Disponible", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }

            // ④ Clave y confirmación
            Section {
                SecureField("Clave (mínimo 6 caracteres)", text: $clave)
                SecureField("Confirmar clave", text: $confirmacion)
            } header: {
                Text("Clave")
            } footer: {
                if claveCorta {
                    Text("La clave debe tener al menos 6 caracteres.").foregroundStyle(.red)
                } else if noCoinciden {
                    Text("Las claves no coinciden.").foregroundStyle(.red)
                }
            }

            // ⑤ Rol
            Section {
                Picker("Rol", selection: $rol) {
                    ForEach(Rol.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Rol")
            } footer: {
                Text(rol == .comprador
                     ? "Registra compras a proveedores y sigue su estado."
                     : "Aprueba compras grandes, paga y administra el catálogo.")
            }

            if let error {
                Section {
                    Label(error, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }
            }

            // Ⓐ Registrarme
            Section {
                Button {
                    registrar()
                } label: {
                    Text("Registrarme")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(!formularioValido)
            }
        }
        .navigationTitle("Crear cuenta")    // ① Título; el botón Atrás vuelve al login
    }

    private func registrar() {
        do {
            let nuevo = try ServicioAuth.registrar(nombre: nombre, usuario: usuario, clave: clave,
                                                   confirmacion: confirmacion, rol: rol, en: contexto)
            sesion.iniciar(nuevo)            // Entra directo a la app
        } catch {
            self.error = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack { RegistroView() }
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
