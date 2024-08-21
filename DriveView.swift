import SwiftUI

struct DriveView: View {
    @State private var isOnline = false
    @State private var currentRide: Ride?
    @State private var earnings: Double = 0.0
    @State private var showingEarningsDetails = false
    @State private var showingSupportView = false
    @State private var showingProfileView = false
    @State private var showingSettingsView = false
    @State private var recentRides: [Ride] = []
    @State private var currentLocation = "Konyokonyo"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    statusCard
                    currentRideCard
                    earningsCard
                    quickActionsCard
                    recentActivityCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingProfileView) {
                DriverProfileView()
            }
            .sheet(isPresented: $showingSupportView) {
                SupportView()
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
        }
    }
    
    var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("FlexiGo Driver")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Current location: \(currentLocation)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack(spacing: 15) {
                Button(action: { showingSettingsView = true }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.primary)
                }
                Button(action: { showingProfileView = true }) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.primary)
                        .font(.title2)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var statusCard: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: isOnline ? "circle.fill" : "circle")
                    .foregroundColor(isOnline ? .green : .red)
                Text(isOnline ? "You're Online" : "You're Offline")
                    .font(.headline)
                    .foregroundColor(isOnline ? .green : .red)
                Spacer()
                Toggle("", isOn: $isOnline)
                    .labelsHidden()
            }
            
            if isOnline {
                HStack {
                    Label("Active hours: 2h 30m", systemImage: "clock")
                    Spacer()
                    Label("Rides: 5", systemImage: "car.fill")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .animation(.default, value: isOnline)
    }
    
    var currentRideCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Current Ride")
                .font(.headline)
            
            if let ride = currentRide {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text("Pickup: \(ride.pickup)")
                    }
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Dropoff: \(ride.dropoff)")
                    }
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Fare: $\(ride.fare, specifier: "%.2f")")
                    }
                    
                    HStack {
                        Button(action: {
                            // Open navigation to pickup/dropoff
                        }) {
                            Label("Navigate", systemImage: "location.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Button(action: completeRide) {
                            Label("Complete Ride", systemImage: "checkmark.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "car.circle")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    VStack(alignment: .leading) {
                        Text("No active ride")
                            .font(.headline)
                        Text("Waiting for ride requests...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var earningsCard: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Today's Earnings")
                        .font(.headline)
                    Text("$\(earnings, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
                NavigationLink(destination: EarningsDetailView(earnings: earnings)) {
                    Image(systemName: "chevron.right.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            
            HStack {
                EarningsSummaryView(title: "This Week", amount: earnings * 7)
                EarningsSummaryView(title: "This Month", amount: earnings * 30)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var quickActionsCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack {
                QuickActionButton(title: "Support", icon: "questionmark.circle.fill", action: { showingSupportView = true })
                QuickActionButton(title: "Incentives", icon: "star.fill", destination: AnyView(IncentivesView()))
                QuickActionButton(title: "Schedule", icon: "calendar", destination: AnyView(ScheduleView()))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var recentActivityCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.headline)
            
            ForEach(recentRides.prefix(3)) { ride in
                HStack {
                    VStack(alignment: .leading) {
                        Text(ride.pickup)
                            .font(.subheadline)
                        Text(ride.dropoff)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("$\(ride.fare, specifier: "%.2f")")
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 5)
            }
            
            if recentRides.isEmpty {
                Text("No recent rides")
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            NavigationLink("View All Activity", destination: AllActivityView(rides: recentRides))
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func completeRide() {
        if let ride = currentRide {
            earnings += ride.fare
            recentRides.insert(ride, at: 0)
            currentRide = nil
        }
    }
}

struct EarningsSummaryView: View {
    let title: String
    let amount: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("$\(amount, specifier: "%.2f")")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    var action: (() -> Void)? = nil
    var destination: AnyView? = nil
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    quickActionContent
                }
            } else if let destination = destination {
                NavigationLink(destination: destination) {
                    quickActionContent
                }
            }
        }
    }
    
    var quickActionContent: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct Ride: Identifiable {
    let id = UUID()
    let pickup: String
    let dropoff: String
    let fare: Double
}

struct EarningsDetailView: View {
    let earnings: Double
    
    var body: some View {
        List {
            Section(header: Text("Today's Earnings")) {
                Text("Total: $\(earnings, specifier: "%.2f")")
            }
            Section(header: Text("This Week")) {
                Text("Total: $\(earnings * 7, specifier: "%.2f")")
            }
            Section(header: Text("This Month")) {
                Text("Total: $\(earnings * 30, specifier: "%.2f")")
            }
        }
        .navigationTitle("Earnings Details")
    }
}

struct SupportView: View {
    var body: some View {
        List {
            Section(header: Text("Contact Support")) {
                Button("Call Support") {
                    // Logic to call support
                }
                Button("Send Email") {
                    // Logic to compose email
                }
            }
            Section(header: Text("FAQs")) {
                Text("How do I update my vehicle information?")
                Text("What should I do if a rider left an item in my car?")
                // Add more FAQs
            }
        }
        .navigationTitle("Support")
    }
}

struct DriverProfileView: View {
    @State private var name = "Akuie Johnson Ateny"
    @State private var email = "akuei@gmail.com"
    @State private var vehicleInfo = "Toyota Camry, 2024"
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
            }
            Section(header: Text("Vehicle Information")) {
                TextField("Vehicle", text: $vehicleInfo)
            }
            Section {
                Button("Update Profile") {
                    // Logic to update profile
                }
            }
        }
        .navigationTitle("Driver Profile")
    }
}

struct SettingsView: View {
    @State private var notifications = true
    @State private var darkMode = false
    @State private var language = "English"
    
    var body: some View {
        Form {
            Section(header: Text("Preferences")) {
                Toggle("Enable Notifications", isOn: $notifications)
                Toggle("Dark Mode", isOn: $darkMode)
            }
            Section(header: Text("Language")) {
                Picker("Select Language", selection: $language) {
                    Text("English").tag("English")
                    Text("Arabic").tag("Arabic")
                    Text("Swahili").tag("Swahili")
                }
            }
            Section {
                Button("Log Out", role: .destructive) {
                    // Logout logic
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct IncentivesView: View {
    var body: some View {
        Text("Incentives View")
            .navigationTitle("Incentives")
    }
}

struct ScheduleView: View {
    var body: some View {
        Text("Schedule View")
            .navigationTitle("Schedule")
    }
}

struct AllActivityView: View {
    let rides: [Ride]
    
    var body: some View {
        List(rides) { ride in
            VStack(alignment: .leading) {
                Text("\(ride.pickup) to \(ride.dropoff)")
                    .font(.headline)
                Text("Fare: $\(ride.fare, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("All Activity")
    }
}

struct DriveView_Previews: PreviewProvider {
    static var previews: some View {
        DriveView()
    }
}
