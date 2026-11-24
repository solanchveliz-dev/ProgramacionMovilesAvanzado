import SwiftUI

/// Pantalla de bienvenida que se ve al abrir la app (Run)
struct SplashView: View {
    @State private var aparecer = false

    var body: some View {
        ZStack {
            LinearGradient.marca
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image("LogoCaja")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110)
                    .scaleEffect(aparecer ? 1 : 0.7)
                    .opacity(aparecer ? 1 : 0)
                VStack(spacing: 4) {
                    Text("Compras")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                    Text("Gestión de compras a proveedores")
                        .font(.subheadline)
                        .opacity(0.85)
                }
                .foregroundStyle(.white)
                .opacity(aparecer ? 1 : 0)
                .offset(y: aparecer ? 0 : 10)
            }
        }
        .onAppear {
            withAnimation(.spring(duration: 0.7)) { aparecer = true }
        }
    }
}

#Preview { SplashView() }
