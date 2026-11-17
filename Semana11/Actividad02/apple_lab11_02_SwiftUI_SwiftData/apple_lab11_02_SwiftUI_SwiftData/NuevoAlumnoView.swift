import SwiftUI
import SwiftData

struct NuevoAlumnoView: View {

    @Environment(\.modelContext) private var modelContext // Contexto del modelo (insertar, guardar, eliminar)
    @Environment(\.dismiss) private var dismiss // Cierra esta vista (como un "volver")

    @Query(sort: \Curso.nombre) private var cursos: [Curso]   // EXTRA: cursos para elegir

    @State private var apellido = ""
    @State private var nombre = ""
    @State private var dni = ""
    @State private var cursoSeleccionado: Curso?               // EXTRA

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Datos del Alumno")) {
                    TextField("Apellido", text: $apellido)
                    TextField("Nombre", text: $nombre)
                    TextField("DNI", text: $dni)
                        .keyboardType(.numberPad)
                }

                // EXTRA: elegir el curso del alumno
                Section(header: Text("Curso")) {
                    if cursos.isEmpty {
                        Text("No hay cursos. Créalos con el botón 📘 Cursos de la lista.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Curso", selection: $cursoSeleccionado) {
                            Text("Sin curso").tag(Curso?.none)
                            ForEach(cursos) { curso in
                                Text(curso.nombre).tag(Optional(curso))
                            }
                        }
                    }
                }

                Button("Guardar Alumno") {
                    // CREATE: crear el objeto e insertarlo en el contexto
                    let nuevoAlumno = Alumno(apellido: apellido, nombre: nombre, dni: dni)
                    nuevoAlumno.curso = cursoSeleccionado   // EXTRA: relación con el curso
                    modelContext.insert(nuevoAlumno)

                    // Guardamos de inmediato para asegurar la persistencia
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error al guardar alumno: \(error)")
                    }
                    dismiss() // Cierra el formulario
                }
                .disabled(apellido.isEmpty || nombre.isEmpty || dni.isEmpty) // Desactiva si hay campos vacíos
            }
            .navigationTitle("Nuevo Alumno")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss() // Cierra el formulario sin guardar
                    }
                }
            }
        }
    }
}

#Preview {
    NuevoAlumnoView()
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
