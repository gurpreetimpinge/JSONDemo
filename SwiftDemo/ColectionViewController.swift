//
//  ColectionViewController.swift
//  SwiftDemo
//
//  Created by MacUser on 9/23/16.
//  Copyright © 2016 Impinge Solutions. All rights reserved.
//

import UIKit
import CoreData

class ColectionViewController: UIViewController,UICollectionViewDelegate {

    @IBOutlet var collection_List:UICollectionView!
    
    var ary_List:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection_List.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
            
            collection_List.reloadData()
        }
        catch let error as NSError
        {
            print("could not save: \(error) desc: \(error.description)")
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ary_List.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        for view in cell.contentView.subviews
        {
            view.removeFromSuperview()
        }
        
        let str_Location = String(format: "%@ - %@", ary_List.objectAtIndex(indexPath.row).valueForKey("pickUpLocation")! as! String, ary_List.objectAtIndex(indexPath.row).valueForKey("dropOffLocation")! as! String)
        
        let lbl_Title = UILabel.init(frame: CGRectMake(5, 10, cell.frame.size.width-10, 80))
        lbl_Title.numberOfLines = 3
        lbl_Title.text = str_Location
        lbl_Title.font = UIFont.systemFontOfSize(15)
        cell.contentView.addSubview(lbl_Title)
        
        
        let lbl_Distance = UILabel.init(frame: CGRectMake(5, 100, cell.frame.size.width-10, 40))
        lbl_Distance.text = String(ary_List.objectAtIndex(indexPath.row).valueForKey("distance")!)
        lbl_Distance.font = UIFont.systemFontOfSize(12)
        cell.contentView.addSubview(lbl_Distance)
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width-5)/2, height: 150) // The size of one cell
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
