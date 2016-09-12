//
//  ViewController.swift
//  PostsApp
//
//  Created by vicente rodriguez on 8/8/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, PostsAPIProtocol, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var postsAPI: PostsAPI = PostsAPI()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsAPI.delegate = self
        postsAPI.getPosts()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didGetPosts(posts: [Post]) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.posts.appendContentsOf(posts)
            self.tableView.reloadData()
        }
    }
    
    func errorInRequest(error: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "Error creating post", message: "\(error)", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            }))
            
            alert.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (action) in
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }))
            
            self.presentViewController(alert, animated: true, completion: {
            })
        }
    }
    
    func didCreatePost(post: Post) {
        dispatch_async(dispatch_get_main_queue()) {
            self.posts.append(post)
            self.tableView.reloadData()
        }
    }
    
    func didUpdatePost(post: Post) {
        dispatch_async(dispatch_get_main_queue()) {
            let index = self.tableView.indexPathForSelectedRow!
            self.posts[index.row] = post
            self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Fade)
        }
    }
    
    func loginRequired() {
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController(title: "Fail creating post", message: "You need logIn", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            })
    }
    
    @IBAction func createPost(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create post", message: "Write yor post", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            let title = alertController.textFields![0] as UITextField
            let body = alertController.textFields![1] as UITextField
            self.postsAPI.createPost(title.text!, body: body.text!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title: "
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Body: "
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updatePost(post: Post) {
        let alertController = UIAlertController(title: "Update post", message: "Write yor post", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            let title = alertController.textFields![0] as UITextField
            let body = alertController.textFields![1] as UITextField
            let newPost = Post(id: post.id, title: title.text!, body: body.text!)
            self.postsAPI.updatePost(post.id, post: newPost)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title: "
            textField.text = post.title
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Body: "
            textField.text = post.body
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deletePost(row: Int) {
        dispatch_async(dispatch_get_main_queue()) {
            let index = NSIndexPath(forRow: row, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Right)
            self.posts.removeAtIndex(row)
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postsCell", forIndexPath: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = posts[indexPath.row]
        updatePost(post)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, index) in
            let post = self.posts[indexPath.row]
            self.postsAPI.deletePost(post.id, row: indexPath.row)
        }
        delete.backgroundColor = UIColor.redColor()
        return [delete]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

