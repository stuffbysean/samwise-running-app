import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "figure.run")
                    .font(.system(size: 80))
                    .foregroundColor(.samwisePrimary)
                
                Text("Samwise")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your loyal running companion")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 16) {
                    NavigationLink(destination: RunSetupView()) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("Start a Run")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.samwisePrimary)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: Text("My Runs - Coming Soon!")) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("My Runs")
                        }
                        .font(.subheadline)
                        .foregroundColor(.samwisePrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.samwisePrimary, lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: Text("Friends - Coming Soon!")) {
                        HStack {
                            Image(systemName: "person.2")
                            Text("Friends")
                        }
                        .font(.subheadline)
                        .foregroundColor(.samwisePrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.samwisePrimary, lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .background(Color.samwiseBackground)
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}