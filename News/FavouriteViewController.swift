//
//  FavouriteViewController.swift
//  News
//
//  Created by Wuz Good on 24.10.2021.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    var favouriteNews = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ArticleTableViewCell.nib(), forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "CachedArticle")
        
        
        do {
            favouriteNews = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        
        
        cell.configure(with: favouriteNews[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
                
        vc.detailItemCoreData = favouriteNews[indexPath.row]
                
        navigationController?.pushViewController(vc, animated: true)
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
        let action = UIContextualAction(style: .destructive, title: "Видалити") { action, view, completionHandler in
            
            let favouriteArticle = self.favouriteNews[indexPath.row]
            self.context.delete(favouriteArticle)
            
            self.contextSave()
            
            self.favouriteNews.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func contextSave() {
        do {
            try self.context.save()
        }
        catch {
            print("Saving error.")
        }
    }
}
