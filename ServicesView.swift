import SwiftUI

struct ServicesView: View {
    @State private var selectedCategory: ServiceCategory = .all
    @State private var searchText = ""
    @State private var showingFavorites = false
    @State private var userRating: Int? = nil
    @State private var ratingComment: String = ""
    @State private var showThanks: Bool = false
    @State private var showingPromoModal = false
    @State private var currentPromo: Service?
    @State private var showingScheduleView = false
    @State private var selectedService: Service?
    @State private var refreshID = UUID()
    @State private var showingSortOptions = false
    @State private var sortOption: SortOption = .nameAsc

    // FlexiGo theme colors
    let primaryColor = Color.black
    let accentColor = Color.white
    let backgroundColor = Color(UIColor.systemBackground)

    let services: [Service] = [
        Service(id: 1, name: "Ride", icon: "car.fill", category: .transport),
        Service(id: 2, name: "Reserve", icon: "timer", category: .transport),
        Service(id: 3, name: "Rental Cars", icon: "car.2.fill", category: .transport),
        Service(id: 4, name: "Grocery", icon: "cart.fill", category: .shopping),
        Service(id: 5, name: "Food", icon: "bag.fill", category: .food),
        Service(id: 6, name: "Packages", icon: "gift.fill", category: .shopping),
        Service(id: 7, name: "Boda Boda", icon: "bicycle", category: .transport),
        Service(id: 8, name: "Pharmacy", icon: "cross.case.fill", category: .shopping),
        Service(id: 9, name: "Flowers", icon: "leaf.fill", category: .shopping)
    ]

