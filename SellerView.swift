//
//  SellerView.swift
//  FlexiGo
//
//  Created by Akuei Johnson Ateny on 8/18/24.
//

import Foundation
import SwiftUI


struct SellerView: View {
    @State private var selectedTab = 0
    @State private var showingProfile = false
    @State private var showingAddProduct = false
    @State private var products: [Product] = []
    @State private var sellerProfile = SellerProfile(name: "Akuei", email: "akuei@flexigo.com", phone: "+1 234 567 8900", businessName: "John's Store", businessType: "Retail", address: "123 Main St, City, Country")
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                DashboardView(sellerProfile: $sellerProfile)
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Dashboard")
                    }
                    .tag(0)
                
                ProductsView(products: $products, showingAddProduct: $showingAddProduct)
                    .tabItem {
                        Image(systemName: "cube")
                        Text("Products")
                    }
                    .tag(1)
                
                OrdersView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Orders")
                    }
                    .tag(2)
                
                AnalyticsView()
                    .tabItem {
                        Image(systemName: "chart.pie")
                        Text("Analytics")
                    }
                    .tag(3)
            }
            .accentColor(.blue)
            .navigationBarTitle(getTitle())
            .navigationBarItems(trailing: profileButton)
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView(profile: $sellerProfile)
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(products: $products)
        }
    }
    
    var profileButton: some View {
        Button(action: { showingProfile = true }) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
        }
    }
    
    func getTitle() -> String {
        switch selectedTab {
        case 0: return "Dashboard"
        case 1: return "Products"
        case 2: return "Orders"
        case 3: return "Analytics"
        default: return "FlexiGo Seller"
        }
    }
}


