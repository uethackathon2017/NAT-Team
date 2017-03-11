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
    let viewModel = LoginViewModel()
    // MARK: - Setup
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatFBLoginButton()

        if let user = DataAccess.shared.getUser(){
            User.current = user
            self.performSegue(withIdentifier: AppDefine.Segue.loginToHome, sender: nil)
        }
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
            loginWithFacebook()
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
            if AppDefine.AppInfo.developMode {
                self.performSegue(withIdentifier: AppDefine.Segue.loginToHome, sender: nil)
                return
            }
            self.startAnimating()
            viewModel.loginReques(tokenFB: token, phone: nil, pass: nil, complite: { (isSuccess) in
                self.stopAnimating()
                if isSuccess{
                    self.performSegue(withIdentifier: AppDefine.Segue.loginToHome, sender: nil)
                }else{
                    
                }
            }, handleNotRegister: {
                self.fetchProfile()
                //TODO: goto register
            })
        }
    }
    
    func loginWithPhone(){
        self.startAnimating()
        APIRequest().loginFacebook(facebook_token: nil, phone_number: User.current.phoneNumber, password: User.current.password, handle: { (isSuccess, user) in
            self.stopAnimating()
            if isSuccess {
                User.current = user!
                DataAccess.shared.saveUser(User.current)
                self.performSegue(withIdentifier: AppDefine.Segue.loginToHome, sender: nil)
            }
        }, handleNotActive: {
            
        })
    }
    
    func fetchProfile(){
        self.startAnimating()
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, birthday, picture.type(large)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            self.stopAnimating()
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }else{
                if let data = result as? NSDictionary{
                    print(data.allKeys)
                    if let name = data.value(forKey: "name") as? String  {
                        User.current.fullName = name
                    }
                    if let id = data.value(forKey: "id") as? String  {
                        User.current.facebookId = id
                    }
                    self.performSegue(withIdentifier: AppDefine.Segue.loginToRegister, sender: nil)
                }
            }
        })
    }

}
