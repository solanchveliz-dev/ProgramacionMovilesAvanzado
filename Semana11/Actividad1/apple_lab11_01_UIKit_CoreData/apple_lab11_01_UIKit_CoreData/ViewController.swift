import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // MARK: - Outlets
    @IBOutlet weak var TablaContacto: UITableView!

    // MARK: - Propiedades
    var contactos = [Contacto]()          // lo que se ve en la tabla
    var grupos = [Grupo]()                // los chips
    var grupoSeleccionado: Grupo?         // nil = "Todos"
    var searchController: UISearchController!
    let chipsStack = UIStackView()

    // MARK: - Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contactos"
        TablaContacto.dataSource = self
        TablaContacto.delegate = self

        configurarBuscador()
        configurarChips()
        mostrarRutaBaseDeDatos()
        recargarTodo()
    }

    // Recarga chips (grupos) + tabla (contactos)
    func recargarTodo() {
        grupos = obtenerGrupos()
        dibujarChips()
        cargarInfoCoreData()
    }

    // MARK: - Core Data Helper
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    func guardar() {
        do {
            try conexion().save()
        } catch {
            print("Error al guardar en BD: \(error.localizedDescription)")
        }
    }

    func mostrarRutaBaseDeDatos() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let ruta = delegate.persistentContainer.persistentStoreDescriptions.first?.url?.path ?? "sin ruta"
        print("Base de datos SQLite en: \(ruta)")
    }

    // MARK: - Buscador
    func configurarBuscador() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar contactos..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        cargarInfoCoreData()
    }

    // MARK: - Chips de grupos (Todos · Familia · Amigos · + Nuevo grupo)
    func configurarChips() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(scroll)

        chipsStack.axis = .horizontal
        chipsStack.spacing = 8
        chipsStack.alignment = .center
        chipsStack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(chipsStack)

        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: header.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: header.bottomAnchor),

            chipsStack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 16),
            chipsStack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -16),
            chipsStack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 10),
            chipsStack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -10),
            chipsStack.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor, constant: -20)
        ])

        TablaContacto.tableHeaderView = header
    }

    func dibujarChips() {
        chipsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Chip "Todos"
        chipsStack.addArrangedSubview(
            crearChip(titulo: "Todos", seleccionado: grupoSeleccionado == nil) { [weak self] in
                self?.seleccionarGrupo(nil)
            }
        )

        // Un chip por cada grupo guardado en Core Data
        for grupo in grupos {
            let cantidad = grupo.contactos?.count ?? 0
            let chip = crearChip(titulo: "\(grupo.nombre ?? "") (\(cantidad))",
                                 seleccionado: grupo == grupoSeleccionado) { [weak self] in
                self?.seleccionarGrupo(grupo)
            }
            // Mantener presionado el chip -> menú para eliminar el grupo
            chip.menu = UIMenu(title: grupo.nombre ?? "", children: [
                UIAction(title: "Eliminar grupo", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.confirmarEliminarGrupo(grupo)
                }
            ])
            chipsStack.addArrangedSubview(chip)
        }

        // Chip "+ Nuevo grupo"
        chipsStack.addArrangedSubview(
            crearChip(titulo: "+ Nuevo grupo", seleccionado: false) { [weak self] in
                self?.pedirNombreGrupo()
            }
        )
    }

    func crearChip(titulo: String, seleccionado: Bool, accion: @escaping () -> Void) -> UIButton {
        var config = seleccionado ? UIButton.Configuration.filled() : UIButton.Configuration.gray()
        config.title = titulo
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
        return UIButton(configuration: config, primaryAction: UIAction { _ in accion() })
    }

    func seleccionarGrupo(_ grupo: Grupo?) {
        grupoSeleccionado = grupo
        dibujarChips()
        cargarInfoCoreData()
    }

    // MARK: - READ: texto del buscador + grupo seleccionado
    func cargarInfoCoreData() {
        let texto = searchController?.searchBar.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        contactos = buscarContactos(texto: texto, grupo: grupoSeleccionado)
        TablaContacto.reloadData()
        mostrarMensajeSiVacio()
    }

    func mostrarMensajeSiVacio() {
        guard contactos.isEmpty else {
            TablaContacto.backgroundView = nil
            return
        }
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        if let grupo = grupoSeleccionado {
            label.text = "El grupo \(grupo.nombre ?? "") no tiene contactos.\nToca + para agregar."
        } else {
            label.text = "No hay contactos.\nToca + para agregar."
        }
        TablaContacto.backgroundView = label
    }

    // MARK: - CREATE: botón +
    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        guard let grupo = grupoSeleccionado else {
            // Estás en "Todos": se crea un contacto normal
            formularioNuevoContacto(grupo: nil)
            return
        }

        // Estás dentro de un grupo: crear uno nuevo o meter contactos que ya existen
        let hoja = UIAlertController(title: "Agregar a \(grupo.nombre ?? "")", message: nil, preferredStyle: .actionSheet)
        hoja.addAction(UIAlertAction(title: "Crear contacto nuevo", style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.formularioNuevoContacto(grupo: grupo) }
        })
        hoja.addAction(UIAlertAction(title: "Agregar contactos existentes", style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.agregarExistentes(a: grupo) }
        })
        hoja.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        hoja.popoverPresentationController?.barButtonItem = sender
        present(hoja, animated: true)
    }

    func formularioNuevoContacto(grupo: Grupo?) {
        let titulo = grupo == nil ? "Nuevo Contacto" : "Nuevo contacto en \(grupo?.nombre ?? "")"
        let alerta = UIAlertController(title: titulo, message: "Ingresa los datos", preferredStyle: .alert)

        alerta.addTextField { tf in
            tf.placeholder = "Nombre"
            tf.autocapitalizationType = .words
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

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            guard let self = self, let campos = alerta?.textFields else { return }

            let nombre = campos[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !nombre.isEmpty else { return }

            let nuevo = Contacto(context: self.conexion())
            nuevo.nombre = nombre
            nuevo.telefono = campos[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            nuevo.direccion = campos[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            nuevo.grupo = grupo                     // relación To One
            self.guardar()
            self.recargarTodo()

            // Si se creó desde "Todos" y ya hay grupos, pregunta a cuál pertenece
            if grupo == nil && !self.grupos.isEmpty {
                DispatchQueue.main.async { self.elegirGrupo(para: nuevo) }
            }
        })

        present(alerta, animated: true)
    }

    // Lista los contactos que NO están en el grupo; al tocar uno, se mete al grupo
    func agregarExistentes(a grupo: Grupo) {
        let disponibles = contactosFueraDelGrupo(grupo)

        guard !disponibles.isEmpty else {
            let aviso = UIAlertController(title: "Sin contactos disponibles",
                                          message: "Todos tus contactos ya están en \(grupo.nombre ?? "este grupo").",
                                          preferredStyle: .alert)
            aviso.addAction(UIAlertAction(title: "OK", style: .default))
            present(aviso, animated: true)
            return
        }

        let hoja = UIAlertController(title: "Agregar a \(grupo.nombre ?? "")",
                                     message: "Toca un contacto para agregarlo",
                                     preferredStyle: .actionSheet)
        for contacto in disponibles {
            let actual = contacto.grupo?.nombre.map { "  (ahora en \($0))" } ?? ""
            hoja.addAction(UIAlertAction(title: "\(contacto.nombre ?? "")\(actual)", style: .default) { [weak self] _ in
                contacto.grupo = grupo
                self?.guardar()
                self?.recargarTodo()
                // Vuelve a abrir la lista para seguir agregando
                DispatchQueue.main.async { self?.agregarExistentes(a: grupo) }
            })
        }
        hoja.addAction(UIAlertAction(title: "Listo", style: .cancel))
        hoja.popoverPresentationController?.sourceView = view
        hoja.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        present(hoja, animated: true)
    }

    // MARK: - Grupos: crear, asignar y eliminar
    func pedirNombreGrupo(alTerminar: ((Grupo) -> Void)? = nil) {
        let alerta = UIAlertController(title: "Nuevo Grupo", message: "Escribe el nombre del grupo", preferredStyle: .alert)
        alerta.addTextField { tf in
            tf.placeholder = "Ej: Familia, Trabajo, Amigos"
            tf.autocapitalizationType = .words
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Crear", style: .default) { [weak self, weak alerta] _ in
            guard let self = self else { return }
            let nombre = alerta?.textFields?.first?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !nombre.isEmpty, let grupo = self.crearGrupo(nombre: nombre) else { return }

            if let alTerminar = alTerminar {
                alTerminar(grupo)
                self.recargarTodo()
            } else {
                // Se abre el grupo recién creado para empezar a llenarlo
                self.grupos = self.obtenerGrupos()
                self.seleccionarGrupo(grupo)
            }
        })
        present(alerta, animated: true)
    }

    func elegirGrupo(para contacto: Contacto) {
        let hoja = UIAlertController(title: "Grupo de \(contacto.nombre ?? "")",
                                     message: "¿A qué grupo pertenece?",
                                     preferredStyle: .actionSheet)

        for grupo in obtenerGrupos() {
            let marca = (grupo == contacto.grupo) ? "✓ " : ""
            hoja.addAction(UIAlertAction(title: "\(marca)\(grupo.nombre ?? "")", style: .default) { [weak self] _ in
                contacto.grupo = grupo
                self?.guardar()
                self?.recargarTodo()
            })
        }
        hoja.addAction(UIAlertAction(title: "Nuevo grupo…", style: .default) { [weak self] _ in
            DispatchQueue.main.async {
                self?.pedirNombreGrupo { grupo in
                    contacto.grupo = grupo
                    self?.guardar()
                }
            }
        })
        hoja.addAction(UIAlertAction(title: "Sin grupo", style: .default) { [weak self] _ in
            contacto.grupo = nil
            self?.guardar()
            self?.recargarTodo()
        })
        hoja.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        hoja.popoverPresentationController?.sourceView = view
        hoja.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        present(hoja, animated: true)
    }

    func confirmarEliminarGrupo(_ grupo: Grupo) {
        let alerta = UIAlertController(
            title: "Eliminar grupo \"\(grupo.nombre ?? "")\"",
            message: "Los contactos NO se borran, solo quedan sin grupo (Delete Rule: Nullify).",
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if self.grupoSeleccionado == grupo { self.grupoSeleccionado = nil }
            self.conexion().delete(grupo)
            self.guardar()
            self.recargarTodo()
        })
        present(alerta, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let grupo = grupoSeleccionado {
            return "Contactos de \(grupo.nombre ?? "") (\(contactos.count))"
        }
        return "Todos los contactos (\(contactos.count))"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contacto = contactos[indexPath.row]

        cell.imageView?.image = UIImage(systemName: "person.crop.circle")
        cell.textLabel?.text = contacto.nombre
        cell.detailTextLabel?.text = "\(contacto.telefono ?? "") · \(contacto.grupo?.nombre ?? "Sin grupo")"

        // Botones editar / eliminar
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12

        let btnEditar = UIButton(type: .system)
        btnEditar.setImage(UIImage(systemName: "pencil"), for: .normal)
        btnEditar.tintColor = .systemBlue
        btnEditar.tag = indexPath.row
        btnEditar.addTarget(self, action: #selector(accionBotonEditar(_:)), for: .touchUpInside)

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

    // Tocar un contacto: ver datos, cambiar o quitar de grupo
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let c = contactos[indexPath.row]

        let detalle = UIAlertController(
            title: c.nombre,
            message: "Teléfono: \(c.telefono ?? "-")\nDirección: \(c.direccion ?? "-")\nGrupo: \(c.grupo?.nombre ?? "Sin grupo")",
            preferredStyle: .alert
        )
        detalle.addAction(UIAlertAction(title: "Cambiar grupo", style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.elegirGrupo(para: c) }
        })
        if c.grupo != nil {
            detalle.addAction(UIAlertAction(title: "Quitar del grupo", style: .destructive) { [weak self] _ in
                c.grupo = nil
                self?.guardar()
                self?.recargarTodo()
            })
        }
        detalle.addAction(UIAlertAction(title: "Cerrar", style: .cancel))
        present(detalle, animated: true)
    }

    // MARK: - Acciones de los botones de la celda
    @objc func accionBotonEditar(_ sender: UIButton) {
        mostrarAlertaEdicion(para: IndexPath(row: sender.tag, section: 0))
    }

    @objc func accionBotonEliminar(_ sender: UIButton) {
        confirmarEliminacion(para: IndexPath(row: sender.tag, section: 0))
    }

    // MARK: - UPDATE
    func mostrarAlertaEdicion(para indexPath: IndexPath) {
        let contactoEditar = contactos[indexPath.row]
        let alert = UIAlertController(title: "Editar Contacto", message: "Modifica los datos", preferredStyle: .alert)

        alert.addTextField { tf in tf.text = contactoEditar.nombre; tf.clearButtonMode = .whileEditing }
        alert.addTextField { tf in tf.text = contactoEditar.telefono; tf.keyboardType = .phonePad; tf.clearButtonMode = .whileEditing }
        alert.addTextField { tf in tf.text = contactoEditar.direccion; tf.clearButtonMode = .whileEditing }

        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alert] _ in
            guard let self = self, let campos = alert?.textFields else { return }
            let nuevoNombre = campos[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !nuevoNombre.isEmpty else { return }

            contactoEditar.nombre = nuevoNombre
            contactoEditar.telefono = campos[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            contactoEditar.direccion = campos[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.guardar()
            self.recargarTodo()
        })
        alert.addAction(UIAlertAction(title: "Cambiar grupo", style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.elegirGrupo(para: contactoEditar) }
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - DELETE
    func confirmarEliminacion(para indexPath: IndexPath) {
        let contacto = contactos[indexPath.row]
        let alerta = UIAlertController(
            title: "Eliminar Contacto",
            message: "¿Seguro que deseas eliminar a \"\(contacto.nombre ?? "este contacto")\"?",
            preferredStyle: .alert
        )
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.conexion().delete(contacto)
            self.guardar()
            self.recargarTodo()
        })
        present(alerta, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmarEliminacion(para: indexPath)
        }
    }
}