struct DashboardView: View {
    @Binding var sellerProfile: SellerProfile
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                greetingCard
                statisticsCards
                salesChart
                recentReviews
            }
            .padding()
        }
        .refreshable {
            // Add refresh functionality here
            print("Refreshing dashboard...")
        }
    }
    
    var greetingCard: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hi, \(sellerProfile.name)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("You have 3 pending orders")
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "bell.badge")
                .foregroundColor(.blue)
                .font(.title2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var statisticsCards: some View {
        HStack {
            StatCard(title: "Products Sold", value: "3,667", icon: "cube.fill", color: .blue)
            StatCard(title: "Earnings", value: "$28,445", icon: "dollarsign.circle.fill", color: .green)
        }
    }
    
    var salesChart: some View {
        VStack(alignment: .leading) {
            Text("Sales Overview")
                .font(.headline)
            // Placeholder for chart
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 200)
                .overlay(
                    Text("Sales Chart Placeholder")
                        .foregroundColor(.blue)
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var recentReviews: some View {
        VStack(alignment: .leading) {
            Text("Recent Reviews")
                .font(.headline)
            ForEach(0..<3) { _ in
                ReviewRow()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


struct ReviewRow: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text("Chol Ateny")
                    .font(.headline)
                Text("Great product, fast delivery!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack {
                Text("⭐️⭐️⭐️⭐️⭐️")
                Text("2d ago")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct SellerProfile: Identifiable {
    let id = UUID()
    var name: String
    var email: String
    var phone: String
    var businessName: String
    var businessType: String
    var address: String
}


struct ProfileView: View {
    @Binding var profile: SellerProfile
    @State private var editMode: EditMode = .inactive
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    if editMode == .inactive {
                        Text("Name: \(profile.name)")
                        Text("Email: \(profile.email)")
                        Text("Phone: \(profile.phone)")
                    } else {
                        TextField("Name", text: $profile.name)
                        TextField("Email", text: $profile.email)
                        TextField("Phone", text: $profile.phone)
                    }
                }
                
                Section(header: Text("Business Information")) {
                    if editMode == .inactive {
                        Text("Business Name: \(profile.businessName)")
                        Text("Business Type: \(profile.businessType)")
                        Text("Address: \(profile.address)")
                    } else {
                        TextField("Business Name", text: $profile.businessName)
                        TextField("Business Type", text: $profile.businessType)
                        TextField("Address", text: $profile.address)
                    }
                }
                
                Section {
                    Button("Logout") {
                        // Action to logout
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Profile")
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
    }
}


struct ProductsView: View {
    @Binding var products: [Product]
    @Binding var showingAddProduct: Bool
    @State private var showingProductDetails = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        List {
            ForEach(products) { product in
                ProductRow(product: product)
                    .onTapGesture {
                        selectedProduct = product
                        showingProductDetails = true
                    }
            }
            .onDelete(perform: deleteProduct)
            
            Button(action: { showingAddProduct = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Product")
                }
            }
        }
        .sheet(isPresented: $showingProductDetails) {
            if let product = selectedProduct {
                ProductDetailView(product: binding(for: product))
            }
        }
    }
    
    func deleteProduct(at offsets: IndexSet) {
        products.remove(atOffsets: offsets)
    }
    
    func binding(for product: Product) -> Binding<Product> {
        guard let productIndex = products.firstIndex(where: { $0.id == product.id }) else {
            fatalError("Can't find product in array")
        }
        return $products[productIndex]
    }
}


struct Product: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var price: Double
    var image: UIImage
    var viewCount: Int
    var inStock: Bool
}


struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            Image(uiImage: product.image)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("$\(String(format: "%.2f", product.price))")
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            VStack {
                Text("\(product.viewCount)")
                Text("Views")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Image(systemName: product.inStock ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(product.inStock ? .green : .red)
        }
    }
}


struct ProductDetailView: View {
    @Binding var product: Product
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Name", text: $product.name)
                    TextField("Description", text: $product.description)
                    TextField("Price", value: $product.price, formatter: NumberFormatter())
                    Toggle("In Stock", isOn: $product.inStock)
                }
                
                Section(header: Text("Product Image")) {
                    Image(uiImage: product.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    Button("Change Image") {
                        // Implement image picker functionality
                    }
                }
            }
            .navigationBarTitle("Edit Product")
            .navigationBarItems(trailing: Button("Save") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


struct AddProductView: View {
    @Binding var products: [Product]
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var image: UIImage?
    @State private var inStock = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Product Name", text: $name)
                TextField("Description", text: $description)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                Toggle("In Stock", isOn: $inStock)
                
                Button(action: selectImage) {
                    Text("Select Product Image")
                }
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
            }
            .navigationBarTitle("Add New Product")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveProduct()
            })
        }
    }
    
    func selectImage() {
        // Implement image selection functionality
        // For this example, we'll use a placeholder image
        image = UIImage(systemName: "photo")
    }
    
    func saveProduct() {
        guard let price = Double(price), let image = image else { return }
        let newProduct = Product(name: name, description: description, price: price, image: image, viewCount: 0, inStock: inStock)
        products.append(newProduct)
        presentationMode.wrappedValue.dismiss()
    }
}


struct OrdersView: View {
    var body: some View {
        List(0..<10) { _ in
            OrderRow()
        }
    }
}


struct OrderRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Order #12345")
                    .font(.headline)
                Text("John Doe")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("$99.99")
                    .font(.headline)
                Text("Processing")
                    .font(.caption)
                    .padding(5)
                    .background(Color.yellow)
                    .cornerRadius(5)
            }
        }
    }
}


struct AnalyticsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                analyticsChart
                topProducts
                customerSatisfaction
            }
            .padding()
        }
    }
    
    var analyticsChart: some View {
        VStack(alignment: .leading) {
            Text("Sales Analytics")
                .font(.headline)
            // Placeholder for chart
            Rectangle()
                .fill(Color.purple.opacity(0.1))
                .frame(height: 200)
                .overlay(
                    Text("Analytics Chart Placeholder")
                        .foregroundColor(.purple)
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
var topProducts: some View {
        VStack(alignment: .leading) {
            Text("Top Products")
                .font(.headline)
            ForEach(0..<3) { index in
                HStack {
                    Text("\(index + 1).")
                    Text("Product Name")
                    Spacer()
                    Text("$XXX.XX")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    var customerSatisfaction: some View {
        VStack(alignment: .leading) {
            Text("Customer Satisfaction")
                .font(.headline)
            HStack {
                Text("4.8")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("⭐️⭐️⭐️⭐️⭐️")
                    Text("Based on 256 reviews")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


struct SellerView_Previews: PreviewProvider {
    static var previews: some View {
        SellerView()
    }
}
