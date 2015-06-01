//
//  ToDoListViewController.swift
//  Swift-ToDo-List
//
//  Created by Sachin Nikumbh on 28/05/15.
//  Copyright (c) 2015 SN. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate {
    
    @IBOutlet var tableViewToDoList: UITableView!
//    var arrayToDoList = [NSManagedObject]()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController = NSFetchedResultsController();
    
    @IBOutlet var btnEditorDone : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableViewToDoList.registerNib(UINib(nibName: "ToDoListCustomCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ToDoCell");
        
        //        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.tableViewToDoList.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self;
        fetchedResultController.performFetch(nil);
        
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        var fetchedResultContr = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultContr
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "ToDoTable")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    
    override func viewWillAppear(animated: Bool) {
//        fetchedResults()
    }
    
//    func fetchedResults()
//    {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let manageObjectContext = appDelegate.managedObjectContext
//        
//        let fetchRequest = NSFetchRequest(entityName: "ToDoTable")
//        
//        var error : NSError?
//        
//        let fetchedResults = manageObjectContext?.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
//        
//        
//        if let results = fetchedResults {
//            arrayToDoList = results
//        } else {
//            println("Could not fetch \(error), \(error!.userInfo)")
//        }
//        tableViewToDoList.reloadData()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return fetchedResultController.sections!.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return fetchedResultController.sections![section].numberOfObjects;
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ToDoCell"
        
        var cell: ToDoListCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? ToDoListCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "ToDoListCustomCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ToDoListCell
        }
        let objToDo = fetchedResultController.objectAtIndexPath(indexPath) as! ToDoTable
        cell.lblTitle.text = objToDo.valueForKey("title") as? String
        cell.lblDate.text = objToDo.valueForKey("date") as? String
        
        let string1 = objToDo.valueForKey("time") as? String ?? ""
        let string2 = objToDo.valueForKey("ampm") as? String ?? ""
        let appendString = string1+" "+string2
        cell.lblTime.text =  appendString
        
        var flag : Bool? = objToDo.valueForKey("alarm")?.boolValue
        cell.switchAlart.setOn(flag!, animated: true)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainStroryBorad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        var objToDoViewController = mainStroryBorad.instantiateViewControllerWithIdentifier("CreateNewToDo") as! ViewController
        let todo:ToDoTable = fetchedResultController.objectAtIndexPath(indexPath) as! ToDoTable
        objToDoViewController.toDoRecored = todo
        self.navigationController?.pushViewController(objToDoViewController, animated: true)
    }
    
    
    @IBAction func actionAddToDo(sender: AnyObject) {
        let mainStroryBorad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        var objToDoViewController = mainStroryBorad.instantiateViewControllerWithIdentifier("CreateNewToDo") as! ViewController
        self.navigationController?.pushViewController(objToDoViewController, animated: true)
    }
    
    @IBAction func actionEditBtnPress(sender: AnyObject)
    {
        if self.tableViewToDoList.editing
        {
            self.tableViewToDoList.setEditing(false, animated: true)
        }
        else
        {
            self.tableViewToDoList.setEditing(true, animated: true)
        }
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    
    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
