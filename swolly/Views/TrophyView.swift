import SwiftUI

struct Competition: Identifiable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var isCreator: Bool // To check if the current user is the creator
    var joinCode: String  // Unique code to join the competition
}

struct TrophyView: View {
    @State private var competitions: [Competition] = []
    @State private var showingCreateCompetition = false
    @State private var showingJoinCompetition = false
    @State private var editingCompetition: Competition?

    var body: some View {
        NavigationView {
            List {
                Button("Join Competition") {
                    showingJoinCompetition = true
                }
                if competitions.isEmpty {
                    Button("Create Competition") {
                        showingCreateCompetition = true
                    }
                } else {
                    ForEach(competitions) { competition in
                        VStack(alignment: .leading) {
                            Text(competition.name)
                            Text("From \(competition.startDate, formatter: dateFormatter) to \(competition.endDate, formatter: dateFormatter)")
                            if competition.isCreator {
                                Button("Edit") {
                                    editingCompetition = competition
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Trophies", displayMode: .inline)
            .sheet(isPresented: $showingCreateCompetition) {
                CompetitionForm(competitions: $competitions)
            }
            .sheet(isPresented: $showingJoinCompetition) {
                JoinCompetitionView(competitions: $competitions)
            }
            .sheet(item: $editingCompetition) { comp in
                CompetitionEditForm(competition: comp, competitions: $competitions)
            }
        }
    }
}

struct CompetitionForm: View {
    @Binding var competitions: [Competition]
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationView {
            Form {
                TextField("Competition Name", text: $name)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                Button("Create") {
                    let joinCode = String.random(length: 6)  // Generate a 6-character join code
                    let newCompetition = Competition(name: name, startDate: startDate, endDate: endDate, isCreator: true, joinCode: joinCode)
                    competitions.append(newCompetition)
                    dismiss()
                }
            }
            .navigationBarTitle("New Competition", displayMode: .inline)
        }
    }
}

struct CompetitionEditForm: View {
    @Binding var competition: Competition
    @Binding var competitions: [Competition]
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var startDate: Date
    @State private var endDate: Date

    init(competition: Competition, competitions: Binding<[Competition]>) {
        _competition = Binding.constant(competition)
        _competitions = competitions
        _name = State(initialValue: competition.name)
        _startDate = State(initialValue: competition.startDate)
        _endDate = State(initialValue: competition.endDate)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Competition Name", text: $name)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                Button("Save Changes") {
                    if let index = competitions.firstIndex(where: { $0.id == competition.id }) {
                        competitions[index].name = name
                        competitions[index].startDate = startDate
                        competitions[index].endDate = endDate
                    }
                    dismiss()
                }
            }
            .navigationBarTitle("Edit Competition", displayMode: .inline)
        }
    }
}

struct JoinCompetitionView: View {
    @Binding var competitions: [Competition]
    @State private var joinCode = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Enter Join Code", text: $joinCode)
                Button("Join") {
                    joinCompetition()
                }
            }
            .navigationBarTitle("Join Competition", displayMode: .inline)
        }
    }

    private func joinCompetition() {
        if let competition = competitions.first(where: { $0.joinCode == joinCode.uppercased() }) {
            // Logic to add the user to the competition
            print("Joined competition: \(competition.name)")
            dismiss()
        } else {
            print("No competition found with that code")
        }
    }
}

// Helper to format dates
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// Add this utility function at the end of your Swift file
extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
