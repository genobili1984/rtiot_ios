//
//  LoginViewController.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/3.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit
import SwifterSwift
import Dispatch
import Toast_Swift
import PromiseKit
import Moya

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.loginButton.width, height: self.loginButton.height)
//        gradientLayer.startPoint = CGPoint(x: CGFloat(0), y: CGFloat(0.5))
//        gradientLayer.endPoint = CGPoint(x: CGFloat(1.0), y: CGFloat(0.5) )
//        gradientLayer.locations = [0, 1.0]
//        gradientLayer.colors = [Color(red: 0xff, green: 0xda, blue: 0x00) ?? Color(), Color(red: 0xff, green: 0xc7, blue: 0x00) ?? Color()]
//        self.loginButton.layer.addSublayer(gradientLayer)
        self.loginButton.backgroundColor = Color(red: 0xff, green: 0xda, blue: 0x00) ?? Color()
        self.loginButton.setTitle("登录", for: .normal)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginBtnClick(_ sender: Any) {
        self.view.endEditing(true)
        let username = self.accountTextField.text ?? ""
        let password = self.passwdTextField.text
        let md5 = password?.MD5 ?? ""
//        RTAPIProvider.request(.login(username: username ?? "", passwd: md5.uppercased())) { result in
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            do {
//                let response = try result.get()
//                let value = try response.mapNSDictioary()
//                if value["ret"] != nil && value["ret"] as? Int32 == 0 {
//                    let homeView = HomeViewController(nibName:"HomeViewController", bundle:nil)
//                    let naviControler = UINavigationController(rootViewController: homeView)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.window?.rootViewController = naviControler
//                }
//            }catch {
//                self.view?.makeToast("登录失败", duration: 2.0, position: .bottom)
//            }
//        }
//        firstly { () -> Promise<Moya.Response> in
//            return RTAPIProvider.request(target: .login(username: username ?? "", passwd: md5.uppercased()))
//        }.done { (response) -> Void in
//            do {
//                let decoder = JSONDecoder()
//                let loginResult = try decoder.decode(LoginResult.self, from: response.data)
//                if loginResult.code == 0  {
//                    let homeView = HomeViewController(nibName:"HomeViewController", bundle:nil)
//                    let naviControler = UINavigationController(rootViewController: homeView)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.window?.rootViewController = naviControler
//                }
//            }catch {
//                self.view?.makeToast("登录失败", duration: 2.0, position: .bottom)
//            }
//        }.ensure {
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }.catch { [weak self] (error) in
//            self?.view?.makeToast("登录失败", duration: 2.0, position: .bottom)
//        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            RTAPIProvider.request(target: .login(username: username, passwd: md5.lowercased()))
        }.done { (response) -> Void in
                let decoder = JSONDecoder()
                let loginResult = try decoder.decode(LoginResult.self, from: response.data)
                if loginResult.retCode == 1000  {
                    let homeView = HomeViewController(nibName:"HomeViewController", bundle:nil)
                    homeView.enterPriseID = loginResult.userInfo.enterPriseID
                    let naviControler = UINavigationController(rootViewController: homeView)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = naviControler
                }
            }.catch { [weak self](error) in
             self?.view?.makeToast("登录失败", duration: 2.0, position: .bottom)
            }.finally {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
