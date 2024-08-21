import SwiftUI
import MapKit

struct RideView: View {
    @State private var origin: String = ""
    @State private var destination: String = ""
    @State private var selectedRideType = "Standard"
    let rideTypes = ["Standard", "Premium", "Luxury"]
    @State private var estimatedCost = "Calculating..."
    @State private var estimatedTime = "Calculating..."
    @State private var showingRideOptions = false
    @State private var selectedPaymentMethod = "Cash"
    let paymentMethods = ["Cash", "Mobile Money", "FGP"]
    @State private var showingPromoCodeInput = false
    @State private var promoCode = ""
    
    // FlexiGo theme colors
    let primaryColor = Color.black
    let accentColor = Color.white
    let backgroundColor = Color(UIColor.systemBackground)
    
    var body: some View {
        ZStack {
            MapView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                headerView
                
                Spacer()
                
                rideDetailsView
            }
            .padding()
        }
        .onAppear {
            calculateEstimates()
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "car.fill")
                .foregroundColor(primaryColor)
            Text("FlexiGo")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                // Add action for saved locations or settings
            }) {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(primaryColor)
            }
        }
        .padding()
        .background(backgroundColor.opacity(0.9))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var rideDetailsView: some View {
        VStack(spacing: 20) {
            LocationInputView(title: "From", text: $origin)
            LocationInputView(title: "To", text: $destination)
            
            Button(action: {
                withAnimation {
                    showingRideOptions.toggle()
                }
            }) {
                Text(showingRideOptions ? "Hide Options" : "Show Ride Options")
                    .foregroundColor(accentColor)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(10)
            }
            
            if showingRideOptions {
                rideOptionsView
            }
        }
        .padding()
        .background(backgroundColor.opacity(0.9))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    var rideOptionsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Ride Class")
                .font(.headline)
            
            Picker("", selection: $selectedRideType) {
                ForEach(rideTypes, id: \.self) { type in
                    Text(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Estimated Cost")
                        .font(.subheadline)
                    Text(estimatedCost)
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Estimated Time")
                        .font(.subheadline)
                    Text(estimatedTime)
                        .font(.headline)
                }
            }
            
            Picker("Payment Method", selection: $selectedPaymentMethod) {
                ForEach(paymentMethods, id: \.self) { method in
                    Text(method)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            if !showingPromoCodeInput {
                Button(action: { showingPromoCodeInput = true }) {
                    Text("Add Promo Code")
                        .foregroundColor(primaryColor)
                }
            } else {
                HStack {
                    TextField("Enter Promo Code", text: $promoCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: applyPromoCode) {
                        Text("Apply")
                            .foregroundColor(accentColor)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(primaryColor)
                            .cornerRadius(8)
                    }
                }
            }
            
            Button(action: confirmRide) {
                Text("Confirm Ride")
                    .foregroundColor(accentColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(10)
            }
        }
    }
    
    func calculateEstimates() {
        // Simulate a delay and then set estimated cost and time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.estimatedCost = "$23.50"
            self.estimatedTime = "15 mins"
        }
    }
    
    func confirmRide() {
        // Handle ride confirmation logic
        print("Ride confirmed with \(selectedRideType) class, paying by \(selectedPaymentMethod)")
    }
    
    func applyPromoCode() {
        // Apply promo code logic
        print("Applying promo code: \(promoCode)")
        showingPromoCodeInput = false
        promoCode = ""
    }
}

struct LocationInputView: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: title == "From" ? "location.fill" : "mappin.and.ellipse")
                .foregroundColor(.gray)
            TextField(title, text: $text)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 4.85165, longitude: 31.58247)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        uiView.setRegion(region, animated: true)
    }
}

struct RideView_Previews: PreviewProvider {
    static var previews: some View {
        RideView()
    }
}
