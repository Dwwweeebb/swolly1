import Foundation

struct Competition: Identifiable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var isCreator: Bool
    var joinCode: String
}
