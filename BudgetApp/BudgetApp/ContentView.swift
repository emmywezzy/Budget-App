// ContentView.swift

import SwiftUI

struct ContentView: View {
    @ObservedObject var budget: Budget

    // Use @AppStorage for isReadyForBudget
    @AppStorage("isReadyForBudget") private var isReadyForBudget: Bool = false

    // State variables
    @State private var currentInput = ""
    @State private var currentCategory = ""
    @State private var isEditingIncome = false
    @State private var isEditingExpense = false
    @State private var selectedIncomeItem: BudgetItem?
    @State private var selectedExpenseItem: BudgetItem?
    @State private var showSummary = false

    // Undo Delete Variables
    @State private var showUndoAlert = false
    @State private var recentlyDeletedItem: (item: BudgetItem, isIncome: Bool)?

    var totalIncome: Double {
        budget.incomeItems.map { $0.amount }.reduce(0, +)
    }

    var totalExpenses: Double {
        budget.expenseItems.map { $0.amount }.reduce(0, +)
    }

    var balance: Double {
        totalIncome - totalExpenses
    }

    var outstandingIncome: Double {
        budget.incomeItems.filter { !$0.isCompleted }.map { $0.amount }.reduce(0, +)
    }

    var outstandingExpenses: Double {
        budget.expenseItems.filter { !$0.isCompleted }.map { $0.amount }.reduce(0, +)
    }

    var outstandingBalance: Double {
        outstandingIncome - outstandingExpenses
    }

