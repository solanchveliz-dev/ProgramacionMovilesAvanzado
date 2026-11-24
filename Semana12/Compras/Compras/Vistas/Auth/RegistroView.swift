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
                // Encabezado
                HStack(spacing: 14) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(LinearGradient.marca, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Crea tu cuenta")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                        Text("Regístrate para acceder al sistema")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 10)

                // ② Nombre completo
                CampoEtiquetado("Nombre completo") {
                    HStack(spacing: 10) {
                        Image(systemName: "person.text.rectangle").foregroundStyle(.secondary)
                        TextField("Ej: Lucía Paredes", text: $nombre)
                            .textInputAutocapitalization(.words)
                    }
                }

                // ③ Usuario único, con aviso si ya existe
                CampoEtiquetado("Usuario", borde: usuarioRepetido ? .red.opacity(0.7) : .clear) {
                    HStack(spacing: 10) {
                        Image(systemName: "at").foregroundStyle(.secondary)
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
                    CampoClave(placeholder: "••••••", texto: $clave)
                }
                CampoEtiquetado("Confirmar clave", borde: noCoinciden ? .red.opacity(0.7) : .clear) {
                    CampoClave(placeholder: "••••••", texto: $confirmacion, icono: "lock.rotation")
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
                HStack(spacing: 12) {
                    ForEach(Rol.allCases) { opcion in
                        tarjetaRol(opcion)
                    }
                }

                if let error { aviso(error) }

                // Ⓐ Registrarme
                Button(action: registrar) {
                    Label("Registrarme", systemImage: "person.badge.plus")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .foregroundStyle(.white)
                        .background(LinearGradient.marca, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .opacity(formularioValido ? 1 : 0.5)
                }
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

    /// Tarjeta para elegir el rol (solo visual: cambia la misma variable `rol`)
    private func tarjetaRol(_ opcion: Rol) -> some View {
        let elegido = rol == opcion
        let esSupervisor = opcion == .supervisor
        return Button {
            rol = opcion
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: esSupervisor ? "checkmark.shield.fill" : "cart.fill")
                        .font(.title3)
                    Spacer()
                    Image(systemName: elegido ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(elegido ? Color.accentColor : Color.secondary)
                }
                Text(opcion.rawValue)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(esSupervisor ? "Aprueba y paga" : "Registra compras")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(elegido ? Color.accentColor : Color.secondary)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(elegido ? Color.accentColor : Color(.separator).opacity(0.35), lineWidth: elegido ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.snappy(duration: 0.2), value: rol)
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
