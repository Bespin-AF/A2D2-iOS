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
    
    public static func login(email : String, password : String, completion : @escaping (Bool) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                handleLoginError(error)
                completion(false)
            }
            completion(updateCurrentUser(authResult: user))
        }
    }
    
    
    // TO-DO
    private static func handleLoginError(_ error : Error) {
        
    }
    
    
    private static func updateCurrentUser(authResult : AuthDataResult?) -> Bool{
        if let newUser = authResult?.user {
            currentUser = newUser
            return true
        }
        return false
    }
}
