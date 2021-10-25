//
//  DetailViewController.swift
//  News
//
//  Created by Wuz Good on 23.10.2021.
//

import UIKit
import WebKit
import CoreData

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Article?
    var detailItemCoreData: NSManagedObject?

    override func loadView() {
        webView = WKWebView()
        view = webView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let detailItem = detailItem  {
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
        
        if let detailItemCoreData = detailItemCoreData {
            let html = """
                <html>
                <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0 maximum-scale=1.0 user-scalable=no">
                <style> body { font-size: 130%; } </style>
                <img src="\(detailItemCoreData.value(forKeyPath: "urlToImage") ?? "")" width="100%">
                <h2>\(detailItemCoreData.value(forKeyPath: "title") ?? "")</h2>
                </head>
                <body>
                <h3 align="center">
                \(detailItemCoreData.value(forKeyPath: "sourceName") ?? "")
                </h3>
                <h4 align="center">
                <i>\(detailItemCoreData.value(forKeyPath: "author") ?? "")</i>
                </h4>
                <p>\(detailItemCoreData.value(forKeyPath: "articleDescription") ?? "")</p>
                </body>
                </html>
                """
            
            webView.loadHTMLString(html, baseURL: nil)
            
        }
    }
    
    @objc func shareTapped() {
        if let url = detailItem?.url {
            let items = [URL(string: url)]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            present(ac, animated: true)
        }
        
        if let url = detailItemCoreData?.value(forKeyPath: "articleDescription") {
            let items = [URL(string: url as! String)]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            present(ac, animated: true)
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismiss(animated: false, completion: nil)
    }
}
