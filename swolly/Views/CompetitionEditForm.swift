import SwiftUI

struct CompetitionEditForm: View {
    @Binding var competition: Competition
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Competition Name", text: $competition.name)
                DatePicker("Start Date", selection: $competition.startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $competition.endDate, displayedComponents: .date)
                Button("Save Changes") {
                    dismiss()
                }
            }
            .navigationBarTitle("Edit Competition", displayMode: .inline)
        }
    }
}
