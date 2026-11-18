import SwiftUI
import SwiftData

/// B2 · Crear cuenta (fiel a la maqueta)
struct RegistroView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol: Rol = .comprador
    @State private var error: String?

    private var usuarioRepetido: Bool { ServicioAuth.existeUsuario(usuario, en: contexto) }
    private var claveCorta: Bool { !clave.isEmpty && clave.count < ServicioAuth.longitudMinimaClave }
    private var noCoinciden: Bool { !confirmacion.isEmpty && clave != confirmacion }
    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && !usuario.isEmpty
            && !usuarioRepetido && clave.count >= ServicioAuth.longitudMinimaClave && clave == confirmacion
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // ② Nombre completo
                CampoEtiquetado("Nombre completo") {
                    TextField("Ej: Lucía Paredes", text: $nombre)
                        .textInputAutocapitalization(.words)
                }

                // ③ Usuario único, con aviso si ya existe
                CampoEtiquetado("Usuario", borde: usuarioRepetido ? .red.opacity(0.7) : .clear) {
                    HStack {
                        TextField("Ej: lparedes", text: $usuario)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        if !usuario.isEmpty {
                            Label(usuarioRepetido ? "Ya existe" : "Disponible",
                                  systemImage: usuarioRepetido ? "xmark" : "checkmark")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(usuarioRepetido ? .red : .green)
                        }
                    }
                }

                // ④ Clave (mínimo 6) y su confirmación
                CampoEtiquetado("Clave (mínimo 6 caracteres)", borde: claveCorta ? .red.opacity(0.7) : .clear) {
                    SecureField("••••••", text: $clave)
                }
                CampoEtiquetado("Confirmar clave", borde: noCoinciden ? .red.opacity(0.7) : .clear) {
                    SecureField("••••••", text: $confirmacion)
                }
                if claveCorta {
                    aviso("La clave debe tener al menos 6 caracteres.")
                } else if noCoinciden {
                    aviso("Las claves no coinciden.")
                }

                // ⑤ Rol: Comprador o Supervisor
                Text("TU ROL")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
                Picker("Rol", selection: $rol) {
                    ForEach(Rol.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)

                if let error { aviso(error) }

                // Ⓐ Registrarme
                Button(action: registrar) {
                    Text("Registrarme")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!formularioValido)
                .padding(.top, 8)

                Text("Al registrarte entrarás directamente a la app con las pestañas de tu rol.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Crear cuenta")              // ① Título; el botón "‹ Ingresar" vuelve al login
        .navigationBarTitleDisplayMode(.inline)
    }

    private func aviso(_ texto: String) -> some View {
        Label(texto, systemImage: "exclamationmark.circle.fill")
            .font(.footnote.weight(.medium))
            .foregroundStyle(.red)
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
