//
//  STWebViewController.swift
//  swim-training
//
//  Created by Alexandr on 08.11.2021.
//

import UIKit
import WebKit

class STWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

	@IBOutlet weak var wkNavigationBar: UINavigationBar!
	@IBOutlet weak var webView: WKWebView!
	
	var urlString: String?
	
	init(urlString: String) {
		self.urlString = urlString
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		webView.navigationDelegate = self
		guard let urlString = urlString, let url = URL(string: urlString) else { return }
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
    }
	
	@IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true)
	}

	@IBAction func refreshButtontapped(_ sender: UIBarButtonItem) {
		webView.reload()
	}
	@IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
		webView.goBack()
	}
	
	@IBAction func forwardButtonTapped(_ sender: UIBarButtonItem) {
		webView.goForward()
	}
	
}
