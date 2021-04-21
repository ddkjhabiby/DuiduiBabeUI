//
//  WebViewController.swift
//  Bobo
//
//  Created by ddkj on 2019/9/3.
//  Copyright © 2019 duiud. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

public class WebViewController: BaseViewController {
    
    var webView: WKWebView = WKWebView()
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()
    
    public var urlString: String
    
    public init(url: String) {
        urlString = url
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(url: String, config: WKWebViewConfiguration) {
        urlString = url
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(2)
        }
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
            webView.load(request)
        }
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = progressView.progress == 1 ? true : false
        } else if keyPath == "title" {
            title = webView.title
        }
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab_bar_back_normal")?.flippedImageForRTL, style: .plain, target: self, action: #selector(navigationBack))
    }
    
    // 返回上一控制器
    @objc private func navigationBack() {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        if self == self.navigationController?.viewControllers.first {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

public extension WebViewController{
    func updateCookies(){
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        
    }
    
}

extension WebViewController {
    
    func handleWeBridge() {
//        weBridge.jsFunc = { [weak self] (sel, params) in
//
//        }
    }
}

extension WebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//        Toast()?.showToast(message)
        completionHandler()
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}

extension WebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            RouterUtil.enter(urlString:  url)
//            webView.evaluateJavaScript("") { (<#Any?#>, <#Error?#>) in
//                <#code#>
//            }
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        view.bringSubviewToFront(progressView)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print("zzz")
    }
    
    
}

