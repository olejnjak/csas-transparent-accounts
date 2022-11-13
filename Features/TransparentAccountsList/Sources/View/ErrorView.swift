import SwiftUI

struct ErrorView: View {
    struct Action {
        let title: String
        let handler: () -> Void
    }
    
    let message: String
    let action: Action?
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .frame(width: 40, height: 40)
            
            Text(message)
                .foregroundColor(.primary)
                .font(.body)
                .lineLimit(nil)
                .multilineTextAlignment(.center)

            if let action {
                Button(action: action.handler) {
                    Text(action.title)
                }
                .buttonStyle(.bordered)
                .padding(.top)
            }
        }.opacity(0.5)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Data se nepodařilo načíst", action: nil)
    }
}
