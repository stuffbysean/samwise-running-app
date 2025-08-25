import SwiftUI

struct RunHistoryView: View {
    @State private var showingRunSetup = false
    
    var body: some View {
        NavigationView {
            emptyStateView
                .navigationTitle("My Runs")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingRunSetup = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(.samwisePrimary)
                        }
                    }
                }
        }
        .sheet(isPresented: $showingRunSetup) {
            RunSetupView()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "figure.run.circle")
                .font(.system(size: 80))
                .foregroundColor(.samwiseSecondary)
            
            VStack(spacing: 12) {
                Text("No Runs Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.samwiseText)
                
                Text("Create your first run to start receiving encouraging voice messages from friends!")
                    .font(.body)
                    .foregroundColor(.samwiseSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            SamwiseButton(
                "Create First Run",
                icon: "plus.circle.fill",
                type: .primary,
                size: .large,
                action: { showingRunSetup = true }
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.samwiseBackground)
    }
    
}

#Preview {
    RunHistoryView()
}