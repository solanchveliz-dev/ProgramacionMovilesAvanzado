# Guía de comandos (CMD / Terminal)

## 1. Descomprimir y entrar a la carpeta
```cmd
cd Descargas
tar -xf Semana13_Laboratorio.zip
cd Semana13_Laboratorio
git log --oneline
```
(`git log` muestra los 16 commits ya hechos, uno por cada paso del laboratorio.)

## 2. Poner TU nombre en los commits
```cmd
git config user.name "Tu Nombre Apellido"
git config user.email "tu.correo@tecsup.edu.pe"
git rebase --root --exec "git commit --amend --no-edit --reset-author"
```

## 3. Subir a GitHub
Crea un repositorio VACÍO en github.com (sin README) llamado `Semana13_Laboratorio` y luego:
```cmd
git remote add origin https://github.com/TU_USUARIO/Semana13_Laboratorio.git
git push -u origin main
```

## 4. Si haces cambios después (por ejemplo, agregas capturas)
```cmd
git add .
git commit -m "docs: agrega capturas del simulador"
git push
```

## 5. Abrir en Xcode (Mac)
1. Xcode → File → New → Project → iOS → App → Interface **SwiftUI**.
   - Actividad 01: nombre `Semana13_API`
   - Actividades 02 y 03: nombre `Semana13_MetodosAPI`
2. Borra el `ContentView.swift` y el `...App.swift` que crea Xcode.
3. Arrastra las carpetas `Models`, `ViewModels`, `View` y el archivo `...App.swift`
   de la actividad al proyecto (marca **Copy items if needed**).
4. Ejecuta con ⌘R en un simulador de iPhone (iOS 15 o superior).
