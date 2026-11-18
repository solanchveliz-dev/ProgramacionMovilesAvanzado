import SwiftUI
import SwiftData

/// Crear o editar un proveedor (solo supervisor) con validación de RUC
struct ProveedorFormView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var dismiss
    @Query private var todos: [Proveedor]

    let proveedor: Proveedor?          // nil = nuevo

    @State private var nombre = ""
    @State private var ruc = ""
    @State private var cargado = false

    private var esNuevo: Bool { proveedor == nil }
    private var rucValido: Bool { ReglasCompra.rucValido(ruc) }

    /// Otro proveedor ya usa este RUC
    private var rucRepetido: Bool {
        todos.contains { $0.ruc == ruc && $0.persistentModelID != proveedor?.persistentModelID }
    }

    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && rucValido && !rucRepetido
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        LogoProveedor(nombre: nombre.isEmpty ? "?" : nombre, tamano: 84)
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)

                Section("Razón social") {
                    TextField("Ej: Distribuidora Andina S.A.C.", text: $nombre)
                        .textInputAutocapitalization(.words)
                }

                Section {
                    TextField("11 dígitos", text: $ruc)
                        .keyboardType(.numberPad)
                        .monospacedDigit()
                        .onChange(of: ruc) {
                            // Solo números y máximo 11
                            let limpio = String(ruc.filter(\.isNumber).prefix(11))
                            if limpio != ruc { ruc = limpio }
                        }
                } header: {
                    Text("RUC")
                } footer: {
                    if ruc.isEmpty {
                        Text("Empieza con 10 (persona natural) o 20 (empresa).")
                    } else if rucRepetido {
                        Label("Ya existe un proveedor con este RUC.", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    } else if rucValido {
                        Label("RUC válido", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Label("Debe tener 11 dígitos y empezar con 10 o 20 (\(ruc.count)/11).",
                              systemImage: "exclamationmark.circle.fill")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .navigationTitle(esNuevo ? "Nuevo proveedor" : "Editar proveedor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar", action: guardar)
                        .fontWeight(.semibold)
                        .disabled(!formularioValido)
                }
            }
            .onAppear(perform: cargarDatos)
        }
    }

    private func cargarDatos() {
        guard !cargado, let proveedor else { return }
        nombre = proveedor.nombre
        ruc = proveedor.ruc
        cargado = true
    }

    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        if let proveedor {
            proveedor.nombre = nombreLimpio
            proveedor.ruc = ruc
        } else {
            contexto.insert(Proveedor(nombre: nombreLimpio, ruc: ruc))
        }
        try? contexto.save()
        dismiss()
    }
}
