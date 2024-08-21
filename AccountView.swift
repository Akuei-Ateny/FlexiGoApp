//
//  AccountView.swift
//  FlexiGo
//
//  Created by Akuei Johnson Ateny on 8/13/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @Binding var isLoggedIn: Bool
    @State private var user = User(name: "Akuei Johnson Ateny", email: "akuei@flexigo.com", phone: "+1 609 255 6133")
    @State private var isEditingProfile = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var notificationsEnabled = true
    @State private var selectedCurrency = "SSP"
    @State private var selectedLanguage = "English"
    @State private var showingMessages = false
    @State private var showingFlexiGoAccount = false
    @State private var showingLegal = false

    var body: some View {
        NavigationView {
            List {
                profileSection
                settingsSection
                messagesSection
                accountManagementSection
                legalSection
                logoutButton
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Account")
            .sheet(isPresented: $isEditingProfile) {
                ProfileEditView(user: $user)
            }
        }
    }

    var profileSection: some View {
        Section(header: Text("Profile")) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: { isEditingProfile = true }) {
                    Text("Edit")
                }
            }
            .padding(.vertical, 8)
        }
    }

    var settingsSection: some View {
        Section(header: Text("Settings")) {
            Toggle("Dark Mode", isOn: $isDarkMode)
            Toggle("Notifications", isOn: $notificationsEnabled)
            Picker("Currency", selection: $selectedCurrency) {
                Text("SSP").tag("SSP")
                Text("USD").tag("USD")
                Text("FGP").tag("FGP")
            }
            Picker("Language", selection: $selectedLanguage) {
                Text("English").tag("English")
                Text("Arabic").tag("Arabic")
                Text("Swahili").tag("Swahili")
            }
            NavigationLink(destination: SecuritySettingsView()) {
                Text("Security Settings")
            }
            NavigationLink(destination: PrivacySettingsView()) {
                Text("Privacy Settings")
            }
        }
    }

    var messagesSection: some View {
        Section(header: Text("Messages")) {
            NavigationLink(destination: MessagesView()) {
                HStack {
                    Text("Inbox")
                    Spacer()
                    Text("3")
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
    }

    var accountManagementSection: some View {
        Section(header: Text("Account Management")) {
            NavigationLink(destination: FlexiGoAccountView()) {
                Text("Manage FlexiGo Account")
            }
            NavigationLink(destination: PaymentMethodsView()) {
                Text("Payment Methods")
            }
            NavigationLink(destination: RideHistoryView()) {
                Text("Ride History")
            }
            NavigationLink(destination: DeliveryHistoryView()) {
                Text("Delivery History")
            }
        }
    }

    var legalSection: some View {
        Section(header: Text("Legal")) {
            NavigationLink(destination: LegalDocumentView(title: "Terms & Conditions")) {
                Text("Terms & Conditions")
            }
            NavigationLink(destination: LegalDocumentView(title: "Privacy Policy")) {
                Text("Privacy Policy")
            }
            NavigationLink(destination: LegalDocumentView(title: "Software License")) {
                Text("Software License")
            }
            NavigationLink(destination: LegalDocumentView(title: "Copyright Information")) {
                Text("Copyright Information")
            }
        }
    }

    var logoutButton: some View {
        Section {
            Button(action: {
                // Implement logout functionality
                isLoggedIn = false
            }) {
                Text("Log Out")
                    .foregroundColor(.red)
            }
        }
    }
}

struct User {
    var name: String
    var email: String
    var phone: String
}

struct ProfileEditView: View {
    @Binding var user: User
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $user.name)
                TextField("Email", text: $user.email)
                TextField("Phone", text: $user.phone)
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Save") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SecuritySettingsView: View {
    @State private var isTwoFactorEnabled = false
    @State private var isLocationTrackingEnabled = true

    var body: some View {
        Form {
            Toggle("Two-Factor Authentication", isOn: $isTwoFactorEnabled)
            Toggle("Location Tracking", isOn: $isLocationTrackingEnabled)
            NavigationLink(destination: Text("Change Password View")) {
                Text("Change Password")
            }
        }
        .navigationTitle("Security Settings")
    }
}

struct PrivacySettingsView: View {
    @State private var isDataSharingEnabled = false
    @State private var isPersonalizedAdsEnabled = true

    var body: some View {
        Form {
            Toggle("Data Sharing", isOn: $isDataSharingEnabled)
            Toggle("Personalized Ads", isOn: $isPersonalizedAdsEnabled)
            NavigationLink(destination: Text("Data Download View")) {
                Text("Download My Data")
            }
        }
        .navigationTitle("Privacy Settings")
    }
}

struct MessagesView: View {
    var body: some View {
        List {
            MessageRow(title: "Your ride is arriving", subtitle: "Driver is 2 minutes away", time: "2m ago")
            MessageRow(title: "Rate your last ride", subtitle: "How was your experience?", time: "1h ago")
            MessageRow(title: "Weekend promo", subtitle: "Get 20% off your next ride", time: "1d ago")
        }
        .navigationTitle("Messages")
    }
}

struct MessageRow: View {
    let title: String
    let subtitle: String
    let time: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Text(time).font(.caption).foregroundColor(.secondary)
        }
    }
}

