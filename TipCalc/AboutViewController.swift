//
//  AboutViewController.swift
//  TipCalc
//
//  Created by Qin Yubo on 2017/3/11.
//  Copyright © 2017年 Yubo Qin. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import SafariServices

class AboutViewController: UIViewController {
    
    fileprivate let aboutWebView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.allowsBackForwardNavigationGestures = false
        webView.alpha = 0
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(aboutWebView)
        aboutWebView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        let aboutPagePath = Bundle.main.path(forResource: "about", ofType: "html")
        var aboutHTML = try! String(contentsOfFile: aboutPagePath!, encoding: .utf8)
        
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")!
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String)!
        
        aboutHTML = aboutHTML.replacingOccurrences(of: "APP_NAME_PLACEHOLDER", with: name as! String)
        aboutHTML = aboutHTML.replacingOccurrences(of: "APP_VERSION_PLACEHOLDER", with: version as! String)
        aboutHTML = aboutHTML.replacingOccurrences(of: "APP_BUILD_PLACEHOLDER", with: build as! String)
        aboutWebView.loadHTMLString(aboutHTML, baseURL: Bundle.main.resourceURL)
        
        aboutWebView.navigationDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AboutViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3, animations: {
            self.aboutWebView.alpha = 1.0
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                if url.description.range(of: "http://") != nil || url.description.range(of: "https://") != nil || url.description.range(of: "mailto:") != nil || url.description.range(of: "tel:") != nil  {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}
