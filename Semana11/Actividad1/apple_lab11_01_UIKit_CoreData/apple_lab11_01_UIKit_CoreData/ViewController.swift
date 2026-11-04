import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var TablaContacto: UITableView!
    
    // MARK: - Propiedades
    var contactos = [Contacto]()
    
    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        TablaContacto.dataSource = self
        TablaContacto.delegate = self
        
        mostrarRutaBaseDeDatos()
        cargarInfoCoreData()
    }

    // MARK: - Core Data Helper
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func mostrarRutaBaseDeDatos() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let ruta = delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "sin ruta"
        print("Base de datos SQLite en: \(ruta)")
    }

    // MARK: - READ: Leer los datos de Core Data
    func cargarInfoCoreData() {
        let contexto = conexion()
        let fetchRequest: NSFetchRequest<Contacto> = Contacto.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch {
            print("Error al cargar la BD: \(error.localizedDescription)")
        }
    }

    // MARK: - CREATE: Agregar un nuevo contacto (+)
    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Nuevo Contacto", message: "Ingresa los datos", preferredStyle: .alert)
        
        alerta.addTextField { tf in
            tf.placeholder = "Nombre"
            tf.clearButtonMode = .whileEditing
        }
        alerta.addTextField { tf in
            tf.placeholder = "Teléfono"
            tf.keyboardType = .phonePad
            tf.clearButtonMode = .whileEditing
        }
        alerta.addTextField { tf in
            tf.placeholder = "Dirección"
            tf.clearButtonMode = .whileEditing
        }
        
        let guardar = UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            guard let self = self, let campos = alerta?.textFields else { return }
            
            let nombreText = campos[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !nombreText.isEmpty else { return }
            
            let telefonoText = campos[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let direccionText = campos[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            let contexto = self.conexion()
            let nuevoContacto = Contacto(context: contexto)
            nuevoContacto.nombre = nombreText
            nuevoContacto.telefono = telefonoText
            nuevoContacto.direccion = direccionText
            
            do {
                try contexto.save()
                self.cargarInfoCoreData()
                self.TablaContacto.reloadData()
            } catch {
                print("Error al guardar en BD: \(error.localizedDescription)")
            }
        }
        
        alerta.addAction(guardar)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alerta, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contacto = contactos[indexPath.row]
        
        cell.textLabel?.text = contacto.nombre
        cell.detailTextLabel?.text = "\(contacto.telefono ?? "") | \(contacto.direccion ?? "")"
        
        // --- BOTONES CON ICONOS DENTRO DE LA CELDA ---
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        // Botón Editar (Lápiz)
        let btnEditar = UIButton(type: .system)
        btnEditar.setImage(UIImage(systemName: "pencil"), for: .normal)
        btnEditar.tintColor = .systemBlue
        btnEditar.tag = indexPath.row
        btnEditar.addTarget(self, action: #selector(accionBotonEditar(_:)), for: .touchUpInside)
        
        // Botón Eliminar (Tacho de basura)
        let btnEliminar = UIButton(type: .system)
        btnEliminar.setImage(UIImage(systemName: "trash"), for: .normal)
        btnEliminar.tintColor = .systemRed
        btnEliminar.tag = indexPath.row
        btnEliminar.addTarget(self, action: #selector(accionBotonEliminar(_:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(btnEditar)
        stackView.addArrangedSubview(btnEliminar)
        
        stackView.frame = CGRect(x: 0, y: 0, width: 70, height: 35)
        cell.accessoryView = stackView
        
        return cell
    }

    // MARK: - Acciones de los botones de la celda
    @objc func accionBotonEditar(_ sender: UIButton) {
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        mostrarAlertaEdicion(para: indexPath)
    }

    @objc func accionBotonEliminar(_ sender: UIButton) {
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        confirmarEliminacion(para: indexPath)
    }

    // MARK: - UPDATE: Mostrar alerta de edición
    func mostrarAlertaEdicion(para indexPath: IndexPath) {
        let contactoEditar = contactos[indexPath.row]
        
        let alert = UIAlertController(title: "Editar Contacto", message: "Modifica los datos", preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.text = contactoEditar.nombre
            tf.clearButtonMode = .whileEditing
        }
        alert.addTextField { tf in
            tf.text = contactoEditar.telefono
            tf.keyboardType = .phonePad
            tf.clearButtonMode = .whileEditing
        }
        alert.addTextField { tf in
            tf.text = contactoEditar.direccion
            tf.clearButtonMode = .whileEditing
        }
        
        let actionGuardar = UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alert] _ in
            guard let self = self, let campos = alert?.textFields else { return }
            
            let nuevoNombre = campos[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !nuevoNombre.isEmpty else { return }
            
            let nuevoTelefono = campos[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let nuevaDireccion = campos[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            let contexto = self.conexion()
            contactoEditar.nombre = nuevoNombre
            contactoEditar.telefono = nuevoTelefono
            contactoEditar.direccion = nuevaDireccion
            
            do {
                try contexto.save()
                self.cargarInfoCoreData()
                self.TablaContacto.reloadData()
            } catch {
                print("Error al actualizar la BD: \(error.localizedDescription)")
            }
        }
        
        alert.addAction(actionGuardar)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }

    // MARK: - DELETE: Confirmación antes de eliminar
    func confirmarEliminacion(para indexPath: IndexPath) {
        let contacto = contactos[indexPath.row]
        let nombreContacto = contacto.nombre ?? "este contacto"
        
        let alertaConfirmar = UIAlertController(
            title: "Eliminar Contacto",
            message: "¿Estás seguro de que deseas eliminar a \"\(nombreContacto)\"?",
            preferredStyle: .alert
        )
        
        let accionEliminar = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            self?.eliminarContacto(at: indexPath)
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertaConfirmar.addAction(accionEliminar)
        alertaConfirmar.addAction(accionCancelar)
        
        present(alertaConfirmar, animated: true)
    }

    // Eliminar un contacto de Core Data
    func eliminarContacto(at indexPath: IndexPath) {
        let contexto = conexion()
        let contactoEliminar = contactos[indexPath.row]
        
        contexto.delete(contactoEliminar)
        
        do {
            try contexto.save()
            contactos.remove(at: indexPath.row)
            TablaContacto.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Error al eliminar: \(error.localizedDescription)")
        }
    }

    // Swipe to delete con confirmación previa
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmarEliminacion(para: indexPath)
        }
    }
}
