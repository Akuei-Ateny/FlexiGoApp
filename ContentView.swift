


import SwiftUI

struct ContentView: View {
    @State private var selectedTab = "home"
    @State private var showingPromo = false
    @State private var userLocation = "Current Location"
    @State private var isLoggedIn = false
    @State private var userRole: UserRole = .user  // Add this line
    @State private var searchText = ""
    
    var body: some View {
        Group {
            if !isLoggedIn {
                AuthView(isLoggedIn: $isLoggedIn, userRole: $userRole)
            } else {
                switch userRole {
                case .user:
                    mainTabView
                case .driver:
                    DriveView()
                case .seller:
                    SellerView()
                }
            }
        }
        .accentColor(.black)
        .sheet(isPresented: $showingPromo) {
            PromoView()
        }
    }
    
    var mainTabView: some View {
        TabView(selection: $selectedTab) {
            homeView
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag("home")
            
            ServicesView()
                .tabItem {
                    Label("Services", systemImage: "square.grid.2x2")
                }
                .tag("services")
            
            ActivityView()
                .tabItem {
                    Label("Activity", systemImage: "chart.bar")
                }
                .tag("activity")
            
            AccountView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag("account")
        }
    }
    
    var homeView: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    searchBar
                    locationView
                    quickAccessButtons
                    promoCard
                    recentActivityCard
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
    
    var headerView: some View {
        HStack {
            Image("Image")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            Spacer()
            Button(action: {
                // Add notification action
            }) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for a destination", text: $searchText)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var locationView: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.blue)
            Text(userLocation)
                .font(.subheadline)
            Spacer()
            Button("Change") {
                // Add location change action
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var quickAccessButtons: some View {
        VStack(spacing: 15) {
            NavigationLink(destination: RideView()) {
                QuickAccessButton(title: "Book a Ride", icon: "car.fill", color: .black)
            }
            NavigationLink(destination: DeliveryView()) {
                QuickAccessButton(title: "Place a Delivery", icon: "cube.box.fill", color: .black)
            }
            NavigationLink(destination: RentalView()) {
                QuickAccessButton(title: "Rent a Vehicle", icon: "key.fill", color: .black)
            }
        }
    }
    
    var promoCard: some View {
        Button(action: {
            showingPromo = true
        }) {
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.orange)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("Limited Time Offer!")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Get 20% off your next ride")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    var recentActivityCard: some View {
        VStack(alignment: .leading) {
            Text("Recent Activity")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(0..<2) { _ in
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text("Ride to Konyokonyo")
                            .font(.subheadline)
                        Text("May 5, 2024")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("$15.50")
                        .font(.subheadline)
                }
                .padding(.vertical, 5)
            }
            
            Button("View All") {
                selectedTab = "activity"
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct QuickAccessButton: View {
    var title: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(color)
                .clipShape(Circle())
            
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
struct PromoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Limited Time Offer!")
                .font(.title)
                .fontWeight(.bold)
            
            Image(systemName: "gift.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
                .padding()
            
            Text("Get 20% off your next ride")
                .font(.headline)
            
            Text("Use code: RIDE20")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(10)
                .padding()
            
            Text("Valid until May 31, 2024")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Apply to Next Ride") {
                // Apply promo code logic
                presentationMode.wrappedValue.dismiss()
            }
            
            .padding(.top)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