    var body: some View {
        VStack(spacing: 20) {
            if !isReadyForBudget {
                Spacer()
                Text("Are you ready to budget for the month?")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.primary)

                Button(action: {
                    isReadyForBudget = true
                }) {
                    Text("Start")
                        .font(.title2)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                }
                Spacer()
            } else if showSummary {
                VStack(spacing: 10) {
                    Text("Budget Summary")
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.primary)

                    List {
                        Section(header: HStack {
                            Text("Income")
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: {
                                currentCategory = ""
                                currentInput = ""
                                isEditingIncome = true
                                showSummary = false
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                            }
                        }) {
                            ForEach(budget.incomeItems) { item in
                                BudgetItemRow(item: item, isIncome: true) {
                                    selectedIncomeItem = item
                                    currentCategory = item.category
                                    currentInput = "\(item.amount)"
                                    isEditingIncome = true
                                    showSummary = false
                                }
                            }
                        }
                        Section(header: HStack {
                            Text("Expenses")
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: {
                                currentCategory = ""
                                currentInput = ""
                                isEditingExpense = true
                                showSummary = false
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.primary)
                            }
                        }) {
                            ForEach(budget.expenseItems) { item in
                                BudgetItemRow(item: item, isIncome: false) {
                                    selectedExpenseItem = item
                                    currentCategory = item.category
                                    currentInput = "\(item.amount)"
                                    isEditingExpense = true
                                    showSummary = false
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())

                    // Total amounts
                    HStack {
                        Text("Total Income:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("$\(totalIncome, specifier: "%.2f")")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Total Expenses:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("$\(totalExpenses, specifier: "%.2f")")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Balance:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("$\(balance, specifier: "%.2f")")
                            .foregroundColor(balance >= 0 ? .green : .red)
                    }
                    .padding(.horizontal)
                    .font(.headline)

                    // Outstanding amounts
                    Text("Outstanding Amounts")
                        .font(.headline)
                        .padding(.top)
                        .foregroundColor(.primary)

                    HStack {
                        Text("Outstanding Income:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("$\(outstandingIncome, specifier: "%.2f")")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Outstanding Expenses:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("$\(outstandingExpenses, specifier: "%.2f")")
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Outstanding Balance:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("$\(outstandingBalance, specifier: "%.2f")")
                            .foregroundColor(outstandingBalance >= 0 ? .green : .red)
                    }
                    .padding(.horizontal)
                    .font(.headline)

                    HStack(spacing: 20) {
                        Button(action: {
                            showSummary = false
                        }) {
                            Text("Back")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            budget.incomeItems.removeAll()
                            budget.expenseItems.removeAll()
                            isReadyForBudget = false
                            showSummary = false
                        }) {
                            Text("Restart")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                        }
                    }
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Income Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Income")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                    currentCategory = ""
                                    currentInput = ""
                                    isEditingIncome = true
                                }) {
                                    Image(systemName: "plus")
                                        .padding()
                                        .background(Color.primary)
                                        .foregroundColor(Color(UIColor.systemBackground))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)

                            if budget.incomeItems.isEmpty {
                                Text("No income items added yet.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(budget.incomeItems) { item in
                                        BudgetItemRow(item: item, isIncome: true) {
                                            selectedIncomeItem = item
                                            currentCategory = item.category
                                            currentInput = "\(item.amount)"
                                            isEditingIncome = true
                                        }
                                    }
                                }
                            }
                        }

                        // Expenses Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Expenses")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                    currentCategory = ""
                                    currentInput = ""
                                    isEditingExpense = true
                                }) {
                                    Image(systemName: "plus")
                                        .padding()
                                        .background(Color.primary)
                                        .foregroundColor(Color(UIColor.systemBackground))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)

                            if budget.expenseItems.isEmpty {
                                Text("No expense items added yet.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(budget.expenseItems) { item in
                                        BudgetItemRow(item: item, isIncome: false) {
                                            selectedExpenseItem = item
                                            currentCategory = item.category
                                            currentInput = "\(item.amount)"
                                            isEditingExpense = true
                                        }
                                    }
                                }
                            }
                        }

                        Button(action: {
                            showSummary = true
                        }) {
                            Text("Show Summary")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.primary)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarTitle(budget.name, displayMode: .inline)
        // Modals and alerts...
        .sheet(isPresented: $isEditingIncome) {
            EditItemView(title: "Income", category: $currentCategory, amount: $currentInput) { category, amount in
                saveIncomeItem(category: category, amount: amount)
            }
        }
        .sheet(isPresented: $isEditingExpense) {
            EditItemView(title: "Expense", category: $currentCategory, amount: $currentInput) { category, amount in
                saveExpenseItem(category: category, amount: amount)
            }
        }
        .alert(isPresented: $showUndoAlert) {
            Alert(
                title: Text("Item Deleted"),
                message: Text("Would you like to undo?"),
                primaryButton: .default(Text("Undo")) {
                    if let item = recentlyDeletedItem {
                        if item.isIncome {
                            budget.incomeItems.append(item.item)
                        } else {
                            budget.expenseItems.append(item.item)
                        }
                        recentlyDeletedItem = nil
                    }
                },
                secondaryButton: .cancel(Text("Dismiss")) {
                    recentlyDeletedItem = nil
                }
            )
        }
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
    }

    // Functions for saving items
    func saveIncomeItem(category: String, amount: String) {
        if let amountValue = Double(amount), !category.isEmpty {
            if let selectedItem = selectedIncomeItem {
                selectedItem.category = category
                selectedItem.amount = amountValue
                selectedIncomeItem = nil
            } else {
                let newItem = BudgetItem(category: category, amount: amountValue)
                budget.incomeItems.append(newItem)
            }
        }
        isEditingIncome = false
        showSummary = true
    }

    func saveExpenseItem(category: String, amount: String) {
        if let amountValue = Double(amount), !category.isEmpty {
            if let selectedItem = selectedExpenseItem {
                selectedItem.category = category
                selectedItem.amount = amountValue
                selectedExpenseItem = nil
            } else {
                let newItem = BudgetItem(category: category, amount: amountValue)
                budget.expenseItems.append(newItem)
            }
        }
        isEditingExpense = false
        showSummary = true
    }

    // Functions for deleting items
    func deleteIncome(at offsets: IndexSet) {
        for index in offsets {
            let item = budget.incomeItems[index]
            recentlyDeletedItem = (item, true)
            budget.incomeItems.remove(at: index)
            showUndoAlert = true
        }
    }

    func deleteExpense(at offsets: IndexSet) {
        for index in offsets {
            let item = budget.expenseItems[index]
            recentlyDeletedItem = (item, false)
            budget.expenseItems.remove(at: index)
            showUndoAlert = true
        }
    }
}
