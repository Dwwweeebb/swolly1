import SwiftUI

struct TrophyView: View {
    @State private var competitions: [Competition] = []
    @State private var showingCreateCompetition = false
    @State private var showingJoinCompetition = false

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
                        NavigationLink(destination: CompetitionDetailView(competitions: $competitions, competition: competition, participantCount: 5)) {
                            VStack(alignment: .leading) {
                                Text(competition.name)
                                Text("From \(competition.startDate, formatter: dateFormatter) to \(competition.endDate, formatter: dateFormatter)")
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
