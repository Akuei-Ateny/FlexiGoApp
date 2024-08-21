import SwiftUI
import MapKit

struct ActivityView: View {
    @State private var cartItemsCount = 10
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var showingFilter = false
    
    // FlexiGo theme colors
    let primaryColor = Color.black
    let accentColor = Color.white
    let backgroundColor = Color(UIColor.systemBackground)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchAndFilterBar
                
                TabView(selection: $selectedTab) {
                    RidesView()
                        .tabItem {
                            Image(systemName: "car.fill")
                            Text("Rides")
                        }
                        .tag(0)
                    
                    DeliveriesView()
                        .tabItem {
                            Image(systemName: "shippingbox.fill")
                            Text("Deliveries")
                        }
                        .tag(1)
                }
                .accentColor(primaryColor)
                
                RecommendationsView()
            }
            .background(backgroundColor)
            .navigationBarTitle("Activity", displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                NotificationButton()
                CartButton(itemsCount: $cartItemsCount)
            })
        }
        .accentColor(primaryColor)
    }
    
    var searchAndFilterBar: some View {
        HStack {
            SearchBar(text: $searchText)
            Button(action: { showingFilter = true }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(primaryColor)
            }
            .sheet(isPresented: $showingFilter) {
                FilterView()
            }
        }
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search activities", text: $text)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct NotificationButton: View {
    var body: some View {
        Button(action: {
            // Handle notification action
        }) {
            Image(systemName: "bell.fill")
                .foregroundColor(.primary)
        }
    }
}

struct CartButton: View {
    @Binding var itemsCount: Int
    
    var body: some View {
        NavigationLink(destination: CartView()) {
            ZStack {
                Image(systemName: "cart.fill")
                    .foregroundColor(.primary)
                if itemsCount > 0 {
                    Text("\(itemsCount)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
        }
    }
}

struct RidesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                UpcomingRideCard()
                PastRidesSection()
            }
            .padding()
        }
    }
}

struct DeliveriesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PendingDeliveriesSection()
                PastDeliveriesSection()
            }
            .padding()
        }
    }
}

struct UpcomingRideCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Upcoming Ride")
                .font(.headline)
            
            MapView()
                .frame(height: 150)
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("285 Broad St")
                        .font(.subheadline)
                    Text("Jul 22, 2024 - 3:15 PM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                NavigationLink(destination: RideDetailsView()) {
                    Text("View Details")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

struct PastRidesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Past Rides")
                .font(.headline)
            
            ForEach(0..<3) { _ in
                PastRideCard()
            }
            
            NavigationLink(destination: PastRidesView()) {
                Text("View All Past Rides")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct PastRideCard: View {
    var body: some View {
        HStack {
            Image(systemName: "car.fill")
                .foregroundColor(.primary)
                .frame(width: 50, height: 50)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("Konyokonyo Ride")
                    .font(.subheadline)
                Text("Jul 20, 2024 - 2:30 PM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("$15.50")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct PendingDeliveriesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Pending Deliveries")
                .font(.headline)
            
            ForEach(0..<2) { _ in
                PendingDeliveryCard()
            }
            
            NavigationLink(destination: PendingDeliveriesView()) {
                Text("View All Pending Deliveries")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct PendingDeliveryCard: View {
    var body: some View {
        HStack {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(.primary)
                .frame(width: 50, height: 50)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("Package #1234")
                    .font(.subheadline)
                Text("Estimated delivery: Jul 25, 2024")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink(destination: DeliveryTrackingView()) {
                Text("Track")
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.black)
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct PastDeliveriesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Past Deliveries")
                .font(.headline)
            
            ForEach(0..<3) { _ in
                PastDeliveryCard()
            }
            
            NavigationLink(destination: PastDeliveriesView()) {
                Text("View All Past Deliveries")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct PastDeliveryCard: View {
    var body: some View {
        HStack {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(.primary)
                .frame(width: 50, height: 50)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("Package #5678")
                    .font(.subheadline)
                Text("Delivered: Jul 18, 2024")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink(destination: DeliveryDetailsView()) {
                Text("Details")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct RecommendationsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recommended for You")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        RecommendationCard()
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct RecommendationCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "gift.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.primary)
            
            Text("Special Offer")
                .font(.subheadline)
            Text("15% off your next ride")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct FilterView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedActivityType = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date Range")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Activity Type")) {
                    Picker("Activity Type", selection: $selectedActivityType) {
                        Text("All").tag(0)
                        Text("Rides").tag(1)
                        Text("Deliveries").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button("Apply Filters") {
                        // Apply filters logic
                    }
                }
            }
            .navigationBarTitle("Filter Activities", displayMode: .inline)
        }
    }
}

// Placeholder views for navigation destinations
struct CartView: View { var body: some View { Text("Cart Details") } }
struct PastRidesView: View { var body: some View { Text("Past Rides Details") } }
struct PendingDeliveriesView: View { var body: some View { Text("Pending Deliveries Details") } }
struct PastDeliveriesView: View { var body: some View { Text("Past Deliveries Details") } }
struct DeliveryDetailsView: View { var body: some View { Text("Delivery Details") } }
struct RideDetailsView: View { var body: some View { Text("Ride Details") } }
struct DeliveryTrackingView: View { var body: some View { Text("Delivery Tracking") } }

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
