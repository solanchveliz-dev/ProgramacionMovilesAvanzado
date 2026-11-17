import UIKit
import CoreData

extension ViewController {

    // MARK: - Paso 11: Fetch requests con predicate

    // Busca por nombre y/o por grupo. Si los dos están vacíos, trae todos.
    func buscarContactos(texto: String, grupo: Grupo?) -> [Contacto] {
        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]

        var filtros: [NSPredicate] = []
        if !texto.isEmpty {
            filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto))   // [cd]: sin mayúsculas ni tildes
        }
        if let grupo = grupo {
            filtros.append(NSPredicate(format: "grupo == %@", grupo))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)

        do {
            return try conexion().fetch(request)
        } catch {
            print("Error al buscar: \(error.localizedDescription)")
            return []
        }
    }

    // Predicate que recorre la relación: contacto -> grupo -> nombre
    func contactosDelGrupo(_ nombreGrupo: String) -> [Contacto] {
        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.predicate = NSPredicate(format: "grupo.nombre == %@", nombreGrupo)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? conexion().fetch(request)) ?? []
    }

    // Contactos que todavía no pertenecen a un grupo dado
    func contactosFueraDelGrupo(_ grupo: Grupo) -> [Contacto] {
        let request: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        request.predicate = NSPredicate(format: "grupo == nil OR grupo != %@", grupo)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? conexion().fetch(request)) ?? []
    }

    // MARK: - Paso 12: Relación uno a muchos (Grupo -> Contactos)

    func obtenerGrupos() -> [Grupo] {
        let request: NSFetchRequest<Grupo> = Grupo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? conexion().fetch(request)) ?? []
    }

    // Crea el grupo; si ya existe uno con el mismo nombre, devuelve ese
    func crearGrupo(nombre: String) -> Grupo? {
        let contexto = conexion()

        let request: NSFetchRequest<Grupo> = Grupo.fetchRequest()
        request.predicate = NSPredicate(format: "nombre ==[c] %@", nombre)
        if let existente = (try? contexto.fetch(request))?.first {
            return existente
        }

        let grupo = NSEntityDescription.insertNewObject(forEntityName: "Grupo", into: contexto) as! Grupo
        grupo.nombre = nombre
        do {
            try contexto.save()
            return grupo
        } catch {
            print("Error al crear grupo: \(error.localizedDescription)")
            return nil
        }
    }

    // Prueba original de la guía (ya no se llama desde viewDidLoad)
    func probarRelacion() {
        let contexto = conexion()
        let grupo = NSEntityDescription.insertNewObject(forEntityName: "Grupo", into: contexto) as! Grupo
        grupo.nombre = "Amigos"
        if let primero = contactos.first {
            primero.grupo = grupo
        }
        do {
            try contexto.save()
            print("El grupo \(grupo.nombre ?? "") tiene \(grupo.contactos?.count ?? 0) contacto(s)")
        } catch {
            print("Error al guardar la relación: \(error.localizedDescription)")
        }
    }
}
