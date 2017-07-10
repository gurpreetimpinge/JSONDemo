//
//  TableViewController.swift
//  SwiftDemo
//
//  Created by MacUser on 9/23/16.
//  Copyright © 2016 Impinge Solutions. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController,UITableViewDelegate {

    @IBOutlet var tbl_List:UITableView!
    
    var ary_List:NSMutableArray = NSMutableArray()
    let info:NSManagedObject = NSManagedObject()
    var int_SelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl_List.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.getInfoFormDB()
    }
    
    func getInfoFormDB()
    {
        ary_List.removeAllObjects()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managenedContext = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "CalculateDistance")
        
        do
        {
            let result = try managenedContext.executeFetchRequest(fetch)
            
            let infoObject = result as! [NSManagedObject]
            
            for info in infoObject {
                
                ary_List.addObject(info)
            }
            
            tbl_List.reloadData()
        }
        catch let error as NSError
        {
            print("could not save: \(error) desc: \(error.description)")
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ary_List.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CellSubtitle")
        
        if (cell == nil)
        {
             cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellSubtitle")
        }
        
        for view in cell!.contentView.subviews
        {
            view.removeFromSuperview()
        }
        
        let str_Location = String(format: "%@ - %@", ary_List.objectAtIndex(indexPath.row).valueForKey("pickUpLocation")! as! String, ary_List.objectAtIndex(indexPath.row).valueForKey("dropOffLocation")! as! String)
        
        let lbl_Title = UILabel.init(frame: CGRectMake(5, 5, cell!.frame.size.width-10, 40))
        lbl_Title.numberOfLines = 2
        lbl_Title.text = str_Location
        lbl_Title.font = UIFont.systemFontOfSize(15)
        cell!.contentView.addSubview(lbl_Title)
        
        
        let lbl_Distance = UILabel.init(frame: CGRectMake(5, 50, cell!.frame.size.width-10, 20))
        lbl_Distance.text = String(ary_List.objectAtIndex(indexPath.row).valueForKey("distance")!)
        lbl_Distance.font = UIFont.systemFontOfSize(12)
        cell!.contentView.addSubview(lbl_Distance)
    
//        cell!.textLabel?.text = String(ary_List.objectAtIndex(indexPath.row).valueForKey("pickUpLocation")!)+"-"+String(ary_List.objectAtIndex(indexPath.row).valueForKey("dropOffLocation")!)
//        cell!.detailTextLabel?.text = String(ary_List.objectAtIndex(indexPath.row).valueForKey("distance")!)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managenedContext = appDelegate.managedObjectContext
        
        managenedContext.deleteObject(ary_List.objectAtIndex(indexPath.row) as! NSManagedObject)
        
        
        do
        {
            try managenedContext.save()
            ary_List.removeObjectAtIndex(indexPath.row)
            
            tableView .deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
        catch
        {
            print("not deleted")
        }
        
    }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        int_SelectedIndex = indexPath.row as Int
        self.performSegueWithIdentifier("NavigateToAboutUs", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NavigateToAboutUs"
        {
            let vc = segue.destinationViewController as! AboutUsVC
            let str = String(ary_List.objectAtIndex(int_SelectedIndex).valueForKey("distance")!)
            vc.str_Title = String(format: "%@\n%@\n%@", ary_List.objectAtIndex(int_SelectedIndex).valueForKey("pickUpLocation")! as! String, ary_List.objectAtIndex(int_SelectedIndex).valueForKey("dropOffLocation")! as! String, str)

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
