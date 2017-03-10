//
//  LoginViewController.swift
//  CrossWorld
//
//  Created by Anh Son Le on 3/10/17.
//  Copyright © 2017 Anh Son Le. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKMessengerShareKit

class LoginViewController: AppViewController, FBSDKLoginButtonDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    @IBOutlet weak var btnLoginWithPhoneNumber: UIButton!
    @IBOutlet weak var btnCreatAcount: UIButton!
    
    // MARK: - Declare
    
    // MARK: - Define
    let btnLoginFBButton = FBSDKLoginButton()
    
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatFBLoginButton()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AppViewController
    override func setupViewController() {
        self.typeViewController = .root
        self.typeNavigationBar = .hidden
    }
    @IBAction func btnLoginFacebookClick(_ sender: Any) {
        
        if (FBSDKAccessToken.current()) != nil {
            print(FBSDKAccessToken.current().tokenString)
            //TODO: Call API
        }else{
            self.btnLoginFBButton.sendActions(for: UIControlEvents.touchUpInside)
        }

    }
    
    func creatFBLoginButton(){
        btnLoginFBButton.delegate = self
        
        btnLoginFBButton.readPermissions =
            ["public_profile", "email", "user_friends"]
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            if result.isCancelled {
                
            }else{
                print(FBSDKAccessToken.current().tokenString)
                loginWithFacebook()
            }
        }
    }
    
    func loginWithFacebook(){
        if let token = FBSDKAccessToken.current().tokenString{
//            RequestManager.apiLoginWithFaceBook(access_token: token, completeHandle: { (isSucess, res) in
//                if isSucess{
//                    //self.performSegue(withIdentifier: AppName.segue.loginToHome, sender: nil)
//                }
//            })
        }
    }

}
