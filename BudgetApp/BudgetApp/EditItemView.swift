// EditItemView.swift

import SwiftUI

struct EditItemView: View {
    var title: String
    @Binding var category: String
    @Binding var amount: String
    var onSave: (String, String) -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("\(title) Details").foregroundColor(.primary)) {
                    TextField("Category", text: $category)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("Edit \(title)", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.primary),
                trailing: Button("Save") {
                    onSave(category, amount)
                    presentationMode.wrappedValue.dismiss()
                }.foregroundColor(.primary)
            )
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
}
