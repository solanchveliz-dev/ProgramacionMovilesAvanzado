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
    private var usuarioRepetido: Bool { ServicioAuth.existeUsuario(usuario, en: contexto) }
    private var claveCorta: Bool { !clave.isEmpty && clave.count < ServicioAuth.longitudMinimaClave }
    private var noCoinciden: Bool { !confirmacion.isEmpty && clave != confirmacion }
    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && !usuario.isEmpty
            && !usuarioRepetido && clave.count >= ServicioAuth.longitudMinimaClave && clave == confirmacion
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                // ① Encabezado
                VStack(alignment: .leading, spacing: 6) {
                    Image("LogoCaja")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(colors: [Color(red: 0.39, green: 0.31, blue: 0.93),
                                                    Color(red: 0.12, green: 0.51, blue: 1.0)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing),
                            in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                    Text("Crea tu cuenta")
                        .font(.largeTitle.bold())
                        .padding(.top, 6)
                    Text("Completa tus datos para empezar a usar Compras.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // ② Nombre y ③ usuario
                VStack(alignment: .leading, spacing: 10) {
                    CampoRegistro(icono: "person", placeholder: "Nombre completo", texto: $nombre)
                        .textInputAutocapitalization(.words)
                    CampoRegistro(icono: "at", placeholder: "Usuario", texto: $usuario,
                                  estado: usuario.isEmpty ? .neutro : (usuarioRepetido ? .error : .ok))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    if usuarioRepetido {
                        MensajeCampo(texto: "Ese usuario ya existe. Elige otro.", tipo: .error)
                    } else if !usuario.isEmpty {
                        MensajeCampo(texto: "Usuario disponible", tipo: .ok)
                    }
                }

                // ④ Clave y confirmación
                VStack(alignment: .leading, spacing: 10) {
                    CampoRegistro(icono: "lock", placeholder: "Clave (mínimo 6 caracteres)", texto: $clave,
                                  seguro: true, estado: claveCorta ? .error : .neutro)
                    CampoRegistro(icono: "lock.rotation", placeholder: "Confirmar clave", texto: $confirmacion,
                                  seguro: true,
                                  estado: confirmacion.isEmpty ? .neutro : (noCoinciden ? .error : .ok))
                    if claveCorta {
                        MensajeCampo(texto: "La clave debe tener al menos 6 caracteres.", tipo: .error)
                    } else if noCoinciden {
                        MensajeCampo(texto: "Las claves no coinciden.", tipo: .error)
                    }
                }

                // ⑤ Rol en tarjetas
                VStack(alignment: .leading, spacing: 10) {
                    Text("¿Cuál es tu rol?")
                        .font(.headline)
                    HStack(spacing: 12) {
                        TarjetaRol(titulo: "Comprador", detalle: "Registra compras y sigue su estado",
                                   icono: "cart.fill", color: .teal, seleccionado: rol == .comprador) { rol = .comprador }
                        TarjetaRol(titulo: "Supervisor", detalle: "Aprueba, paga y administra",
                                   icono: "checkmark.shield.fill", color: .indigo, seleccionado: rol == .supervisor) { rol = .supervisor }
                    }
                }

                if let error {
                    MensajeCampo(texto: error, tipo: .error)
                }

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
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)       // El botón Atrás vuelve al login
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

// MARK: - Piezas del formulario

enum EstadoCampo { case neutro, ok, error }

/// Campo con ícono a la izquierda y borde de color según el estado
struct CampoRegistro: View {
    let icono: String
    let placeholder: String
    @Binding var texto: String
    var seguro = false
    var estado: EstadoCampo = .neutro

    private var colorBorde: Color {
        switch estado {
        case .neutro: return .clear
        case .ok: return .green.opacity(0.6)
        case .error: return .red.opacity(0.7)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .foregroundStyle(.secondary)
                .frame(width: 22)
            if seguro {
                SecureField(placeholder, text: $texto)
            } else {
                TextField(placeholder, text: $texto)
            }
            if estado == .ok {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(colorBorde, lineWidth: 1.5))
    }
}

/// Mensaje pequeño debajo de un campo
struct MensajeCampo: View {
    let texto: String
    let tipo: EstadoCampo

    var body: some View {
        Label(texto, systemImage: tipo == .ok ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
            .font(.footnote.weight(.medium))
            .foregroundStyle(tipo == .ok ? Color.green : Color.red)
            .padding(.leading, 4)
    }
}

/// Tarjeta para elegir el rol
struct TarjetaRol: View {
    let titulo: String
    let detalle: String
    let icono: String
    let color: Color
    let seleccionado: Bool
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icono)
                        .font(.title3)
                        .foregroundStyle(seleccionado ? .white : color)
                        .frame(width: 38, height: 38)
                        .background(seleccionado ? color : color.opacity(0.14),
                                    in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    Spacer()
                    Image(systemName: seleccionado ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(seleccionado ? color : Color.secondary.opacity(0.5))
                }
                Text(titulo).font(.subheadline.weight(.semibold)).foregroundStyle(.primary)
                Text(detalle).font(.caption).foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(seleccionado ? color : .clear, lineWidth: 2))
        }
        .buttonStyle(.plain)
        .animation(.snappy, value: seleccionado)
    }
}

#Preview {
    NavigationStack { RegistroView() }
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
