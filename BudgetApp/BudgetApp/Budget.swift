// Budget.swift

import Foundation
import SwiftUI
import Combine

class Budget: Identifiable, ObservableObject, Codable {
    let id: UUID
    var name: String
    @Published var incomeItems: [BudgetItem] = [] {
        didSet {
            setupSubscriptions()
        }
    }
    @Published var expenseItems: [BudgetItem] = [] {
        didSet {
            setupSubscriptions()
        }
    }
    var date: Date

    enum CodingKeys: CodingKey {
        case id, name, incomeItems, expenseItems, date
    }

    private var cancellables = Set<AnyCancellable>()

    init(id: UUID = UUID(), name: String, incomeItems: [BudgetItem] = [], expenseItems: [BudgetItem] = [], date: Date = Date()) {
        self.id = id
        self.name = name
        self.incomeItems = incomeItems
        self.expenseItems = expenseItems
        self.date = date
        setupSubscriptions()
    }

    // Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        incomeItems = try container.decode([BudgetItem].self, forKey: .incomeItems)
        expenseItems = try container.decode([BudgetItem].self, forKey: .expenseItems)
        date = try container.decode(Date.self, forKey: .date)
        setupSubscriptions()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(incomeItems, forKey: .incomeItems)
        try container.encode(expenseItems, forKey: .expenseItems)
        try container.encode(date, forKey: .date)
    }

    // Observe changes in BudgetItem instances
    private func setupSubscriptions() {
        cancellables.removeAll()
        for item in incomeItems {
            item.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
        for item in expenseItems {
            item.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
}
