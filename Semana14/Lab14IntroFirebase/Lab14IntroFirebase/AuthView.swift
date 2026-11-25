//
//  AuthView.swift
//  Lab14IntroFirebase
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSignedIn = false
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showPassword = false
    @State private var animateBG = false
    @State private var authStateListener: AuthStateDidChangeListenerHandle?

    private let purple = Color(red: 0.38, green: 0.25, blue: 0.95)
    private let blue = Color(red: 0.10, green: 0.60, blue: 0.98)

    var body: some View {
        Group {
            if isSignedIn {
                // Show MessagesView when signed in
                MessagesView()
            } else {
                authScreen
            }
        }
        .animation(.easeInOut, value: isSignedIn)
        .alert("Mensaje", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onChange(of: isSignedIn) {
            // Clear form when signing out
            if !isSignedIn {
                email = ""
                password = ""
                confirmPassword = ""
                isRegistering = false
            }
        }
    }

    // MARK: - Pantalla Login / Registro
    private var authScreen: some View {
        ZStack {
            LinearGradient(colors: [purple, blue],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            // Burbujas animadas de fondo
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 320)
                .offset(x: animateBG ? -110 : -170, y: animateBG ? -260 : -330)
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 260)
                .offset(x: animateBG ? 170 : 120, y: animateBG ? 360 : 300)

            ScrollView {
                VStack(spacing: 28) {
                    // Logo y título
                    VStack(spacing: 14) {
                        Image(systemName: isRegistering ? "person.badge.plus" : "flame.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 90, height: 90)
                            .background(Color.white.opacity(0.2), in: Circle())
                            .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))

                        Text(isRegistering ? "Crear cuenta" : "Lab 14: Firebase")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(isRegistering ? "Regístrate para unirte al chat"
                                           : "Inicia sesión para continuar")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.top, 60)

                    // Tarjeta del formulario
                    VStack(spacing: 16) {
                        // Email
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.gray)
                                .frame(width: 20)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 14))

                        // Password
                        passwordField(placeholder: "Contraseña", text: $password)

                        // Solo en registro
                        if isRegistering {
                            if !password.isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    ProgressView(value: passwordStrength.progress)
                                        .tint(passwordStrength.color)
                                    Text("Seguridad: \(passwordStrength.label)")
                                        .font(.caption)
                                        .foregroundStyle(passwordStrength.color)
                                }
                            }

                            passwordField(placeholder: "Confirmar contraseña", text: $confirmPassword)

                            if !confirmPassword.isEmpty && confirmPassword != password {
                                Label("Las contraseñas no coinciden", systemImage: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }

                        // Botón principal
                        Button {
                            if isRegistering { signUp() } else { signIn() }
                        } label: {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(isRegistering ? "Registrarme" : "Iniciar sesión")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(isLoading)
                        .padding(.top, 6)
                    }
                    .padding(24)
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 26))
                    .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
                    .padding(.horizontal, 24)

                    // Cambiar entre Login y Registro
                    HStack(spacing: 4) {
                        Text(isRegistering ? "¿Ya tienes cuenta?" : "¿No tienes cuenta?")
                            .foregroundStyle(.white.opacity(0.85))
                        Button(isRegistering ? "Inicia sesión" : "Regístrate") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                isRegistering.toggle()
                                confirmPassword = ""
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    }
                    .font(.subheadline)

                    Text("Tecsup · Programación en Móviles Avanzados")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                animateBG = true
            }
        }
    }

    // Campo de contraseña reutilizable
    private func passwordField(placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(.gray)
                .frame(width: 20)
            Group {
                if showPassword {
                    TextField(placeholder, text: text)
                } else {
                    SecureField(placeholder, text: text)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 14))
    }

    private var passwordStrength: (label: String, color: Color, progress: Double) {
        switch password.count {
        case 0: return ("", .clear, 0)
        case 1..<6: return ("Débil", .red, 0.33)
        case 6..<10: return ("Media", .orange, 0.66)
        default: return ("Fuerte", .green, 1.0)
        }
    }

    // MARK: - Authentication Functions
    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Ingresa tu email y contraseña"
            showAlert = true
            return
        }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Error al iniciar sesión: \(error.localizedDescription)"
                showAlert = true
                print("error.localizedDescription: '\(error.localizedDescription)'")
            } else {
                isSignedIn = true
                alertMessage = "¡Inicio de sesión exitoso!"
                showAlert = true
            }
        }
    }

    func signUp() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Ingresa tu email y contraseña"
            showAlert = true
            return
        }
        guard password.count >= 6 else {
            alertMessage = "La contraseña debe tener al menos 6 caracteres"
            showAlert = true
            return
        }
        guard password == confirmPassword else {
            alertMessage = "Las contraseñas no coinciden"
            showAlert = true
            return
        }
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                alertMessage = "Error al registrarse: \(error.localizedDescription)"
                showAlert = true
            } else {
                isSignedIn = true
                alertMessage = "¡Cuenta creada con éxito!"
                showAlert = true
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            alertMessage = "Sesión cerrada"
            showAlert = true
        } catch {
            alertMessage = "Error al cerrar sesión: \(error.localizedDescription)"
            showAlert = true
        }
    }

    func checkAuthState() {
        // Listen for authentication state changes and store the listener handle
        authStateListener = Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isSignedIn = user != nil
            }
        }
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                LinearGradient(colors: [Color(red: 0.38, green: 0.25, blue: 0.95),
                                        Color(red: 0.10, green: 0.60, blue: 0.98)],
                               startPoint: .leading, endPoint: .trailing),
                in: RoundedRectangle(cornerRadius: 14)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(Color(red: 0.38, green: 0.25, blue: 0.95))
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(red: 0.38, green: 0.25, blue: 0.95), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .frame(height: 48)
            .background(Color.red, in: RoundedRectangle(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

#Preview {
    AuthView()
}
