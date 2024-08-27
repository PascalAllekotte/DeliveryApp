//  AuthViewModel.swift
//  FoodDelivery
//
//  Created by Pascal Allekotte on 05.07.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel : ObservableObject {
    
    // MARK: VARIABLES-
    
    @Published private(set) var user: FireUser?
    @Published private(set) var passwordError: String?
    
    var isUserLoggedIn: Bool {
        user.self != nil
    }
    
    private var firebaseAuthentification = Auth.auth()
    private var firebaseFirestore = Firestore.firestore()
    
    init(){
        if let currentUser = self.firebaseAuthentification.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
        }
    }
    
    // MARK: Functions -
    
    private func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Error fetching user: \(error)")
                return
            }
            
            guard let document else {
                print("Document does not exist")
                return
            }
            
            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }
    
    func login(email: String, password: String) {
        firebaseAuthentification.signIn(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in login: \(error)")
                return
            }
            
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }
            
            print("Successfully signed in with user-Id \(authResult.user.uid) and email \(userEmail)")
            
            self.fetchFirestoreUser(withId: authResult.user.uid)
        }
    }
    
    func register(password: String, name: String, nachname: String, mobilNumber: String, email: String, passwordCheck: String, address: AdressModel, admin: Bool) {
        guard password == passwordCheck else {
            self.passwordError = "Passwörter stimmen nicht überein!"
            return
        }
        
        firebaseAuthentification.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in registration: \(error)")
                return
            }
            
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty!")
                return
            }
            
            print("Successfully registered with user-Id \(authResult.user.uid) and email \(userEmail)")
            
            self.createFirestoreUser(id: authResult.user.uid, name: name, nachname: nachname, mobilNumber: mobilNumber, email: email, address: address, admin: false)
            
            self.fetchFirestoreUser(withId: authResult.user.uid)
        }
    }
    
    private func createFirestoreUser(id: String, name: String, nachname: String, mobilNumber: String, email: String, address: AdressModel, admin: Bool) {
        let newFireUser = FireUser(id: id, name: name, nachname: nachname, mobilNumber: mobilNumber, email: email, adress: address, admin: false)
        
        do {
            try self.firebaseFirestore.collection("users").document(id).setData(from: newFireUser)
        } catch {
            print("Error saving user in firestore: \(error)")
        }
    }
    
    func logout(){
        do {
            try firebaseAuthentification.signOut()
            self.user = nil
        } catch {
            print("error logging out: \(error)")
        }
    }
    
    
    func changeEmail(email: String, newEmail: String, password: String){
        // Neu Authentifizierung
        let user = self.firebaseAuthentification.currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        
        user?.reauthenticate(with: credential){ AuthDataResult, error in
            if let error = error {
                print("Error with Authentification \(error)")
                
            } else {
                print("Authentification was successfull")
                self.firebaseAuthentification.currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                    if let error = error {
                        print("Email not Verified before or other error \(error)")
                    } else {
                        print("Email updated successully to after verification of \(newEmail)")
                    }
                }
            }
        }
    }
     
    
/*
    func changeEmail(email: String, newEmail: String, password: String) {
       
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user?.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                print("Error with reauthentication: \(error.localizedDescription)")
                return
            }
            
            print("Reauthentication was successful")
            
            user?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
                if let error = error {
                    print("Error sending verification email before updating email: \(error.localizedDescription)")
                } else {
                    print("Verification email sent. Email will be updated to \(newEmail) after verification.")
                }
            }
        }
    }

    */
     
    func deleteAccount(password: String, completion: @escaping (Bool) -> Void) {
        let user = self.firebaseAuthentification.currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        
        user?.reauthenticate(with: credential) { _, error in
            if let error = error {
                print("Error with Authentification \(error)")
                completion(false)
            } else {
                print("Authentification was successful")
                self.firebaseAuthentification.currentUser?.delete { error in
                    if let error = error {
                        print("Account not deleted \(error)")
                        completion(false)
                    } else {
                        print("Account deleted")
                        self.user = nil
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    func changePassword(oldPassword: String, newPassword: String){
        let user = self.firebaseAuthentification.currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: oldPassword)

        user?.reauthenticate(with: credential){ authResult, error in
            if let error  = error {
                print("Hat nicht geklappt")
            } else {
                print("Hat geklappt")
                self.firebaseAuthentification.currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        print("Error updating password \(error)")
                    } else {
                        print("Password changed successfully")
                    }
                }
            }
        }
    }
    
    func update(newPassword: String, oldPassword: String){
        self.firebaseAuthentification.currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                print("Error updating password \(error)")
            } else {
                print("Password changed successfully")
            }
        }
    }
    
    // MARK: Updates for Firestore
    func updateName(newName: String, newNachName: String) {
        guard let userId = user?.id else { return }
        
        let updatedData: [String: Any] = [
            "name": newName,
            "nachname": newNachName
        ]
        
        self.firebaseFirestore.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                self.user?.name = newName
                self.user?.nachname = newNachName
                print("User successfully updated")
            }
        }
    }
    
    func updateNumber(newMobilNumber: String) {
        guard let userId = user?.id else { return }
        
        let updatedData: [String: Any] = [
            "mobilNumber": newMobilNumber
        ]
        
        self.firebaseFirestore.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                self.user?.mobilNumber = newMobilNumber
                print("Number successfully updated")
            }
        }
    }
    
    func updateAddress(newAddress: AdressModel) {
        guard let userId = user?.id else { return }
        
        let updatedData: [String: Any] = [
            "adress": [
                "street": newAddress.street,
                "streetNumber": newAddress.streetNumber,
                "postalCode": newAddress.postalCode,
                "place": newAddress.place
            ]
        ]
        
        self.firebaseFirestore.collection("users").document(userId).updateData(updatedData) { error in
            if let error = error {
                print("Error updating address: \(error)")
            } else {
                self.user?.adress = newAddress
                print("Address successfully updated")
            }
        }
    }
    
    
    // MARK: Funktion für die Favoriten
    
    func addToFavorites(productId: String) {
            guard let userId = user?.id else { return }
            let userRef = firebaseFirestore.collection("users").document(userId)
            user?.favorites.append(productId)
            
            userRef.updateData(["favorites": FieldValue.arrayUnion([productId])]) { error in
                if let error = error {
                    print("Error adding to favorites: \(error)")
                } else {
                    print("Successfully added to favorites")
                }
            }
        }

        func removeFromFavorites(productId: String) {
            guard let userId = user?.id else { return }
            let userRef = firebaseFirestore.collection("users").document(userId)
            user?.favorites.removeAll { $0 == productId }
            
            userRef.updateData(["favorites": FieldValue.arrayRemove([productId])]) { error in
                if let error = error {
                    print("Error removing from favorites: \(error)")
                } else {
                    print("Successfully removed from favorites")
                }
            }
        }

        func fetchFavorites() {
            guard let userId = user?.id else { return }
            let userRef = firebaseFirestore.collection("users").document(userId)
            
            userRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching favorites: \(error)")
                    return
                }
                
                guard let document = document, let data = document.data() else {
                    print("No favorites found")
                    return
                }
                
                if let favorites = data["favorites"] as? [String] {
                    self.user?.favorites = favorites
                }
            }
        }
    
}
