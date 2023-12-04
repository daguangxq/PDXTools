//
//  DXThirdLoginManager.swift
//  PriceTagger
//
//  Created by BigSight on 2023/12/1.
//

import Foundation

import FacebookLogin
import GoogleSignIn
import PDXTools

class DXThirdLoginManager : NSObject {
    
    private let weiboApiKey = ""
    private let weiboRedirectURI = ""
    private let weiboUniversalLink = ""
    
    private let wxAppId = ""
    private let wxUniversalLink = ""
    private let wxSecret = ""
    
    // 平台
    enum ThirdType : String {
        case weibo = "weibo"
        case Wechat = "Wechat"
        case facebook = "facebook"
        case google = "google"
    }
    private var registTypes: [ThirdType] = []
    private var loggingInType: ThirdType?
    
    // 异步回调的block
    typealias LoginBlock = (_ token:String?,_ expirationDate:Date? ,_ openid:String?,_ thirdType:ThirdType) -> Void
    typealias UserInfoBlock = (_ dict:Dictionary<String,Any>?) -> Void
    private var loginBlock: LoginBlock?
    private var userInfoBlock: UserInfoBlock?
    
    // 请求
    private var weiboRequest:WBHttpRequest?
    
    /// 注册平台，一般在Launch方法中
    /// - Parameter types: 平台集合
    func registThird(_ types:[ThirdType] ) {
        types.forEach { type in
            switch type {
            case .weibo:
                WeiboSDK.enableDebugMode(true)
                WeiboSDK.registerApp(weiboApiKey, universalLink: weiboUniversalLink)
            case .Wechat:
                WXApi.registerApp(wxAppId, universalLink:wxUniversalLink)
            case .facebook:
                print("")
            case .google:
                print("")
            }
        }
    }
    
    /// 处理第三回调后的逻辑处理,open url 中进行调用
    /// - Parameters:
    ///   - url: 回调的url
    ///   - options: 参数
    func handOpenUrl(url:URL,options: [UIApplication.OpenURLOptionsKey : Any]) {
        registTypes.forEach { thirdType in
            switch thirdType {
            case .weibo:
                WeiboSDK.handleOpen(url, delegate: self)
            case .Wechat:
                WXApi.handleOpen(url, delegate: self)
            case .facebook:
                print("")
            case .google:
                print("")
            }
        }
    }
    
    /// 注册后，跳转到第三方应用进行登录
    /// - Parameters:
    ///   - type: 类型
    ///   - viewController: 当前页面
    ///   - loginBlock: loginBlock 回调
    /// - Returns: 是否成功
    func loginThird(type:ThirdType,_ viewController:UIViewController,loginBlock:@escaping LoginBlock) ->Bool {
        guard registTypes.contains(type) else {
            print(type.rawValue + ".未进行注册")
            return false
        }
        
        self.loggingInType = type
        
        self.loginBlock = loginBlock
        if type == .weibo {
            let request = WBAuthorizeRequest()
            request.redirectURI = weiboRedirectURI
            request.scope = "all"
            WeiboSDK.send(request)
        }else if type == .Wechat {
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo" // 设置请求的权限范围
            req.state = "login" // 设置请求的自定义参数，可选
            WXApi.sendAuthReq(req, viewController: viewController, delegate: self)
        }else if type == .facebook {
            
        }else if type == .google {
            
        }
        
        
        return true
    }
    
    /// 获取登录信息
    /// - Parameters:
    ///   - type: 平台
    ///   - token: 平台获取的Token，没有时通过loginThird()方法获取
    ///   - openid: openid,微信需要改参数
    ///   - userInfoBlock: userInfoBlock,回调
    /// - Returns: 是否成功发送请求
    func fetchLoginInfoRequest(type: ThirdType,token:String,openid:String?,userInfoBlock:@escaping UserInfoBlock) ->Bool {
        self.userInfoBlock = userInfoBlock;
        self.loggingInType = type
        if type == .weibo {
            guard let openid = openid else {
                print(type.rawValue + ".缺少openid参数,微博必须要求")
                return false
            }
            fetchWeiboUserinfoRequest(token: token, openid: openid)
        }else if type == .Wechat {
            guard let openid = openid else {
                print(type.rawValue + ".缺少openid参数,微信必须要求")
                return false
            }
            fetchWXUserinfoRequest(token: token, openid: openid)
        }else if type == .facebook {
            
        }else if type == .google {
            
        }
        
        return false
    }
    
