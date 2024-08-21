import SwiftUI
import MapKit

struct DeliveryView: View {
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var estimatedCost = "Calculating..."
    @State private var estimatedTime = "Calculating..."
    @State private var searchText = ""
    @State private var selectedCategory: DeliveryCategory = .food
    @State private var showingOrderSummary = false
    @State private var selectedPaymentMethod = "Cash"
    @State private var orderItems: [OrderItem] = []
    @State private var showingItemPicker = false
    @State private var isTracking = false
    
    let paymentMethods = ["Cash", "Credit Card", "Mobile Money"]
    
    // FlexiGo theme colors
    let primaryColor = Color.black
    let accentColor = Color.white
    let backgroundColor = Color(UIColor.systemBackground)
    
    var body: some View {
        ZStack {
            MapTrackingView(isTracking: $isTracking)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                headerView
                
                if isTracking {
                    trackingView
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            SearchBarView(text: $searchText)
                            CategoryScrollView(selectedCategory: $selectedCategory, primaryColor: primaryColor, accentColor: accentColor)
                            AddressInputView(from: $from, to: $to, primaryColor: primaryColor)
                            EstimatesView(cost: $estimatedCost, time: $estimatedTime)
                            OrderItemsView(items: $orderItems, showingItemPicker: $showingItemPicker, primaryColor: primaryColor, accentColor: accentColor)
                            PaymentMethodView(selectedMethod: $selectedPaymentMethod, methods: paymentMethods, primaryColor: primaryColor)
                            
                            Button(action: {
                                showingOrderSummary = true
                            }) {
                                Text("Review Order")
                                    .foregroundColor(accentColor)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(primaryColor)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(backgroundColor.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingOrderSummary) {
            OrderSummaryView(from: from, to: to, cost: estimatedCost, time: estimatedTime, items: orderItems, paymentMethod: selectedPaymentMethod, onConfirm: confirmOrder, primaryColor: primaryColor, accentColor: accentColor)
        }
        .sheet(isPresented: $showingItemPicker) {
            ItemPickerView(items: $orderItems, primaryColor: primaryColor, accentColor: accentColor)
        }
        .onAppear {
            calculateEstimates()
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "cube.box.fill")
                .foregroundColor(primaryColor)
            Text("FlexiGo Delivery")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            if isTracking {
                Button(action: { isTracking = false }) {
                    Text("Cancel")
                        .foregroundColor(primaryColor)
                }
            }
        }
        .padding()
        .background(backgroundColor.opacity(0.8))
        .cornerRadius(15)
    }
    
    var trackingView: some View {
        VStack {
            Text("Your delivery is on the way!")
                .font(.headline)
            Text("Estimated arrival: \(estimatedTime)")
            Button(action: { /* Open chat with driver */ }) {
                Text("Chat with Driver")
                    .foregroundColor(accentColor)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(backgroundColor.opacity(0.9))
        .cornerRadius(15)
    }
    
    func calculateEstimates() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.estimatedCost = "$15.75"
            self.estimatedTime = "30-45 mins"
        }
    }
    
    func confirmOrder() {
        isTracking = true
        // Handle order confirmation logic
    }
}

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search shops, restaurants, etc.", text: $text)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct CategoryScrollView: View {
    @Binding var selectedCategory: DeliveryCategory
    let primaryColor: Color
    let accentColor: Color
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(DeliveryCategory.allCases, id: \.self) { category in
                    CategoryButtonView(category: category, isSelected: selectedCategory == category, primaryColor: primaryColor, accentColor: accentColor) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryButtonView: View {
    let category: DeliveryCategory
    let isSelected: Bool
    let primaryColor: Color
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: category.iconName)
                    .font(.system(size: 24))
                Text(category.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? accentColor : primaryColor)
            .padding()
            .background(isSelected ? primaryColor : accentColor)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

struct AddressInputView: View {
    @Binding var from: String
    @Binding var to: String
    let primaryColor: Color
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(primaryColor)
                TextField("From", text: $from)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(primaryColor)
                TextField("To", text: $to)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

struct EstimatesView: View {
    @Binding var cost: String
    @Binding var time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Estimated Cost")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(cost)
                    .font(.headline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Estimated Time")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(time)
                    .font(.headline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct OrderItemsView: View {
    @Binding var items: [OrderItem]
    @Binding var showingItemPicker: Bool
    let primaryColor: Color
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Order Items")
                .font(.headline)
            ForEach(items) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("$\(String(format: "%.2f", item.price))")
                }
            }
            Button(action: { showingItemPicker = true }) {
                Text("Add Item")
                    .foregroundColor(accentColor)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(primaryColor)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct PaymentMethodView: View {
    @Binding var selectedMethod: String
    let methods: [String]
    let primaryColor: Color
    
    var body: some View {
        Picker("Payment Method", selection: $selectedMethod) {
            ForEach(methods, id: \.self) { method in
                Text(method)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .accentColor(primaryColor)
    }
}

struct OrderSummaryView: View {
    let from: String
    let to: String
    let cost: String
    let time: String
    let items: [OrderItem]
    let paymentMethod: String
    let onConfirm: () -> Void
    let primaryColor: Color
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Order Summary")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                Text("From: \(from)")
                Text("To: \(to)")
            }
            
            VStack(alignment: .leading) {
                Text("Estimated Cost: \(cost)")
                Text("Estimated Time: \(time)")
            }
            
            VStack(alignment: .leading) {
                Text("Items:")
                ForEach(items) { item in
                    Text("\(item.name) - $\(String(format: "%.2f", item.price))")
                }
            }
            
            Text("Payment Method: \(paymentMethod)")
            
            Button(action: onConfirm) {
                Text("Confirm Order")
                    .foregroundColor(accentColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct MapTrackingView: UIViewRepresentable {
    @Binding var isTracking: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 4.85165, longitude: 31.58247)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        uiView.setRegion(region, animated: true)
        
        if isTracking {
            // Add delivery vehicle annotation and route
            let vehicleAnnotation = MKPointAnnotation()
            vehicleAnnotation.coordinate = CLLocationCoordinate2D(latitude: 4.85, longitude: 31.58)
            vehicleAnnotation.title = "Delivery Vehicle"
            uiView.addAnnotation(vehicleAnnotation)
        }
    }
}

struct ItemPickerView: View {
    @Binding var items: [OrderItem]
    @Environment(\.presentationMode) var presentationMode
    let primaryColor: Color
    let accentColor: Color
    
    let availableItems = [
        OrderItem(name: "Burger", price: 9.99),
        OrderItem(name: "Pizza", price: 12.99),
        OrderItem(name: "Salad", price: 7.99),
        OrderItem(name: "Soda", price: 2.99)
    ]
    
    var body: some View {
        NavigationView {
            List(availableItems) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("$\(String(format: "%.2f", item.price))")
                    Button(action: { addItem(item) }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(primaryColor)
                    }
                }
            }
            .navigationTitle("Add Items")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func addItem(_ item: OrderItem) {
        items.append(item)
    }
}

enum DeliveryCategory: String, CaseIterable {
    case food = "Food"
    case groceries = "Groceries"
    case pharmacy = "Pharmacy"
    case gifts = "Gifts"
    
    var iconName: String {
        switch self {
        case .food: return "fork.knife"
        case .groceries: return "cart.fill"
        case .pharmacy: return "cross.case.fill"
        case .gifts: return "gift.fill"
        }
    }
}

struct OrderItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView()
    }
}
