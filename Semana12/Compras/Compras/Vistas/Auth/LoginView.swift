import SwiftUI
import UIKit
import SwiftData

/// B1 · Iniciar sesión (encabezado con degradado + tarjeta, estilo app real)
struct LoginView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var error: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // ① Encabezado de marca: logo y nombre
                    VStack(spacing: 12) {
                        Image("LogoCaja")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54)
                            .frame(width: 92, height: 92)
                            .background(.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.white.opacity(0.35), lineWidth: 1))
                        Text("Compras Tecsup")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text("Gestión de compras, proveedores e inventario")
                            .font(.subheadline)
                            .opacity(0.85)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 70)
                    .padding(.bottom, 60)
                    .background(alignment: .top) {
                        ZStack {
                            LinearGradient.marca
                            // Foto de almacén opcional: agrega una imagen "FondoLogin" en Assets
                            if let foto = UIImage(named: "FondoLogin") {
                                Image(uiImage: foto)
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(LinearGradient(colors: [Color.marcaInicio.opacity(0.75),
                                                                     Color.marcaInicio.opacity(0.95)],
                                                            startPoint: .top, endPoint: .bottom))
                            } else {
                                Circle().fill(.white.opacity(0.08)).frame(width: 260, height: 260).offset(x: 140, y: -90)
                                Circle().fill(.white.opacity(0.06)).frame(width: 180, height: 180).offset(x: -150, y: 60)
                            }
                        }
                        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 36, bottomTrailingRadius: 36,
                                                          style: .continuous))
                        .ignoresSafeArea(edges: .top)
                    }

                    // ② Tarjeta con el formulario
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Iniciar sesión")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                        Text("Ingresa con tu usuario y clave")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 4)

                        CampoEtiquetado("Usuario") {
                            HStack(spacing: 10) {
                                Image(systemName: "person.fill").foregroundStyle(.secondary)
                                TextField("Tu usuario", text: $usuario)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                        }
                        CampoEtiquetado("Clave") {
                            CampoClave(placeholder: "Tu clave", texto: $clave, alEnviar: ingresar)
                        }

                        // ③ Mensaje de error genérico
                        if let error {
                            Label(error, systemImage: "exclamationmark.triangle.fill")
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(.red)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                        }

                        // ④ Ingresar
                        Button(action: ingresar) {
                            HStack {
                                Text("Ingresar").fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .foregroundStyle(.white)
                            .background(LinearGradient.marca, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .opacity(usuario.isEmpty || clave.isEmpty ? 0.5 : 1)
                        }
                        .disabled(usuario.isEmpty || clave.isEmpty)
                        .padding(.top, 6)
                    }
                    .padding(22)
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 20)
                    .offset(y: -30)

                    // Ⓐ Ir a Crear cuenta
                    HStack(spacing: 4) {
                        Text("¿No tienes una cuenta?").foregroundStyle(.secondary)
                        NavigationLink("Crear cuenta") { RegistroView() }
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .padding(.bottom, 30)
                }
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
