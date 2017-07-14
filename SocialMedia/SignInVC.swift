//
//  SignInVC.swift
//  SocialMedia
//
//  Created by Shalom Owolabi on 12/07/2017.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: HoshiTextField!
    @IBOutlet weak var passwordText: HoshiTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeedVC", sender: nil)
        }
        
    }
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin = LoginManager()
        
//        let handler = { (result: LoginResult!, error: Error?) in
//            if let error = error {
//                //3.1
//                print("error = \(error.localizedDescription)")
//            }else if result.{
//                //3.2
//                print("user tapped on Cancel button")
//            }else {
//                //3.3
//                print("authenticate successfully")
//                
//                self.goToHomeViewController()
//            }
//        }
        
        facebookLogin.logIn([.email], viewController: nil) { result in
           
            switch result {
                
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                print("Logged in!")
                
                let credence = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
                
                self.firebaseAuth(credence)
            }
        }
        
        
    }
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailText.text, let pass = passwordText.text {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("All done @Email")
                    if let user = user {
                        self.completeSignIn(user.uid)
                    }
                }else {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil{
                            print(error?.localizedDescription ?? String(), "Unable to do shii")
                        }else{
                            print("User Created")
                            Auth.auth().signIn(withEmail: email, password: pass, completion: nil)
                            if let user = user {
                                self.completeSignIn(user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else {
                print("Authentication is 💯")
                if let user = user{
                    self.completeSignIn(user.uid)
                }
            }
        }
    }
    
    func completeSignIn(_ id: String){
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        performSegue(withIdentifier: "goToFeedVC", sender: nil)
    }
}

