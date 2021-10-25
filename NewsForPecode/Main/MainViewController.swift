//
//  MainViewController.swift
//  NewsForPecode
//
//  Created by Wuz Good on 22.10.2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var news: News?
    var articles = [Article]()
    var page = 1
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        refreshNews()
        
    }
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ArticleTableViewCell.nib(), forCellReuseIdentifier: ArticleTableViewCell.identifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        title = "Новини"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"), style: .plain, target: self, action: #selector(filterTapped))
    }
    
   
    @objc func refreshNews() {
        articles.removeAll()
        page = 1
        fetchData(page: 1, refresh: true)
    }
    
    func fetchData(page: Int, refresh: Bool = false) {
        
        if refresh {
            tableView.refreshControl?.beginRefreshing()
            print("refresh")
        }
        
        let params = "q=technology&page=\(page)"

        let urlString = API.URL + params + API.key
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if refresh {
                    self.tableView.refreshControl?.endRefreshing()
                }
                
                if error != nil {
                    print(error.debugDescription)
                    return
                } else if data != nil {
                    do {
                        let newData = try JSONDecoder().decode(News.self, from: data!)
                        print("refresh")
                        self.news = newData
                        self.articles.append(contentsOf: self.news!.articles)
                        self.tableView.reloadData()
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        task.resume()
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed, please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    @objc func filterTapped() {
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == articles.count - 1 {
            page = page + 1
            fetchData(page: page, refresh: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell

        if !articles.isEmpty {
            cell.configure(with: articles[indexPath.row])
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = articles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // MARK: - Swipe Actions
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return favouriteAction(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return favouriteAction(indexPath)
    }
    
    fileprivate func favouriteAction(_ indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Вподобати") { action, view, completion in

            self.save(article: self.articles[indexPath.row])
            completion(true)
        }
        action.image = UIImage(systemName: "star")
        action.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: - Core Data
    
    func save(article item: Article) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CachedArticle", in: managedContext)!
        
        let article = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        article.setValue(item.title, forKeyPath: "title")
        article.setValue(item.description, forKeyPath: "articleDescription")
        article.setValue(item.author, forKeyPath: "author")
        article.setValue(item.url, forKeyPath: "url")
        article.setValue(item.urlToImage, forKeyPath: "urlToImage")
        article.setValue(item.source.name, forKeyPath: "sourceName")
        article.setValue(item.publishedAt, forKeyPath: "publishedAt")

        

        
        do {
            try managedContext.save()
            let vc = FavouriteViewController()
            vc.favouriteNews.append(article)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

