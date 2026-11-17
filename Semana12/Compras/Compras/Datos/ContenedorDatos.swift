import Foundation
import SwiftData

/// Único contenedor de SwiftData de la app (patrón Singleton).
@MainActor
final class ContenedorDatos {
    static let shared = ContenedorDatos()
    let container: ModelContainer

    private init() {
        let schema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self])
        do {
            let carpeta = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            try? FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)

            let config = ModelConfiguration(
                "ComprasData",
                schema: schema,
                url: carpeta.appendingPathComponent("ComprasData.sqlite")
            )
            print("Base de datos SQLite en: \(config.url.path)")
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Error al crear el contenedor: \(error)")
        }
    }
}
