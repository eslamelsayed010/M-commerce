import SwiftUI

struct OrderDetailView: View {
    let order: ShopifyOrder

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Order #: \(order.name)")
                    .font(.title2)
                    .bold()

                Text("Email: \(order.email)")
                Text("Total: \(order.totalPrice) \(order.currency)")
                Text("Created: \(order.createdAt)")

                Divider().padding(.vertical)

                Text("Items:")
                    .font(.headline)

                ForEach(order.lineItems) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                        Text("Qty: \(item.quantity) • $ \(item.price)")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarBackButtonHidden(true)
        
    }
}
