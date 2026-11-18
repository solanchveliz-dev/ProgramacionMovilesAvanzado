import SwiftUI
import SwiftData

/// B1 · Iniciar sesión (fiel a la maqueta)
struct LoginView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var error: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    // ① Logo y nombre
                    VStack(spacing: 10) {
                        Image("LogoCaja")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .frame(width: 88, height: 88)
                            .background(
                                LinearGradient(colors: [Color(red: 0.39, green: 0.31, blue: 0.93),
                                                        Color(red: 0.12, green: 0.51, blue: 1.0)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        Text("Compras Tecsup")
                            .font(.title.bold())
                        Text("Inicia sesión para continuar")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    VStack(spacing: 12) {
                        // ② Usuario
                        CampoEtiquetado("Usuario") {
                            TextField("Tu usuario", text: $usuario)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        // ③ Clave oculta
                        CampoEtiquetado("Clave") {
                            SecureField("Tu clave", text: $clave)
                                .onSubmit(ingresar)
                        }
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
                        Text("¿Primera vez?").foregroundStyle(.secondary)
                        NavigationLink("Crear cuenta") { RegistroView() }
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                }
                .padding(24)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Ingresar")                      // Texto del botón Atrás en Crear cuenta
            .toolbar(.hidden, for: .navigationBar)
            .onChange(of: usuario) { error = nil }
            .onChange(of: clave) { if !clave.isEmpty { error = nil } }
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
