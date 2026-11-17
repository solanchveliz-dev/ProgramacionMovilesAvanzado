import Foundation

/// Formatos de la app: soles y fechas
enum Formato {
    static let numero: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")   // 1,416.00 (como en los casos de prueba)
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()
}

extension Double {
    /// 1416 -> "S/ 1,416.00"
    var soles: String {
        "S/ " + (Formato.numero.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self))
    }
}

extension Date {
    /// 17/12/2026
    var corta: String {
        formatted(.dateTime.day(.twoDigits).month(.twoDigits).year())
    }
}
