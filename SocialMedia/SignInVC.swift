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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AccessToken.current != nil {
            print("Its already Done")
        }else{
            print("its sha reading this block of code")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else {
                print("Authentication is 💯")
            }
        }
    }
    
}

