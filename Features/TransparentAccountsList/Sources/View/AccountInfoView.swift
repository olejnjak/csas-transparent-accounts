import SwiftUI

struct AccountInfoView: View {
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(account.name)
                .font(.subheadline)
                .bold()
            
            if let description = account.description {
                Text(description)
                    .font(.caption)
            }
            
            if let note = account.note {
                Text(note)
                    .font(.caption2)
                    .italic()
            }
            
            Spacer(minLength: 32)
            
            Text(account.accountNumber)
                .font(.body)
        }
        .lineLimit(nil)
    }
}

struct AccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoView(account: .test())
    }
}
