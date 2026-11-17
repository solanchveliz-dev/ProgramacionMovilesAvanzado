import SwiftUI
import SwiftData

// UPDATE: editar un alumno existente.
// @Bindable permite enlazar los campos directamente a las propiedades del objeto @Model.
// SwiftData detecta el cambio y lo guarda solo.
struct EditarAlumnoView: View {

    @Bindable var alumno: Alumno
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Curso.nombre) private var cursos: [Curso]   // EXTRA

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Alumno")) {
                    TextField("Apellido", text: $alumno.apellido)
                    TextField("Nombre", text: $alumno.nombre)
                    TextField("DNI", text: $alumno.dni)
                        .keyboardType(.numberPad)
                }

                // EXTRA: cambiar el curso del alumno (se guarda solo, como los demás campos)
                Section(header: Text("Curso")) {
                    if cursos.isEmpty {
                        Text("No hay cursos. Créalos con el botón 📘 Cursos de la lista.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Curso", selection: $alumno.curso) {
                            Text("Sin curso").tag(Curso?.none)
                            ForEach(cursos) { curso in
                                Text(curso.nombre).tag(Optional(curso))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Editar Alumno")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}
