//
//  DetailViewController.swift
//  News
//
//  Created by Wuz Good on 23.10.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Article?

    override func loadView() {
        webView = WKWebView()
        view = webView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        guard let detailItem = detailItem else { return }
            
        
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0 maximum-scale=1.0 user-scalable=no">
            <style> body { font-size: 130%; } </style>
            <img src="\(detailItem.urlToImage ?? "")" width="100%">
            <h2>\(detailItem.title ?? "")</h2>
            </head>
            <body>
            <h3 align="center">
            \(detailItem.source.name ?? "")
            </h3>
            <h4 align="center">
            <i>\(detailItem.author ?? "")</i>
            </h4>
            <p>\(detailItem.description ?? "")</p>
            </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)

    }
    
    @objc func shareTapped() {
        guard let url = detailItem?.url else { return }
        let items = [URL(string: url)]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
}
