// HomeView.swift

import SwiftUI

struct HomeView: View {
    @State private var budgets: [Budget] = []
    @State private var isAddingBudget = false
    @State private var newBudgetName = ""
    @State private var selectedBudget: Budget?
    @Environment(\.colorScheme) var colorScheme // Detect light or dark mode

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(budgets) { budget in
                        Button(action: {
                            selectedBudget = budget
                        }) {
                            HStack {
                                Text(budget.name)
                                    .font(.headline)
                                    .foregroundColor(.primary) // Adapts to color scheme
                                Spacer()
                                Text(budget.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onDelete(perform: deleteBudget)
                }
                .listStyle(PlainListStyle())
                .background(Color(UIColor.systemBackground)) // Adaptive background

                Button(action: {
                    isAddingBudget = true
                }) {
                    Text("Add New Budget")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.primary) // Adaptive button color
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("My Budgets")
            .sheet(isPresented: $isAddingBudget) {
                VStack {
                    Text("New Budget")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.primary)
                    TextField("Budget Name", text: $newBudgetName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: {
                        let newBudget = Budget(name: newBudgetName)
                        budgets.append(newBudget)
                        newBudgetName = ""
                        isAddingBudget = false
                    }) {
                        Text("Create")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primary)
                            .foregroundColor(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .padding()
                    }
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            }
            .sheet(item: $selectedBudget) { budget in
                ContentView(budget: budget)
            }
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        }
        .onAppear(perform: loadBudgets)
        .onDisappear(perform: saveBudgets)
        .accentColor(.primary) // Adaptive accent color
    }

    func deleteBudget(at offsets: IndexSet) {
        budgets.remove(atOffsets: offsets)
    }

    func saveBudgets() {
        if let encoded = try? JSONEncoder().encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: "Budgets")
        }
    }

    func loadBudgets() {
        if let data = UserDefaults.standard.data(forKey: "Budgets") {
            if let decoded = try? JSONDecoder().decode([Budget].self, from: data) {
                budgets = decoded
            }
        }
    }
}
