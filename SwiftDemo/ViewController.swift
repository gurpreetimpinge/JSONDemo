//
//  ViewController.swift
//  SwiftDemo
//
//  Created by MacUser on 9/23/16.
//  Copyright © 2016 Impinge Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData



class ViewController: UIViewController {
    
    @IBOutlet var txt_PickUp:UITextField!
    @IBOutlet var txt_DropOff:UITextField!
    @IBOutlet var btn_Save:UIButton!
    var activity:UIActivityIndicatorView!
    var pickUpLocation:CLLocation!
    var dropOffLocation:CLLocation!
    var distance:CLLocationDistance=0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func calculateDistance()
    {
        let geocoder = CLGeocoder()
        
        
        geocoder.geocodeAddressString(self.txt_PickUp.text!,completionHandler:{ (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if (placemarks?.count>0)
            {
                let topResult = placemarks![0]
                let coordinatePickUp = CLLocationCoordinate2DMake(topResult.location!.coordinate.latitude, topResult.location!.coordinate.longitude)
                self.pickUpLocation = CLLocation(latitude: coordinatePickUp.latitude, longitude: coordinatePickUp.longitude)
                
                geocoder.geocodeAddressString(self.txt_DropOff.text!,completionHandler:{ (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                    
                    if (placemarks?.count>0)
                    {
                        let topResult = placemarks![0]
                        let coordinateDropOff = CLLocationCoordinate2DMake(topResult.location!.coordinate.latitude, topResult.location!.coordinate.longitude)
                        self.dropOffLocation = CLLocation(latitude: coordinateDropOff.latitude, longitude: coordinateDropOff.longitude)
                        
                        self.distance = self.pickUpLocation!.distanceFromLocation(self.dropOffLocation!)
                        
                        var int_Distance = Float(self.distance)
                        
                        self.saveDistanceInfo(int_Distance)
                    }
                    else
                    {
                        self.activity.stopAnimating()
                        print("incorrect destination address")
                    }
         
                })
            }
            else
            {
                self.activity.stopAnimating()
                print("incorrect source address")
            }
            
        })
       
        
    }
    
    @IBAction func validateValues()
    {
        if (txt_PickUp.text?.characters.count==0)
        {
            print("enter pickup address")
        }
        else if (txt_DropOff.text?.characters.count==0)
        {
            print("enter dropoff address")
        }
        else
        {
            activity = UIActivityIndicatorView.init(frame: CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 20, 20))
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            activity.hidesWhenStopped = true
            self.view .addSubview(activity)
            activity .startAnimating()
            
            self.calculateDistance()
        }
    }
    
    func saveDistanceInfo(totalDistance:Float)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managenedContext = appDelegate.managedObjectContext
        
        let distance:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("CalculateDistance", inManagedObjectContext: managenedContext)
        
        
        distance.setValue(txt_PickUp.text!, forKey: "pickUpLocation")
        distance.setValue(txt_DropOff.text!, forKey: "dropOffLocation")
        distance.setValue(totalDistance, forKey: "distance")
        
        do
        {
            try managenedContext.save()
            self.activity.stopAnimating()
            print("save")
            
        }
        catch let error as NSError
        {
            self.activity.stopAnimating()
            print("could not save: \(error) desc: \(error.description)")
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