    var filteredServices: [Service] {
        services.filter { service in
            (selectedCategory == .all || service.category == selectedCategory) &&
            (searchText.isEmpty || service.name.lowercased().contains(searchText.lowercased())) &&
            (!showingFavorites || service.isFavorite)
        }.sorted { (s1, s2) -> Bool in
            switch sortOption {
            case .nameAsc:
                return s1.name < s2.name
            case .nameDesc:
                return s1.name > s2.name
            case .categoryAsc:
                return s1.category.rawValue < s2.category.rawValue
            case .categoryDesc:
                return s1.category.rawValue > s2.category.rawValue
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    searchAndSortBar
                    categoryPicker
                    dailyDealSection
                    servicesGrid
                    personalizedRecommendations
                    featuredPartnersCarousel
                    rateOurServices
                }
            }
            .background(backgroundColor)
            .navigationTitle("Our Services")
            .navigationBarItems(trailing: HStack {
                favoriteToggle
                refreshButton
            })
            .refreshable {
                // Simulate a refresh
                refreshID = UUID()
            }
        }
        .accentColor(primaryColor)
        .sheet(isPresented: $showingPromoModal) {
            if let promo = currentPromo {
                PromoDetailView(service: promo)
            }
        }
        .sheet(isPresented: $showingScheduleView) {
            if let service = selectedService {
                ScheduleServiceView(service: service)
            }
        }
    }

    var searchAndSortBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search services", text: $searchText)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            Button(action: { showingSortOptions = true }) {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(primaryColor)
            }
            .actionSheet(isPresented: $showingSortOptions) {
                ActionSheet(title: Text("Sort Services"), buttons: [
                    .default(Text("Name (A-Z)")) { sortOption = .nameAsc },
                    .default(Text("Name (Z-A)")) { sortOption = .nameDesc },
                    .default(Text("Category (A-Z)")) { sortOption = .categoryAsc },
                    .default(Text("Category (Z-A)")) { sortOption = .categoryDesc },
                    .cancel()
                ])
            }
        }
        .padding(.horizontal)
    }

    var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(ServiceCategory.allCases, id: \.self) { category in
                    CategoryButton(category: category, selectedCategory: $selectedCategory, primaryColor: primaryColor, accentColor: accentColor)
                }
            }
            .padding(.horizontal)
        }
    }

    var dailyDealSection: some View {
        VStack(alignment: .leading) {
            Text("Today's Special Deal")
                .font(.headline)
                .padding(.horizontal)
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [primaryColor, .gray]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 100)
                    .cornerRadius(15)
                
                HStack {
                    Image(systemName: "tag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(accentColor)
                    
                    VStack(alignment: .leading) {
                        Text("50% OFF")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("On all rides today!")
                    }
                    .foregroundColor(accentColor)
                    
                    Spacer()
                    
                    Button("Claim") {
                        // Implement claim functionality
                    }
                    .padding(8)
                    .background(accentColor)
                    .foregroundColor(primaryColor)
                    .cornerRadius(8)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }

    var servicesGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
            ForEach(filteredServices) { service in
                ServiceButton(service: service, primaryColor: primaryColor, accentColor: accentColor)
                    .onTapGesture {
                        if service.isPromo {
                            currentPromo = service
                            showingPromoModal = true
                        } else {
                            selectedService = service
                            showingScheduleView = true
                        }
                    }
            }
        }
        .padding()
        .id(refreshID) // This will force a re-render when refreshID changes
    }

    var personalizedRecommendations: some View {
        VStack(alignment: .leading) {
            Text("Recommended for You")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(services.shuffled().prefix(3)) { service in
                        RecommendationView(service: service, primaryColor: primaryColor, accentColor: accentColor)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    var featuredPartnersCarousel: some View {
        VStack(alignment: .leading) {
            Text("Featured Partners")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { index in
                        AdvertisementView(index: index, primaryColor: primaryColor)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    var rateOurServices: some View {
        RateOurServices(rating: $userRating, comment: $ratingComment, showThanks: $showThanks, primaryColor: primaryColor, accentColor: accentColor)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .padding()
    }

    var favoriteToggle: some View {
        Button(action: {
            showingFavorites.toggle()
        }) {
            Image(systemName: showingFavorites ? "heart.fill" : "heart")
                .foregroundColor(primaryColor)
        }
    }

    var refreshButton: some View {
        Button(action: {
            refreshID = UUID()
        }) {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(primaryColor)
        }
    }
}

struct Service: Identifiable {
    let id: Int
    let name: String
    let icon: String
    let category: ServiceCategory
    var isPromo: Bool = false
    var isFavorite: Bool = false
}

enum ServiceCategory: String, CaseIterable {
    case all = "All"
    case transport = "Transport"
    case shopping = "Shopping"
    case food = "Food"
}

enum SortOption {
    case nameAsc, nameDesc, categoryAsc, categoryDesc
}

struct CategoryButton: View {
    let category: ServiceCategory
    @Binding var selectedCategory: ServiceCategory
    let primaryColor: Color
    let accentColor: Color

    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            Text(category.rawValue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedCategory == category ? primaryColor : Color(.systemGray5))
                .foregroundColor(selectedCategory == category ? accentColor : .primary)
                .cornerRadius(20)
        }
    }
}

struct ServiceButton: View {
    let service: Service
    let primaryColor: Color
    let accentColor: Color

    var body: some View {
        VStack {
            Image(systemName: service.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding()
                .background(service.isPromo ? primaryColor : Color(.systemGray5))
                .foregroundColor(service.isPromo ? accentColor : .primary)
                .clipShape(Circle())
            Text(service.name)
                .font(.caption)
        }
        .frame(width: 100, height: 100)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .overlay(
            service.isFavorite ?
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .padding(5)
                .background(Color.white.opacity(0.6))
                .clipShape(Circle())
                .offset(x: 35, y: -35)
            : nil
        )
    }
}

struct RecommendationView: View {
    let service: Service
    let primaryColor: Color
    let accentColor: Color
    
    var body: some View {
        VStack {
            Image(systemName: service.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding()
                .background(primaryColor)
                .foregroundColor(accentColor)
                .clipShape(Circle())
            Text(service.name)
                .font(.caption)
            Text("Best choice!")
                .font(.caption2)
                .foregroundColor(.green)
        }
        .frame(width: 100, height: 120)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct AdvertisementView: View {
    let index: Int
    let primaryColor: Color
    
    var body: some View {
        ZStack {
            primaryColor.opacity(0.3 * Double(index + 1))
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                Text("Partner \(index + 1)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 120, height: 80)
        .cornerRadius(10)
    }
}

struct RateOurServices: View {
    @Binding var rating: Int?
    @Binding var comment: String
    @Binding var showThanks: Bool
    let primaryColor: Color
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Rate Our Services")
                .font(.headline)
            
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: rating != nil && star <= rating! ? "star.fill" : "star")
                        .foregroundColor(rating != nil && star <= rating! ? primaryColor : .gray)
                        .onTapGesture { rating = star }
                }
            }
            
            if rating != nil {
                TextField("Leave a comment...", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Submit") {
                    showThanks = true
                    // Here you would typically send the rating and comment to your backend
                }
                .foregroundColor(accentColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(primaryColor)
                .cornerRadius(8)
            }
            
            if showThanks {
                Text("Thank you for your feedback!")
                    .foregroundColor(.green)
            }
        }
    }
}

struct PromoDetailView: View {
    let service: Service
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: service.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                Text(service.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Special Promo!")
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text("Get 20% off on your next \(service.name.lowercased()) service!")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Claim Offer") {
                    // Here you would implement the logic to claim the offer
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }
            .padding()
            .navigationBarTitle("Promo Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ScheduleServiceView: View {
    let service: Service
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Service Details")) {
                    Text(service.name)
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }

                Section {
                    Button("Schedule Service") {
                        // Implement scheduling logic
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Schedule Service")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView()
    }
}
