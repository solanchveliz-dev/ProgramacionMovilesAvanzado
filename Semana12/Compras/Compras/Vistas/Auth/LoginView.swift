import SwiftUI
import SwiftData

/// B1 · Iniciar sesión
struct LoginView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var error: String?
    @FocusState private var campo: Campo?

    private enum Campo { case usuario, clave }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // ① Logo y nombre
                    VStack(spacing: 12) {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 88, height: 88)
                            .background(
                                LinearGradient(colors: [.indigo, .blue],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                            )
                            .shadow(color: .indigo.opacity(0.3), radius: 12, y: 6)
                        Text("Compras")
                            .font(.largeTitle.bold())
                        Text("Gestión de compras a proveedores")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    VStack(spacing: 12) {
                        // ② Usuario
                        HStack {
                            Image(systemName: "person").foregroundStyle(.secondary).frame(width: 24)
                            TextField("Usuario", text: $usuario)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .focused($campo, equals: .usuario)
                                .submitLabel(.next)
                                .onSubmit { campo = .clave }
                        }
                        .padding()
                        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))

                        // ③ Clave oculta
                        HStack {
                            Image(systemName: "lock").foregroundStyle(.secondary).frame(width: 24)
                            SecureField("Clave", text: $clave)
                                .focused($campo, equals: .clave)
                                .submitLabel(.go)
                                .onSubmit(ingresar)
                        }
                        .padding()
                        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12))
                    }

                    // ④ Mensaje de error genérico
                    if let error {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // ⑤ Ingresar
                    Button(action: ingresar) {
                        Text("Ingresar")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(usuario.isEmpty || clave.isEmpty)

                    // Ⓐ Ir a Crear cuenta
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?").foregroundStyle(.secondary)
                        NavigationLink("Crear cuenta") { RegistroView() }
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .padding(24)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: usuario) { error = nil }
            .onChange(of: clave) { error = nil }
        }
    }

    private func ingresar() {
        do {
            let encontrado = try ServicioAuth.iniciarSesion(usuario: usuario, clave: clave, en: contexto)
            sesion.iniciar(encontrado)
        } catch {
            self.error = error.localizedDescription      // "Usuario o clave incorrectos"
            clave = ""
        }
    }
}

#Preview {
    LoginView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
