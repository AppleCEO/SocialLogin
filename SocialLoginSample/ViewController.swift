//
//  ViewController.swift
//  SocialLoginSample
//
//  Created by joon-ho kil on 2020/02/05.
//  Copyright © 2020 joon-ho kil. All rights reserved.
//

import UIKit
import Alamofire
import NaverThirdPartyLogin

class ViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton! {
        didSet{
            logoutBtn.isHidden = true
        }
    }
    @IBOutlet weak var emailLabel: UILabel! {
        didSet{
            emailLabel.text = nil
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet{
            nameLabel.text = nil
        }
    }
    @IBOutlet weak var birthLabel: UILabel! {
        didSet{
            birthLabel.text = nil
        }
    }
    //MARK: Properties
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: IBAction
    @IBAction func handleLogin(_ sender: Any) { // ----- 1
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    @IBAction func handleLogout(_ sender: Any) { // ----- 2
//        loginConn?.resetToken() // 로그아웃
        loginInstance?.requestDeleteToken() // 연동해제
        logoutBtn.isHidden = true
        loginBtn.isHidden = false
        emailLabel.text = nil
        birthLabel.text = nil
        nameLabel.text = nil
    }
}

extension ViewController: NaverThirdPartyLoginConnectionDelegate{
    // ---- 3
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
    }
    // ---- 4
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    // ---- 5
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
        logoutBtn.isHidden = false
        loginBtn.isHidden = true
    }
    // ---- 6
    func oauth20ConnectionDidFinishDeleteToken() {

    }
    // ---- 7
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        print(error)
    }
    // ---- 8
    func getNaverEmailFromURL(){
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}

        let authorization = "\(tokenType) \(accessToken)"
        AF.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                guard let result = value as? [String: Any] else { return }
                guard let object = result["response"] as? [String: Any] else {return}
                guard let birthday = object["birthday"] as? String else {return}
                guard let name = object["name"] as? String else {return}
                guard let email = object["email"] as? String else {return}
                self.birthLabel.text = birthday
                self.nameLabel.text = name
                self.emailLabel.text = email
            case .failure(let error):
                print(error)
            }
        }
    }
}

