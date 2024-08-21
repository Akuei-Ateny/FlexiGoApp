import SwiftUI

struct RentalView: View {
    @State private var selectedVehicleType: VehicleType = .car
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(24 * 60 * 60)
    @State private var selectedLocation = ""
    @State private var showingVehicleDetails = false
    @State private var selectedVehicle: Vehicle?
    @State private var showingConfirmation = false
    @State private var showingCancellationPolicy = false
    @State private var userComment = ""
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    
    let vehicleTypes: [VehicleType] = [.car, .motorcycle, .bicycle, .scooter, .rickshaw]
    
    // Updated color scheme
    let primaryColor = Color.black
    let secondaryColor = Color.gray
    let accentColor = Color.white
    let backgroundColor = Color(UIColor.systemBackground)
    let groupedBackgroundColor = Color(UIColor.systemGroupedBackground)
    
    var body: some View {
        NavigationView {
            ZStack {
                groupedBackgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        vehicleTypePicker
                        dateSelectionView
                        locationSelectionView
                        availableVehiclesView
                    }
                    .padding()
                }
            }
            .navigationTitle("Rent a Vehicle")
            .sheet(isPresented: $showingVehicleDetails) {
                if let vehicle = selectedVehicle {
                    VehicleDetailView(
                        vehicle: vehicle,
                        startDate: startDate,
                        endDate: endDate,
                        onRent: {
                            showingVehicleDetails = false
                            showingConfirmation = true
                        },
                        userComment: $userComment,
                        selectedPaymentMethod: $selectedPaymentMethod
                    )
                }
            }
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text("Booking Confirmed"),
                    message: Text("Your vehicle rental has been successfully booked. Enjoy your ride!"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showingCancellationPolicy) {
                CancellationPolicyView()
            }
        }
        .accentColor(primaryColor)
    }
    
    var vehicleTypePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Vehicle Type")
                .font(.headline)
                .foregroundColor(secondaryColor)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vehicleTypes, id: \.self) { type in
                        VehicleTypeButton(type: type, isSelected: selectedVehicleType == type) {
                            selectedVehicleType = type
                        }
                    }
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var dateSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rental Period")
                .font(.headline)
                .foregroundColor(secondaryColor)
            
            VStack(spacing: 12) {
                DatePicker("Start Date", selection: $startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                
                DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var locationSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pickup Location")
                .font(.headline)
                .foregroundColor(secondaryColor)
            
            TextField("Enter pickup location", text: $selectedLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                // TODO: Implement location selection using maps
            }) {
                HStack {
                    Image(systemName: "map")
                    Text("Choose on Map")
                }
                .foregroundColor(accentColor)
                .padding()
                .background(primaryColor)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var availableVehiclesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Vehicles")
                .font(.headline)
                .foregroundColor(secondaryColor)
            
            ForEach(mockVehicles.filter { $0.type == selectedVehicleType }, id: \.id) { vehicle in
                VehicleRowView(vehicle: vehicle, primaryColor: primaryColor)
                    .onTapGesture {
                        selectedVehicle = vehicle
                        showingVehicleDetails = true
                    }
                    .transition(.scale)
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct VehicleTypeButton: View {
    let type: VehicleType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: type.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .black)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? Color.black : Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                
                Text(type.displayName)
                    .font(.caption)
                    .foregroundColor(isSelected ? .black : .gray)
            }
        }
    }
}

struct VehicleRowView: View {
    let vehicle: Vehicle
    let primaryColor: Color
    @State private var isFavorite = false
    
