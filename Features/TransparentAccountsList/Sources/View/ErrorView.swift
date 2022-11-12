import SwiftUI

struct ErrorView: View {
    let message: String
    
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
            
        }.opacity(0.5)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Data se nepodařilo načíst")
    }
}