import SwiftUI
import UIKit  // Import UIKit to access UIPasteboard

struct CompetitionDetailView: View {
    @Binding var competitions: [Competition]
    var competition: Competition
    var participantCount: Int
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Join Code: \(competition.joinCode)")
                        Spacer()
                        Button(action: copyJoinCode) {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Text("Days Remaining: \(daysRemaining())")
                    Text("Participants: \(participantCount)")
                }
                if competition.isCreator {
                    Section {
                        Button("Edit") {
                            // Navigate to an edit form or enable editing mode
                        }
                        Button("Delete", role: .destructive) {
                            deleteCompetition()
                        }
                    }
                }
            }
            .navigationBarTitle(Text(competition.name), displayMode: .inline)
        }
    }

    private func daysRemaining() -> Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: competition.endDate)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }

    private func copyJoinCode() {
        UIPasteboard.general.string = competition.joinCode
    }

    private func deleteCompetition() {
        if let index = competitions.firstIndex(where: { $0.id == competition.id }) {
            competitions.remove(at: index)
            presentationMode.wrappedValue.dismiss()
        }
    }
}
