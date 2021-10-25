//
//  ArticleTableViewCell.swift
//  News
//
//  Created by Wuz Good on 23.10.2021.
//

import UIKit
import CoreData

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    static let identifier = "ArticleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ArticleTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with model: Article) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        sourceLabel.text = model.source.name
        authorLabel.text = model.author
        
        if let urlToImage = model.urlToImage {
            let url = URL(string: urlToImage)!
            load(url: url)
        }
    }
    
    func configure(with managedObject: NSManagedObject) {
        titleLabel.text = managedObject.value(forKeyPath: "title") as? String
        descriptionLabel.text = managedObject.value(forKeyPath: "articleDescription") as? String
        sourceLabel.text = managedObject.value(forKeyPath: "sourceName") as? String
        authorLabel.text = managedObject.value(forKeyPath: "author") as? String
        
        if let urlToImage = managedObject.value(forKeyPath: "urlToImage") as? String {
            let url = URL(string: urlToImage)!
            load(url: url)
        }
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let imageData = UIImage(data: data)?.jpegData(compressionQuality: 0.5) {
                    DispatchQueue.main.async {
                        self?.newsImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
