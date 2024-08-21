import SwiftUI

enum UserRole {
    case user
    case driver
    case seller
}

struct AuthView: View {
    @Binding var isLoggedIn: Bool
    @Binding var userRole: UserRole
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var selectedRole: UserRole = .user
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingForgotPassword = false

    let primaryColor = Color.black
    let secondaryColor = Color(white: 0.2)
    let accentColor = Color.white
    let selectedTextColor = Color.white
    let unselectedTextColor = Color.black

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [primaryColor, secondaryColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 30) {
                        logoView
                        titleView
                        roleSelectionView
                        formFields
                        actionButton
                        forgotPasswordButton
                        toggleModeButton
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 50)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
    }

    var logoView: some View {
        Image("Image")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: 5)
    }

    var titleView: some View {
        Text(isLoginMode ? "Welcome Back!" : "Create Account")
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }

    var roleSelectionView: some View {
        HStack {
            roleButton(for: .user)
            roleButton(for: .driver)
            roleButton(for: .seller)
        }
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }

    func roleButton(for role: UserRole) -> some View {
        Button(action: {
            withAnimation {
                selectedRole = role
            }
        }) {
            Text(roleText(for: role))
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedRole == role ? primaryColor : Color.white)
                .foregroundColor(selectedRole == role ? selectedTextColor : unselectedTextColor)
        }
        .cornerRadius(15)
    }

    func roleText(for role: UserRole) -> String {
        switch role {
        case .user:
            return "Client"
        case .driver:
            return "Driver"
        case .seller:
            return "Seller"
        }
    }

    var formFields: some View {
        VStack(spacing: 20) {
            if !isLoginMode {
                CustomTextField(placeholder: "Full Name", text: $fullName, imageName: "person.fill")
                CustomTextField(placeholder: "Phone Number", text: $phoneNumber, imageName: "phone.fill")
            }
            CustomTextField(placeholder: "Email", text: $email, imageName: "envelope.fill")
            CustomSecureField(placeholder: "Password", text: $password, imageName: "lock.fill")
            if !isLoginMode {
                CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword, imageName: "lock.fill")
            }
        }
    }

    var actionButton: some View {
        Button(action: performAction) {
            Text(isLoginMode ? "Log In" : "Sign Up")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(accentColor)
                .cornerRadius(15)
        }
    }

    var forgotPasswordButton: some View {
        Button(action: {
            showingForgotPassword = true
        }) {
            Text("Forgot Password?")
                .foregroundColor(accentColor)
                .font(.subheadline)
        }
        .padding(.top, 10)
    }

    var toggleModeButton: some View {
        Button(action: {
            withAnimation {
                isLoginMode.toggle()
            }
        }) {
            Text(isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                .foregroundColor(accentColor)
                .font(.subheadline)
        }
        .padding(.top, 20)
    }

    private func performAction() {
        if isLoginMode {
            // Perform login
            if email.isEmpty || password.isEmpty {
                alertMessage = "Please enter both email and password."
                showingAlert = true
            } else {
                // Here you would typically call your authentication service
                isLoggedIn = true
                userRole = selectedRole
            }
        } else {
            // Perform signup
            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || fullName.isEmpty || phoneNumber.isEmpty {
                alertMessage = "Please fill in all fields."
                showingAlert = true
            } else if password != confirmPassword {
                alertMessage = "Passwords do not match."
                showingAlert = true
            } else {
                // Here you would typically call your registration service
                isLoggedIn = true
                userRole = selectedRole
            }
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let imageName: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
                .frame(width: 20)
            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let imageName: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
                .frame(width: 20)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
    }
}

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter your email address to reset your password")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                CustomTextField(placeholder: "Email", text: $email, imageName: "envelope.fill")
                    .padding(.horizontal)
                
                Button(action: resetPassword) {
                    Text("Reset Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Password Reset"), message: Text("If an account exists for \(email), you will receive a password reset email."), dismissButton: .default(Text("OK")) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func resetPassword() {
        // Here you would typically call your password reset service
        showingAlert = true
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(isLoggedIn: .constant(false), userRole: .constant(.user))
    }
}
