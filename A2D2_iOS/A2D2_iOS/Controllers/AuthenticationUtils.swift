//
//  AuthenticationUtils.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 2/6/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Firebase

class AuthenticationUtils {
    public static var currentUser : User?
    
    public static func login(email : String, password : String, completion : @escaping (Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                handleLoginError(error)
                completion(false)
            }
            completion(updateCurrentUser(authResult: user))
        }
    }
    
    
    public static func isRegisteredUserEmail (email : String, completion : @escaping (Bool) -> ()) {
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (results,error) in
            if results == nil {
                completion(false)
            } else {
                completion(true)
            }
        })
    }

    
    //TODO
    private static func handleLoginError(_ error : Error) {
        
    }
    
    
    private static func updateCurrentUser(authResult : AuthDataResult?) -> Bool{
        if let newUser = authResult?.user {
            currentUser = newUser
            return true
        }
        return false
    }
    
    
    public static func requestPasswordReset(forEmail email: String){
        Auth.auth().sendPasswordReset(withEmail: email, completion: requestResetError(_:))
    }
    
    
    private static func requestResetError(_ : Error?){
        print("Email Sent")
    }
}
