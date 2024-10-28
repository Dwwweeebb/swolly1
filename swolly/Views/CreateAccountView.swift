import SwiftUI
import Firebase
import FirebaseAuth

struct CreateAccountView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Create Account") {
                createAccount()
            }
            .padding()
            
            Text(errorMessage)
                .foregroundColor(.red)
        }
        .padding()
    }
    
    func createAccount() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        
        guard isPasswordStrong(password) else {
            errorMessage = "Password must be at least 6 characters long and contain a mix of letters and numbers."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                print("Error creating account: \(error.localizedDescription)")
                print("Error code: \(error.code)")
                print("Error domain: \(error.domain)")
                errorMessage = "Error: \(error.localizedDescription)"
                
                if let errorUserInfo = error.userInfo as? [String: Any] {
                    print("Error user info: \(errorUserInfo)")
                }
            } else {
                print("Account created successfully")
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isPasswordStrong(_ password: String) -> Bool {
        return password.count >= 6 && password.rangeOfCharacter(from: .letters) != nil && password.rangeOfCharacter(from: .decimalDigits) != nil
    }
}
