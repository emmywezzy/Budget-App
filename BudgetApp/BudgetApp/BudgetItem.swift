// BudgetItem.swift

import Foundation
import SwiftUI

class BudgetItem: Identifiable, ObservableObject, Codable {
    let id: UUID
    @Published var category: String
    @Published var amount: Double
    @Published var isCompleted: Bool

    enum CodingKeys: CodingKey {
        case id, category, amount, isCompleted
    }

    init(id: UUID = UUID(), category: String, amount: Double, isCompleted: Bool = false) {
        self.id = id
        self.category = category
        self.amount = amount
        self.isCompleted = isCompleted
    }

    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        category = try container.decode(String.self, forKey: .category)
        amount = try container.decode(Double.self, forKey: .amount)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category, forKey: .category)
        try container.encode(amount, forKey: .amount)
        try container.encode(isCompleted, forKey: .isCompleted)
    }
}
