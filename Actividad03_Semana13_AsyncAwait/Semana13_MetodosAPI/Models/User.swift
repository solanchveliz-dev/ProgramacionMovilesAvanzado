//  Created by Juan Leon - Jaime Gómez
// Actividad 03: métodos GET - POST - PUT - DELETE con async/await

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
