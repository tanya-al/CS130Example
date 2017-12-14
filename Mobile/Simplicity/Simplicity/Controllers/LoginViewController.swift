//
//  LoginViewController.swift
//  Simplicity
//
//  Created by Tanya A on 12/13/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation
import FacebookLogin
import FBSDKLoginKit

class LoginViewController : UIViewController {
    var dict : [String : AnyObject]!
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = FBSDKAccessToken.current(){
            print(accessToken)
            var userData = getFBUserData()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            UIApplication.shared.keyWindow?.rootViewController = initialViewController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor.clear
            }
            UIApplication.shared.statusBarStyle = .lightContent
            print("did the thing")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //creating button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        //adding it to view
        view.addSubview(loginButton)
        
        //if the user is already logged in
        if let accessToken = FBSDKAccessToken.current(){
            getFBUserData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //when login button clicked
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("logged in")
                self.getFBUserData()
            }
        }
    }

    //function is fetching the user data
    func getFBUserData() -> [String: Any] {
        var userData : [String: Any] = [:]
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    userData = self.dict
                }
            })
        }
        return userData
    }
}
