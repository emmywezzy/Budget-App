// BudgetItemRow.swift

import SwiftUI

struct BudgetItemRow: View {
    @ObservedObject var item: BudgetItem
    var isIncome: Bool
    var onEdit: () -> Void

    var body: some View {
        HStack {
            // Checkbox Button
            Button(action: {
                item.isCompleted.toggle()
            }) {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(.primary)
            }
            .buttonStyle(PlainButtonStyle())

            // Item Text
            Text(item.category)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            // Item Amount
            Text("$\(item.amount, specifier: "%.2f")")
                .font(.body)
                .foregroundColor(.primary)

            // Edit Button
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .foregroundColor(.primary)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.primary.opacity(0.1), radius: 2)
        .padding(.horizontal)
    }
}
