import SwiftUI

struct HomeView: View {
    @State private var username = "User" // Replace with actual user data
    @State private var showingNewWorkout = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text("Workouts and Competitions Feed")
                    // Implement feed here
                }
            }
            .navigationBarTitle(Text(username), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    showingNewWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingNewWorkout) {
                NewWorkoutView()
            }
        }
    }
}