struct FlexiGoAccountView: View {
    @State private var balance: Double = 50.0

    var body: some View {
        Form {
            Section(header: Text("Account Balance")) {
                Text("$\(balance, specifier: "%.2f")")
                    .font(.headline)
            }
            Section {
                NavigationLink(destination: Text("Top Up View")) {
                    Text("Top Up Account")
                }
                NavigationLink(destination: Text("Transaction History View")) {
                    Text("Transaction History")
                }
            }
        }
        .navigationTitle("FlexiGo Account")
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        List {
            PaymentMethodRow(type: "Visa", last4: "4242")
            PaymentMethodRow(type: "Mastercard", last4: "5555")
            NavigationLink(destination: Text("Add Payment Method View")) {
                Text("Add Payment Method")
            }
        }
        .navigationTitle("Payment Methods")
    }
}

struct PaymentMethodRow: View {
    let type: String
    let last4: String

    var body: some View {
        HStack {
            Image(systemName: "creditcard.fill")
            Text("\(type) ending in \(last4)")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

struct RideHistoryView: View {
    var body: some View {
        List {
            RideHistoryRow(destination: "Downtown", date: "May 1, 2024", amount: 15.50)
            RideHistoryRow(destination: "Airport", date: "Apr 28, 2024", amount: 35.00)
            RideHistoryRow(destination: "Shopping Mall", date: "Apr 25, 2024", amount: 12.75)
        }
        .navigationTitle("Ride History")
    }
}

struct RideHistoryRow: View {
    let destination: String
    let date: String
    let amount: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(destination).font(.headline)
                Text(date).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
        }
    }
}

struct DeliveryHistoryView: View {
    var body: some View {
        List {
            DeliveryHistoryRow(item: "Groceries", date: "May 2, 2024", amount: 25.50)
            DeliveryHistoryRow(item: "Restaurant Order", date: "Apr 30, 2024", amount: 42.00)
            DeliveryHistoryRow(item: "Electronics", date: "Apr 27, 2024", amount: 199.99)
        }
        .navigationTitle("Delivery History")
    }
}

struct DeliveryHistoryRow: View {
    let item: String
    let date: String
    let amount: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item).font(.headline)
                Text(date).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Text("$\(amount, specifier: "%.2f")")
        }
    }
}

struct LegalDocumentView: View {
    let title: String

    var body: some View {
        ScrollView {
            Text("This is the content of the \(title). It includes all the necessary legal information and details about our services, user rights, and company policies.")
                .padding()
        }
        .navigationTitle(title)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(isLoggedIn: .constant(true))
    }
}
