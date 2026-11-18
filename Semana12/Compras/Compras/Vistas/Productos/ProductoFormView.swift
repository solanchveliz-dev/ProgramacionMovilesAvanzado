import SwiftUI
import SwiftData
import PhotosUI
import UIKit

/// Crear o editar un producto (solo supervisor). Incluye foto desde la galería.
struct ProductoFormView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(\.dismiss) private var dismiss

    let producto: Producto?          // nil = nuevo

    @State private var nombre = ""
    @State private var categoria = Categoria.computo.rawValue
    @State private var stock = 0
    @State private var costoTexto = ""
    @State private var foto: Data?
    @State private var itemFoto: PhotosPickerItem?
    @State private var cargado = false

    private var esNuevo: Bool { producto == nil }
    private var costo: Double? { Double(costoTexto.replacingOccurrences(of: ",", with: ".")) }
    private var formularioValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && (costo ?? -1) >= 0
    }

    var body: some View {
        NavigationStack {
            Form {
                // Foto
                Section {
                    VStack(spacing: 10) {
                        PhotosPicker(selection: $itemFoto, matching: .images) {
                            ZStack(alignment: .bottomTrailing) {
                                MiniaturaProducto(foto: foto, categoria: categoria, tamano: 112)
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 30))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, .indigo)
                                    .offset(x: 8, y: 8)
                            }
                        }
                        .buttonStyle(.plain)
                        Text(foto == nil ? "Agregar foto" : "Cambiar foto")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.indigo)
                        if foto != nil {
                            Button("Quitar foto", role: .destructive) {
                                foto = nil
                                itemFoto = nil
                            }
                            .font(.footnote)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.clear)

                Section("Datos") {
                    TextField("Nombre del producto", text: $nombre)
                        .textInputAutocapitalization(.words)
                    Picker("Categoría", selection: $categoria) {
                        ForEach(Categoria.allCases) { c in
                            Label(c.rawValue, systemImage: c.icono).tag(c.rawValue)
                        }
                    }
                }

                Section {
                    Stepper(value: $stock, in: 0...100_000) {
                        HStack {
                            Text("Stock")
                            Spacer()
                            Text("\(stock) u.").monospacedDigit().foregroundStyle(.secondary)
                        }
                    }
                    HStack {
                        Text("Costo promedio")
                        Spacer()
                        Text("S/").foregroundStyle(.secondary)
                        TextField("0.00", text: $costoTexto)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 110)
                    }
                } header: {
                    Text(esNuevo ? "Inventario inicial" : "Inventario")
                } footer: {
                    Text(esNuevo
                         ? "Costo sin IGV. Después, el stock y el costo promedio se actualizan solos con cada compra aprobada."
                         : "Cámbialos solo para corregir un error de registro: las compras aprobadas los actualizan automáticamente.")
                }
            }
            .navigationTitle(esNuevo ? "Nuevo producto" : "Editar producto")
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
            .onChange(of: itemFoto) {
                Task {
                    if let datos = try? await itemFoto?.loadTransferable(type: Data.self) {
                        foto = Self.comprimir(datos)
                    }
                }
            }
        }
    }

    private func cargarDatos() {
        guard !cargado, let producto else { return }
        nombre = producto.nombre
        categoria = producto.categoria
        stock = producto.stock
        costoTexto = String(format: "%.2f", producto.costoPromedio)
        foto = producto.foto
        cargado = true
    }

    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        let costoFinal = ReglasCompra.redondear(costo ?? 0)
        if let producto {
            producto.nombre = nombreLimpio
            producto.categoria = categoria
            producto.stock = stock
            producto.costoPromedio = costoFinal
            producto.foto = foto
        } else {
            contexto.insert(Producto(nombre: nombreLimpio, categoria: categoria,
                                     stock: stock, costoPromedio: costoFinal, foto: foto))
        }
        try? contexto.save()
        dismiss()
    }

    /// Reduce la foto a 600 px y JPEG 75 % para no llenar la base de datos
    static func comprimir(_ datos: Data) -> Data? {
        guard let imagen = UIImage(data: datos) else { return nil }
        let lado: CGFloat = 600
        let escala = min(1, lado / max(imagen.size.width, imagen.size.height))
        let tamano = CGSize(width: imagen.size.width * escala, height: imagen.size.height * escala)
        let reducida = UIGraphicsImageRenderer(size: tamano).image { _ in
            imagen.draw(in: CGRect(origin: .zero, size: tamano))
        }
        return reducida.jpegData(compressionQuality: 0.75)
    }
}
