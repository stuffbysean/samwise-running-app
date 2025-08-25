import SwiftUI

struct FriendsPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: "person.2.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.samwiseSecondary)
                
                VStack(spacing: 16) {
                    Text("Friends Feature")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.samwiseText)
                    
                    Text("Coming Soon!")
                        .font(.title2)
                        .foregroundColor(.samwiseVoice)
                    
                    Text("Connect with friends, form running groups, and challenge each other to reach your goals together.")
                        .font(.body)
                        .foregroundColor(.samwiseSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                VStack(spacing: 12) {
                    Text("Features in development:")
                        .font(.headline)
                        .foregroundColor(.samwiseText)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(icon: "person.badge.plus", text: "Add & invite friends")
                        FeatureRow(icon: "chart.bar", text: "Compare run statistics")  
                        FeatureRow(icon: "trophy", text: "Challenges & achievements")
                        FeatureRow(icon: "bell", text: "Friend run notifications")
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                Spacer()
                
                Text("For now, share your run links directly with friends so they can send you encouraging voice messages!")
                    .font(.footnote)
                    .foregroundColor(.samwiseSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
            }
            .navigationTitle("Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.samwisePrimary)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.samwiseVoice)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.samwiseText)
            
            Spacer()
        }
    }
}

#Preview {
    FriendsPlaceholderView()
}