    var body: some View {
        HStack {
            Image(systemName: vehicle.type.iconName)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(primaryColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.name)
                    .font(.headline)
                Text(vehicle.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < vehicle.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    Text("(\(vehicle.numberOfReviews))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(vehicle.pricePerHour, specifier: "%.2f")/hr")
                    .font(.headline)
                    .foregroundColor(primaryColor)
                
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct VehicleDetailView: View {
    let vehicle: Vehicle
    let startDate: Date
    let endDate: Date
    let onRent: () -> Void
    @Binding var userComment: String
    @Binding var selectedPaymentMethod: PaymentMethod
    
    @State private var selectedInsurance: InsuranceOption = .basic
    @State private var showingCancellationPolicy = false
    
    var rentalDuration: Double {
        endDate.timeIntervalSince(startDate) / 3600 // Convert to hours
    }
    
    var totalCost: Double {
        let baseCost = vehicle.pricePerHour * rentalDuration
        let insuranceCost = selectedInsurance.cost * rentalDuration
        return baseCost + insuranceCost
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                vehicleInfoSection
                rentalDetailsSection
                insuranceSelectionSection
                paymentMethodSection
                commentSection
                costBreakdownSection
                
                HStack {
                    Button(action: onRent) {
                        Text("Confirm Rental")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { showingCancellationPolicy = true }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle(vehicle.name)
        .sheet(isPresented: $showingCancellationPolicy) {
            CancellationPolicyView()
        }
    }
    
    var vehicleInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: vehicle.type.iconName)
                .font(.system(size: 60))
                .foregroundColor(.black)
            
            Text(vehicle.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(vehicle.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: index < vehicle.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                Text("(\(vehicle.numberOfReviews) reviews)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var rentalDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rental Details")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(startDate, style: .date)
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("End Date")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(endDate, style: .date)
                        .font(.headline)
                }
            }
            
            Text("Duration: \(String(format: "%.1f", rentalDuration)) hours")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    var insuranceSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insurance Options")
                .font(.headline)
            
            Picker("Select Insurance", selection: $selectedInsurance) {
                ForEach(InsuranceOption.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text(selectedInsurance.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.headline)
            
            Picker("Select Payment Method", selection: $selectedPaymentMethod) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Text(method.rawValue).tag(method)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var commentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Comments")
                .font(.headline)
            
            TextEditor(text: $userComment)
                .frame(height: 100)
                .padding(4)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
        }
    }
    
    var costBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cost Breakdown")
                .font(.headline)
            
            HStack {
                Text("Vehicle Rental")
                Spacer()
                Text("$\(String(format: "%.2f", vehicle.pricePerHour * rentalDuration))")
            }
            
            HStack {
                Text("Insurance")
                Spacer()
                Text("$\(String(format: "%.2f", selectedInsurance.cost * rentalDuration))")
            }
            
            Divider()
            
            HStack {
                Text("Total Cost")
                    .fontWeight(.bold)
                Spacer()
                Text("$\(String(format: "%.2f", totalCost))")
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

import SwiftUI

struct CancellationPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Cancellation Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Group {
                    policySection(
                        title: "Free Cancellation",
                        content: "Cancel up to 24 hours before your rental starts for a full refund."
                    )
                    
                    policySection(
                        title: "Late Cancellation",
                        content: "Cancellations made less than 24 hours before the rental start time will be charged 50% of the total rental cost."
                    )
                    
                    policySection(
                        title: "No-Show",
                        content: "If you don't show up for your rental, you will be charged the full rental cost."
                    )
                    
                    policySection(
                        title: "Early Return",
                        content: "If you return the vehicle early, you will be charged for the entire reserved time."
                    )
                    
                    policySection(
                        title: "Extensions",
                        content: "If you need to extend your rental, please contact us as soon as possible. Additional charges may apply."
                    )
                    
                    policySection(
                        title: "Modifications",
                        content: "You can modify your reservation up to 24 hours before the rental start time at no additional cost. Changes made within 24 hours of the rental start time may incur a fee."
                    )
                    
                    policySection(
                        title: "Refunds",
                        content: "Refunds for eligible cancellations will be processed within 5-10 business days and will be issued to the original payment method."
                    )
                }
                
                Text("By renting a vehicle, you agree to these cancellation terms. FlexiGo reserves the right to modify these terms at any time. It is your responsibility to check for the most current policy before making a reservation.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                Text("For any questions or special circumstances regarding cancellations, please contact our customer support team.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Cancellation Policy")
    }
    
    func policySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

enum VehicleType: String, CaseIterable {
    case car, motorcycle, bicycle, scooter, rickshaw
    
    var displayName: String {
        switch self {
        case .car: return "Car"
        case .motorcycle: return "Motorcycle"
        case .bicycle: return "Bicycle"
        case .scooter: return "Scooter"
        case .rickshaw: return "Rickshaw"
        }
    }
    
    var iconName: String {
        switch self {
        case .car: return "car.fill"
        case .motorcycle: return "bicycle"
        case .bicycle: return "bicycle"
        case .scooter: return "scooter"
        case .rickshaw: return "figure.walk"  // Using a placeholder icon as there's no specific rickshaw icon
        }
    }
}

struct Vehicle: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let type: VehicleType
    let pricePerHour: Double
    let rating: Int
    let numberOfReviews: Int
}

enum InsuranceOption: String, CaseIterable {
    case basic, standard, premium
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .standard: return "Standard"
        case .premium: return "Premium"
        }
    }
    
    var cost: Double {
        switch self {
        case .basic: return 2.0
        case .standard: return 5.0
        case .premium: return 10.0
        }
    }
    
    var description: String {
        switch self {
        case .basic: return "Basic coverage for minor damages"
        case .standard: return "Standard coverage for most common incidents"
        case .premium: return "Comprehensive coverage for all types of damages"
        }
    }
}

enum PaymentMethod: String, CaseIterable {
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case paypal = "PayPal"
    case applePay = "Apple Pay"
}

let mockVehicles = [
    Vehicle(name: "Economy Car", description: "Fuel-efficient compact car", type: .car, pricePerHour: 10.0, rating: 4, numberOfReviews: 120),
    Vehicle(name: "Luxury Sedan", description: "High-end comfortable ride", type: .car, pricePerHour: 25.0, rating: 5, numberOfReviews: 85),
    Vehicle(name: "Sport Motorcycle", description: "Powerful and agile bike", type: .motorcycle, pricePerHour: 15.0, rating: 4, numberOfReviews: 67),
    Vehicle(name: "City Bicycle", description: "Perfect for urban exploration", type: .bicycle, pricePerHour: 5.0, rating: 4, numberOfReviews: 230),
    Vehicle(name: "Electric Scooter", description: "Eco-friendly urban commuter", type: .scooter, pricePerHour: 7.0, rating: 3, numberOfReviews: 95),
    Vehicle(name: "Traditional Rickshaw", description: "Authentic local experience", type: .rickshaw, pricePerHour: 8.0, rating: 4, numberOfReviews: 42)
]

struct RentalView_Previews: PreviewProvider {
    static var previews: some View {
        RentalView()
    }
}


