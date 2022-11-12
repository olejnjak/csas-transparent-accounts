import SwiftUI

struct AccountView: View {
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(account.name)
                .font(.subheadline)
                .bold()
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 0) {
                AccountInfoView(account: account)
                Spacer(minLength: 16)
                Text(account.balance)
                    .font(.body)
                    .bold()
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.5), lineWidth: 2)
        )
        .cornerRadius(16)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: .test())
    }
}
