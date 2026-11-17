import SwiftUI
import SwiftData

// EXTRA: administrar cursos y ver los alumnos de cada curso (relación 1 a muchos)
struct CursosView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Curso.nombre) private var cursos: [Curso]
    @State private var nuevoCurso = ""

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Nuevo curso")) {
                    HStack {
                        TextField("Ej: Base de Datos", text: $nuevoCurso)
                        Button("Agregar") { agregarCurso() }
                            .disabled(nuevoCurso.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                Section(header: Text("Cursos")) {
                    if cursos.isEmpty {
                        Text("Aún no hay cursos").foregroundStyle(.secondary)
                    }
                    ForEach(cursos) { curso in
                        NavigationLink {
                            // Alumnos del curso: se leen por la relación curso.alumnos
                            List {
                                if curso.alumnos.isEmpty {
                                    Text("Este curso no tiene alumnos.\nAsígnalos desde Nuevo alumno o Editar.")
                                        .foregroundStyle(.secondary)
                                }
                                ForEach(curso.alumnos.sorted { $0.apellido < $1.apellido }) { alumno in
                                    VStack(alignment: .leading) {
                                        Text("\(alumno.apellido), \(alumno.nombre)").font(.headline)
                                        Text("DNI: \(alumno.dni)").font(.subheadline)
                                    }
                                }
                            }
                            .navigationTitle(curso.nombre)
                        } label: {
                            HStack {
                                Text(curso.nombre)
                                Spacer()
                                Text("\(curso.alumnos.count) alumno(s)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    // Borrar curso: por .nullify los alumnos NO se borran, quedan "Sin curso"
                    .onDelete { offsets in
                        for index in offsets {
                            modelContext.delete(cursos[index])
                        }
                        try? modelContext.save()
                    }
                }
            }
            .navigationTitle("📘 Cursos")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }

    private func agregarCurso() {
        let nombre = nuevoCurso.trimmingCharacters(in: .whitespaces)
        guard !nombre.isEmpty else { return }
        // Evita cursos repetidos
        if !cursos.contains(where: { $0.nombre.lowercased() == nombre.lowercased() }) {
            modelContext.insert(Curso(nombre: nombre))
            try? modelContext.save()
        }
        nuevoCurso = ""
    }
}

#Preview {
    CursosView()
        .modelContainer(for: [Alumno.self, Curso.self], inMemory: true)
}
