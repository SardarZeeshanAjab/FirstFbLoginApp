//
//  ViewController.swift
//  FirstFbLoginApp
//
//  Created by Shan on 23/04/2018.
//  Copyright © 2018 Shan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Google

class ViewController: UIViewController, FBSDKLoginButtonDelegate,GIDSignInUIDelegate ,GIDSignInDelegate{
    
    let signButton = GIDSignInButton()
    //MARK:- declaring imageview and lable
    var imageView : UIImageView!
    var label: UILabel!
    var labelGoogle:UILabel!
    var googleImage:UIImageView!
    var btnSignOut : UIButton!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- setting imageView  for facbook image programatically
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "fb-art.jpg")
        view.addSubview(imageView)
        
        //MARK: - setting lable
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.center = CGPoint(x: view.center.x, y: 300)
        label.text = "Not Logged In"
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        //MARK: setting facebook login button
        let loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: view.center.x, y: 400)
        loginButton.delegate = self
        view.addSubview(loginButton)
         getFacebookUserInfo()
        
        
      //MARK:- setting label for google
        labelGoogle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelGoogle.center = CGPoint(x: view.center.x, y: 700)
        labelGoogle.text = "Not SignIn"
        labelGoogle.textAlignment = NSTextAlignment.center
        view.addSubview(labelGoogle)
        
        //MARK:- setting image for google
        googleImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        googleImage.center = CGPoint(x: view.center.x, y: 500)
        googleImage.image = UIImage(named: "fb-art.jpg")
        view.addSubview(googleImage)
        
        //MARK:- google sign out button
        btnSignOut = UIButton(frame: CGRect(x:view.center.x, y: 600, width: 100, height: 30))
        btnSignOut.center = CGPoint(x:view.center.x,y: 600)
        btnSignOut.setTitle("Sign Out", for: UIControlState.normal)
        btnSignOut.layer.cornerRadius = 5
        btnSignOut.layer.borderWidth = 0.5
        btnSignOut.layer.borderColor = UIColor.lightGray.cgColor
        btnSignOut.backgroundColor = UIColor.white
        btnSignOut.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btnSignOut.setImage(UIImage(named: "Image"), for: UIControlState.normal)
        btnSignOut.imageEdgeInsets = UIEdgeInsetsMake(0, -10.0, 0, 0)
        btnSignOut.titleLabel!.font = UIFont(name: "Avenir Next-Bold", size:14)
        btnSignOut.titleLabel!.font = UIFont.boldSystemFont(ofSize: 14)
        btnSignOut.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        btnSignOut.addTarget(self, action: #selector(ViewController.didTapSignOut(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btnSignOut)
    
        //MARK:- google sign in
        var error:NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        if error != nil{
            print(error ?? "some error")
        }
        
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
        
            signButton.center = CGPoint(x: view.center.x, y: 600)
            view.addSubview(signButton)
            
       
    }
    

    
    
    //MARK:- delegate method of google signin & calling image from url
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
     
        if let error = error {
            print("\(error.localizedDescription)")
        }else{
            labelGoogle.text = user.profile.email
            if user.profile.hasImage{
                
                let imageUrlString = "https://lh5.googleusercontent.com/-PgeeUbOp9Ps/AAAAAAAAAAI/AAAAAAAAAC4/LzNs1wpX4Xg/s120/photo.jpg"
                let imageUrl:URL = URL(string: imageUrlString)!
                
                // Start background thread so that image loading does not make app unresponsive
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    
                    //MARK:- When from background thread, UI needs to be updated on main_queue & setting google image
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData as Data)
                        self.googleImage.image = image
                        self.googleImage.contentMode = UIViewContentMode.scaleAspectFit
                        self.view.addSubview(self.googleImage)
                        
                        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                            self.signButton.isHidden = true
                        }
            }
                }
                
            }
  }}
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
       GIDSignIn.sharedInstance().signOut()
        
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
      
        let alertController = UIAlertController(title: "SignOut", message: "Do You want To signOut ?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            GIDSignIn.sharedInstance().signOut()
            self.googleImage.image = UIImage(named: "fb-art.jpg")
            self.labelGoogle.text = "Not sign in"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
       
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            signButton.isHidden = false

        }

       
    }

    
    //MARK: - facebook login button delegate method
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loginButtonDidLogOut")
        imageView.image = UIImage(named: "fb-art.jpg")
        label.text = "Not Logged In"
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("didCompleteWith")
        getFacebookUserInfo()
    }
    //MARK:- fetching data from facebook account
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //MARK:- print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            //MARK:- filter fetch request
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                //MARK:- setting image and name
                let data = result as! [String : AnyObject]
                
                self.label.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
    }
}
