//
//  WebKitVC.swift
//  Playo
//
//  Created by yeshwanth srinivas rao bandaru on 13/07/22.
//

import UIKit
import WebKit

class WebKitVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var recieveWebUrl = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: recieveWebUrl)!))
    }
}