    // 处理登录回调
    private func loginCompleted(_ token:String?,_ expirationDate:Date? ,_ openid:String?) {
        guard let block = self.loginBlock,let type = self.loggingInType else {
            return
        }
        if token == nil {
            print(type.rawValue + ".登录失败")
        }else{
            print(type.rawValue + ".登录成功")
        }
        block(token,nil,openid,type)
        
        self.loggingInType = nil
    }
    
    // 处理获取用户信息回调
    private func userInfoCompleted(_ result:Dictionary<String,Any>?) {
        guard let block = self.userInfoBlock,let type = self.loggingInType else {
            return
        }
        if result == nil {
            print(type.rawValue + ".获取用户信息失败")
        }else{
            print(type.rawValue + ".获取用户信息成功")
        }
        block(result)
        self.loggingInType = nil
    }
}

extension DXThirdLoginManager : WeiboSDKDelegate,WBHttpRequestDelegate {
    
    func fetchWeiboUserinfoRequest(token:String,openid:String) {
        let params: [String: Any] = [
            "access_token": token,
            "uid": openid
        ]
        self.weiboRequest = WBHttpRequest.init(accessToken: token,
                                               url: "https://api.weibo.com/2/users/show.json",
                                               httpMethod: "POST",
                                               params: params,
                                               delegate: self,
                                               withTag: "UserInfo")
    }
    
    // WBHttpRequestDelegate - 失败
    func request(_ request: WBHttpRequest!, didFailWithError error: Error!) {
        userInfoCompleted(nil)
    }
    
    // WBHttpRequestDelegate - 成功
    func request(_ request: WBHttpRequest!, didFinishLoadingWithDataResult data: Data!) {
        
        if let jsonResult = data as? [String: Any] {
            userInfoCompleted(jsonResult)
        }else{
            userInfoCompleted(nil)
        }
    }
    
    // WeiboSDKDelegate --代理
    func didReceiveWeiboRequest(_ request: WBBaseRequest?) {
        // 请求方法，可以获取请求类型
    }
    
    // WeiboSDKDelegate --回调
    func didReceiveWeiboResponse(_ response: WBBaseResponse?) {
        if let authResp = response as? WBAuthorizeResponse {
            if authResp.statusCode == .success {
                // 微博登录成功
                let accessToken = authResp.accessToken
                let userID = authResp.userID
                let expirationDate = authResp.expirationDate
                loginCompleted(accessToken,expirationDate, userID)
            } else {
                let errorCode = authResp.statusCode
                let errorMessage = authResp.userInfo?["errorMessage"] as? String ?? ""
                print((self.loggingInType?.rawValue ?? "") + ".\(errorMessage).\(errorCode)")
                loginCompleted(nil, nil, nil)
            }
        }
        WeiboSDK.send(response)
    }
}

extension DXThirdLoginManager : WXApiDelegate {
    
    // 请求用户信息
    func fetchWXUserinfoRequest(token:String,openid:String) {
        let userInfoUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(token)&openid=\(openid)"
        URLSession.shared.dataTask(with: URL(string: userInfoUrl)!) {[weak self] (data, response, error) in
            if let data = data {
                if let userInfo = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self?.userInfoCompleted(userInfo)
                    return
                }
            }
            self?.userInfoCompleted(nil)
        }.resume()
    }
    
    // WXApiDelegate - 处理微信登录结果
    func onResp(_ resp: BaseResp) {
        guard let authResp = resp as? SendAuthResp else {
            loginCompleted(nil, nil, nil)
            return
        }
        
        guard authResp.errCode == 0 else {
            // 微信登录失败
            let errorCode = authResp.errCode
            let errorMessage = authResp.errStr
            print((self.loggingInType?.rawValue ?? "") + errorMessage + String(errorCode))
            loginCompleted(nil, nil, nil)
            return
        }
        
        // 微信登录成功
        let code = authResp.code ?? "0"
        // 使用code换取access token和openid
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(wxAppId)&secret=\(wxSecret)&code=\(code)&grant_type=authorization_code"
        URLSession.shared.dataTask(with: URL(string: url)!) {[weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let accessToken = json["access_token"] as? String
                    let openid = json["openid"] as? String
                    let expirationDate = json["expires_in"] as? Date
                    // 成功
                    self.loginCompleted(accessToken, expirationDate, openid)
                    return
                }
            }
            self.loginCompleted(nil, nil, nil)
        }.resume()
    }
}
