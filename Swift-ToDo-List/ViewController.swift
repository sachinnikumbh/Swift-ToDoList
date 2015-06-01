//
//  ViewController.swift
//  Swift-ToDo-List
//
//  Created by Sachin Nikumbh on 27/05/15.
//  Copyright (c) 2015 SN. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var btnDate: UIButton!
    @IBOutlet var btnTime: UIButton!
    @IBOutlet var btnTimeAmPm: UIButton!
    @IBOutlet var datePicker:UIDatePicker!
    @IBOutlet var btnDone:UIButton!
    @IBOutlet var txtfToDoTitle: UITextField!
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet var switchAlarm: UISwitch!
    
    var toDoRecored : ToDoTable? = nil;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged);
        
        datePicker.datePickerMode = UIDatePickerMode.Date;
        btnDate.setTitle(getCurrentShortDate(datePicker), forState: UIControlState.Normal);
        datePicker.datePickerMode = UIDatePickerMode.Time;
        setTime();
        viewDatePicker.layer.borderColor = UIColor.blueColor().CGColor
        viewDatePicker.layer.borderWidth = 1
        viewDatePicker.layer.cornerRadius = 5
        
        btnDone.addTarget(self, action: "doneBtnPress:", forControlEvents: UIControlEvents.TouchUpInside)
        
        showDatePicker(false);
        txtfToDoTitle.delegate = self;
        txtfToDoTitle.becomeFirstResponder()
        
        datePicker.minimumDate = NSDate()
        
        if toDoRecored != nil
        {
            txtfToDoTitle.text = toDoRecored?.valueForKey("title") as? String;
            btnDate.setTitle(toDoRecored?.valueForKey("date") as? String, forState: UIControlState.Normal);
            
        }

    }
    
    
    func setTime()
    {
        var titleString : String = getCurrentShortDate(datePicker)
        var arrayOfTimeComponents = Array<String>()
        arrayOfTimeComponents = titleString.componentsSeparatedByString("-")
        btnTime.setTitle(arrayOfTimeComponents[0], forState: UIControlState.Normal);
        btnTimeAmPm.setTitle(arrayOfTimeComponents[1], forState: UIControlState.Normal);
    }
    
    func datePickerValueChanged(datePick:UIDatePicker)
    {
        if datePick.datePickerMode == UIDatePickerMode.Time
        {
            setTime()
        }
        else if datePick.datePickerMode == UIDatePickerMode.Date
        {
            btnDate.setTitle(getCurrentShortDate(datePick), forState: UIControlState.Normal)
        }
    }
    
    
    func getCurrentShortDate(datePick:UIDatePicker) -> String {
        var dateFormatter = NSDateFormatter()
        var DateInFormat:String = ""
        
        if datePick.datePickerMode == UIDatePickerMode.Time
        {
            dateFormatter.dateFormat = "h:mm-a"
            DateInFormat = dateFormatter.stringFromDate(datePick.date);
        }
        else if datePick.datePickerMode == UIDatePickerMode.Date
        {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            DateInFormat = dateFormatter.stringFromDate(datePick.date);
        }
        
        return DateInFormat
    }
    
    func doneBtnPress(sender:UIButton)
    {
        showDatePicker(false);
        self.view.endEditing(true)
    }
    
    @IBAction func actionDateBtnPress(sender: AnyObject) {
        datePicker.datePickerMode = UIDatePickerMode.Date;
        
        self.view.endEditing(true)
        showDatePicker(true);
    }
    
    @IBAction func actionTimeBtnPress(sender: AnyObject) {
        datePicker.datePickerMode = UIDatePickerMode.Time;
        
        self.view.endEditing(true)
        showDatePicker(true);
    }
    
    @IBAction func actionTimeAmPmBtnPress(sender: AnyObject) {
        showDatePicker(false)
        if btnTimeAmPm.titleLabel?.text == "AM"
        {
            btnTimeAmPm.setTitle("PM", forState: UIControlState.Normal)
        }
        else
        {
            btnTimeAmPm.setTitle("AM", forState: UIControlState.Normal)
        }
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        showDatePicker(false)
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        showDatePicker(false);
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func showDatePicker(flag : Bool)
    {
        if flag
        {
            UIView.animateWithDuration(0.5, animations: {
                self.viewDatePicker.alpha = 1;
                }, completion: {
                    (value: Bool) in self.viewDatePicker.hidden = false
            })
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.viewDatePicker.alpha = 0;
                }, completion: {
                    (value: Bool) in self.viewDatePicker.hidden = true
            })
        }
    }
    
    @IBAction func actionAlarmToggleChange(sender: UISwitch)
    {
        if sender.on
        {
        }
        else
        {
        }
        showDatePicker(false);
    }
    
    @IBAction func actionSaveBtnPress(sender: AnyObject) {
        
        if validateData()
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let manageObjectContext = appDelegate.managedObjectContext
            let entity = NSEntityDescription.entityForName("ToDoTable", inManagedObjectContext: manageObjectContext!)
            let toDo = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageObjectContext)
            
//            var dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "dd-MM-yyyy"
//            let string = btnDate.titleLabel?.text;
//            let date = dateFormatter.dateFromString(string!)
            
            toDo.setValue(txtfToDoTitle.text, forKey: "title");
            toDo.setValue(btnDate.titleLabel?.text , forKey: "date");
            toDo.setValue(btnTime.titleLabel?.text, forKey: "time");
            toDo.setValue(btnTimeAmPm.titleLabel?.text, forKey: "ampm");
            toDo.setValue(switchAlarm.on,  forKey: "alarm");
            
            var error : NSError?
            
            if !(manageObjectContext?.save(&error) != nil)
            {
                println("Could not save \(error), \(error?.userInfo)")
            }
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func actionCancelBtnPress(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func validateData() -> Bool
    {
        if txtfToDoTitle.text == ""
        {
            showAlert("Alert", message:"Please enter To Do title" , btnTitle: "Okay")
            return false;
        }
        return true
    }
    
    func showAlert(title : String, message : String, btnTitle : String)
    {
        var alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertView.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

