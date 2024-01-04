//
//  ViewController.swift
//  GoogleMapsProject
//
//  Created by EnGiS_Spencer on 2023/12/29.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webViewBackgroundView: UIView!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 웹뷰 설정
        self.setWebView()
        // 웹뷰 통신
        self.openWebViewAction()
    }
    
    
    func setWebView() {
        let contentController = WKUserContentController()
                
        // Bridge 등록
        contentController.add(self, name: "back")
        contentController.add(self, name: "outLink")
        contentController.add(self, name: "bridge")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        webViewBackgroundView.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: webViewBackgroundView.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewBackgroundView.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: webViewBackgroundView.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewBackgroundView.trailingAnchor).isActive = true

    }
    
    // 웹뷰 열기
    func openWebViewAction() {
        
        let url = URL(string: "https://spencer.tistory.com/")
        let request = URLRequest(url: url!)
        self.webView.load(request)
    }
    
    internal func sendMessageToVue() {
        print("function sendMessageToVue called")

        let message = "iOS"
        
        self.webView.evaluateJavaScript("javascript:window.NativeInterface.receiveMessage('\(message)');") { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                print(result)
                print("성공")
            } else {
                print("no error nor result")
            }
        }
    }
    
    func callMyFunction() {
        let functionName = "myFunction"
        let message = "Hello from iOS!"

        let javascript = "\(functionName)('\(message)');"
        webView.evaluateJavaScript(javascript) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Function called successfully!")
            }
        }
    }
    
    
}


extension ViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // 메시지 JSON 처리 해야함
        print(message)
        
        if message.name == "bridge" {
            
            print("bridge 진입")
            
            let bridgeData = message.body as! [String: AnyObject]
            print("bridgeData", bridgeData)
            
            let bridgeCommand = bridgeData["command"] as! String
            let bridgePayload = bridgeData["payload"] as! String
            // let id = UInt16(userInfo["id"] as! UInt16)
            print("bridgeCommand", bridgeCommand)
            print("bridgePayload", bridgePayload)
            
            if bridgeCommand == "logout" {
                self.sendMessageToVue()
//                self.callMyFunction()
            }

            
//            if let message = try? JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
            
////                if message == "darkMode" {
////
////                    print("message", message)
////
////                }
//                let webMessage = WebMessage(rawValue: message)
//
//                switch webMessage {
//                case .darkMode:
//                    print("darkMode")
//
//                case .whiteMode:
//                    print("whiteMode")
//
//                default:
//                    print("default")
//                    return
//                }
//            }
                
                //            let ok_data = "hello"
                //            self.webView.evaluateJavaScript("javascript:window.NativeInterface.receive_Open('\(ok_data)')") {
                //                // '\(ok_data)\'
                //                result, error in
                //                if let error = error {
                //                    print(error.localizedDescription)
                //                } else if let result = result {
                //                    print(result)
                //                    print("성공")
                //                }
                //            }

            
//            if let dictionary: [String: Any] = message.body as? Dictionary,
//               let payload = dictionary["payload"] as? String {
//
//                if payload == "1" {
//
//                    print("payload", payload)
//                }
//            }
            
            /* 방법 1. handler를 읽어서 하는 방법 */
            //        switch message.name {
            //
            //        case "back":
            //            print("back 호출")
            ////            let alert = UIAlertController(title: nil, message: "Back 버튼 클릭", preferredStyle: .alert)
            ////            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            ////            alert.addAction(action)
            ////            self.present(alert, animated: true, completion: nil)
            //            self.sendMessageToVue()
            //
            //        case "outLink":
            //            guard let outLink = message.body as? String, let url = URL(string: outLink) else {
            //                return
            //            }
            //
            //            let alert = UIAlertController(title: "OutLink 버튼 클릭", message: "URL : \(outLink)", preferredStyle: .alert)
            //            let openAction = UIAlertAction(title: "링크 열기", style: .default) { _ in
            //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //            }
            //            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            //            alert.addAction(openAction)
            //            alert.addAction(cancelAction)
            //            self.present(alert, animated: true, completion: nil)
            //
            //        default:
            //            print("bridge default")
            //            break
            //        }
        }
    }
    


}
