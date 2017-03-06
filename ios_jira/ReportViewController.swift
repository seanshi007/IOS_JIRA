//
//  ReportViewController.swift
//  ios_jira
//
//  Created by sean on 16/2/4.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit
import AssetsLibrary

class ReportViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var FixVersionButton: UIButton!
    @IBOutlet weak var AffectVersionButton: UIButton!
    @IBOutlet weak var PriorityButton: UIButton!
    @IBOutlet weak var ProjectButton: UIButton!
    @IBAction func PriorityButtonPressed(sender: AnyObject) {
        if (ProjectSelector.hidden == false) {
            ProjectSelector.hidden = true
        }
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        BigView.bringSubviewToFront(PrioritySelctor)
        PrioritySelctor.hidden = false
    }
    @IBAction func ProjectButtonPressed(sender: AnyObject) {
        lastProject = (ProjectButton.titleLabel?.text)!
        //VersionArray.removeAll()
        if (PrioritySelctor.hidden == false) {
            PrioritySelctor.hidden = true
        }
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        BigView.bringSubviewToFront(ProjectSelector)
        ProjectSelector.hidden = false
    }
    var username:String!
    var Auth:String!
    
    @IBAction func FixVersionButtonPressed(sender: AnyObject) {
        if (lastProject != ProjectButton.titleLabel?.text) {
            VersionArray.removeAll()
            VersionIdArray.removeAll()
            self.getVersions()
        }
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        BigView.bringSubviewToFront(FixVersionSelector)
        FixVersionSelector.hidden = false
        print(VersionArray.count)
    }
    @IBAction func AffectVersionButtonPressed(sender: AnyObject) {
        if (lastProject != ProjectButton.titleLabel?.text) {
            VersionArray.removeAll()
            VersionIdArray.removeAll()
            self.getVersions()
        }
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        BigView.bringSubviewToFront(AffectVersionSelector)
        AffectVersionSelector.hidden = false
        print(VersionArray.count)
    }
    
    @IBOutlet weak var BigView: UIView!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var UserNameButton: UIButton!
    @IBOutlet weak var CommitButton: UIButton!
    @IBOutlet weak var PhotoButton: UIButton!
    
    @IBOutlet weak var AffectVersionSelector: UIPickerView!
    @IBOutlet weak var FixVersionSelector: UIPickerView!
    
    @IBAction func UserButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(1, delay:0.01,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
                ()-> Void in
                //在动画中，数字块有一个角度的旋转。
                self.UserNameButton.backgroundColor = UIColor.orangeColor()
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(1, animations:{
                    ()-> Void in
                    //完成动画时，数字块复原
                    self.UserNameButton.backgroundColor = UIColor.darkGrayColor()
                })
        })
        if #available(iOS 8.0, *) {
            var alert3: UIAlertController!
            var cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            var changeUserAction = UIAlertAction(title: "change user", style: UIAlertActionStyle.Default) {
                (action: UIAlertAction!) -> Void in
                isBack = true
                self.goBack()
            }
            var exitAction = UIAlertAction(title: "exit", style: UIAlertActionStyle.Default) {
                (action: UIAlertAction!) -> Void in
                exit(0)
            }
            
            alert3 = UIAlertController(title: "settings", message: "settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert3.addAction(changeUserAction)
            alert3.addAction(exitAction)
            alert3.addAction(cancelAction)
            
            self.presentViewController(alert3, animated: true, completion: nil)
        } else {
            //old version
            var alert3 = UIAlertView()
            alert3.title = "settings"
            alert3.message = "settings"
            alert3.delegate = self
            alert3.addButtonWithTitle("change user")
            alert3.addButtonWithTitle("exit")
            alert3.addButtonWithTitle("cancel")
            dispatch_async(dispatch_get_main_queue(), {
                alert3.show()
            })
            //alert3.show()
        }
        
    }
    @IBOutlet weak var summary: UITextField!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var MyScrollView: UIScrollView!
    @IBOutlet weak var ProjectSelector: UIPickerView!
    @IBOutlet weak var PrioritySelctor: UIPickerView!
    
    var ProjectDataSource = ["JIRA测试","IOS词典","IOS翻译官","考研APP","课程APP","口语大师","模考项目软件","惠惠IOS","云笔记IOS","课程项目"]
    var PriorityDataSource = ["Major", "Blocker", "Critical", "Minor", "Trivial"]
    var assigneeArray:[String!] = []
    var VersionArray:[String!] = []
    var VersionIdArray:[String!] = []
    var priority_id:Int = 3
    var project_id:String = "JIRATEST"
    var deviceName:String = ""
    var operatingSystem:String = ""
    var imageName:String = ""
    var takePic:Bool = false
    var lastProject = ""
    var id1:String = ""
    var id2:String = ""
    
    var assignee = AutoCompleteTextField(frame: CGRect(x: 8, y: 230, width: 304, height: 30))
    
    let ISSUETYPE = "Bug"
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        if (alertView.title == "settings") {
            switch (buttonIndex) {
            case 0:
                isBack = true
                self.goBack()
                break
            case 1:
                exit(0)
                break
            case 2:
                break
            default: break
            }
        }
        if (alertView.title == "Photo") {
            switch (buttonIndex) {
            case 0:
                var c = UIImagePickerController()
                c.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                c.delegate = self
                self.presentViewController(c, animated: true, completion: nil)
                break
            case 1:
                self.takePic = true
                var c = UIImagePickerController()
                c.sourceType = UIImagePickerControllerSourceType.Camera
                c.delegate = self
                self.presentViewController(c, animated: true, completion: nil)
                break
            case 2:
                break
            default: break
            }
        }
        if (alertView.title == "Blank Error") {
            switch (buttonIndex) {
            case 0:
                break
            default: break
            }
        }
        if (alertView.title == "Commit Error") {
            switch (buttonIndex) {
            case 0:
                break
            default: break
            }
        }
        if (alertView.title == "Confirm") {
            switch (buttonIndex) {
            case 0:
                self.summary.text = ""
                self.descriptionText.text = ""
                self.assignee.text = ""
                self.iv.image = nil
                
                summary.text = "【】"
                summary.becomeFirstResponder()
                let arbitraryValue: Int = 1
                let newPosition = summary.positionFromPosition(summary.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: arbitraryValue)
                summary.selectedTextRange = summary.textRangeFromPosition(newPosition!, toPosition: newPosition!)
                break
            default: break
            }
        }
        if (alertView.title == "Warning") {
            switch (buttonIndex) {
            case 0:
                break
            default: break
            }
        }
        if (alertView.title == "Session Out of Date") {
            switch (buttonIndex) {
            case 0:
                self.goBack()
                break
            default: break
            }
        }
    }
    
    @IBAction func GetPhotoPressed(sender: AnyObject) {
        UIView.animateWithDuration(1, delay:0.01,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
                ()-> Void in
                //在动画中，数字块有一个角度的旋转。
                self.PhotoButton.backgroundColor = UIColor.orangeColor()
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(1, animations:{
                    ()-> Void in
                    //完成动画时，数字块复原
                    self.PhotoButton.backgroundColor = UIColor.darkGrayColor()
                })
        })
        if #available(iOS 8.0, *) {
            var alert1: UIAlertController!
            var cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            var albumAction = UIAlertAction(title: "choose from album", style: UIAlertActionStyle.Default){
                (action: UIAlertAction!) -> Void in
                var c = UIImagePickerController()
                c.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                c.delegate = self
                self.presentViewController(c, animated: true, completion: nil)
                
            }
            var takePhotoAction = UIAlertAction(title: "take a picture", style: UIAlertActionStyle.Default){
                (action: UIAlertAction!) -> Void in
                self.takePic = true
                
                var c = UIImagePickerController()
                c.sourceType = UIImagePickerControllerSourceType.Camera
                c.delegate = self
                self.presentViewController(c, animated: true, completion: nil)
            }
            
            alert1 = UIAlertController(title: "Photo", message: "Choose a bug photo to submit", preferredStyle: UIAlertControllerStyle.Alert)
            alert1.addAction(cancelAction)
            alert1.addAction(albumAction)
            alert1.addAction(takePhotoAction)
            
            self.presentViewController(alert1, animated: true, completion: nil)
        } else {
            //old
            
            var alert1 = UIAlertView()
            alert1.title = "Photo"
            alert1.message = "Choose a bug photo to submit"
            alert1.delegate = self
            alert1.addButtonWithTitle("choose from album")
            alert1.addButtonWithTitle("take a picture")
            alert1.addButtonWithTitle("cancel")
            dispatch_async(dispatch_get_main_queue(), {
                alert1.show()
            })
            //alert1.show()
        }
    }
    
    @IBAction func CommitButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(1, delay:0.01,
            options:UIViewAnimationOptions.TransitionNone, animations:
            {
                ()-> Void in
                //在动画中，数字块有一个角度的旋转。
                self.CommitButton.backgroundColor = UIColor.orangeColor()
            },
            completion:{
                (finished:Bool) -> Void in
                UIView.animateWithDuration(1, animations:{
                    ()-> Void in
                    //完成动画时，数字块复原
                    self.CommitButton.backgroundColor = UIColor.darkGrayColor()
                })
        })
        self.isConnected()
        if (!connected) {
            if #available(iOS 8.0, *) {
                var alert4: UIAlertController
                
                let returnAction = UIAlertAction(title: "got it", style: UIAlertActionStyle.Default) {
                    (action: UIAlertAction!) -> Void in
                    self.goBack()
                }
                
                alert4 = UIAlertController(title: "Session Out of Date", message: "Session out of date, login again please", preferredStyle: UIAlertControllerStyle.Alert)
                alert4.addAction(returnAction)
                presentViewController(alert4, animated: true, completion: nil)
            } else {
                //old
                var alert4 = UIAlertView()
                alert4.title = "Session Out of Date"
                alert4.message = "Session out of date, login again please"
                alert4.delegate = self
                alert4.addButtonWithTitle("Ok")
                dispatch_async(dispatch_get_main_queue(), {
                    alert4.show()
                })
                //alert4.show()
            }
        }
        
        getVersionIDs()
        
        if (summary.text == "" || descriptionText.text == "" || assignee.text == "") {
            if #available(iOS 8.0, *) {
                var alert4: UIAlertController
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
                
                alert4 = UIAlertController(title: "Blank Error", message: "You've got some textfield blank, please fill it", preferredStyle: UIAlertControllerStyle.Alert)
                alert4.addAction(cancelAction)
                presentViewController(alert4, animated: true, completion: nil)
            } else {
                //old
                var alert4 = UIAlertView()
                alert4.title = "Blank Error"
                alert4.message = "You've got some textfield blank, please fill it"
                alert4.delegate = self
                alert4.addButtonWithTitle("got it")
                dispatch_async(dispatch_get_main_queue(), {
                    alert4.show()
                })
                //alert4.show()
            }
            return
        }
        
        choosePriority()
        chooseProject()
        getDeviceInfo()
        //getVersionIDs()
        
        /*if let index1 = VersionArray.indexOf({$0 == AffectVersionButton.titleLabel?.text}) {
        id1 = VersionIdArray[index1]
        }
        if let index2 = VersionIdArray.indexOf({$0 == FixVersionButton.titleLabel?.text}) {
        id2 = VersionIdArray[index2]
        }*/
        
        var fields = [String : AnyObject]()
        
        if (id1 == "" || id2 == "") {
            fields = [
                "project":
                    ["key":project_id],
                "issuetype":
                    ["name":ISSUETYPE],
                "priority":
                    ["id":String(priority_id)],
                "summary":summary.text!,
                "description":descriptionText.text!,
                "assignee":
                    ["name":assignee.text!],
                "environment":deviceName+"\n"+operatingSystem+"\n\n"+"report by IOS BugEase"
            ]
        } else {
            
            fields = [
                "project":
                    ["key":project_id],
                "issuetype":
                    ["name":ISSUETYPE],
                "priority":
                    ["id":String(priority_id)],
                "summary":summary.text!,
                "description":descriptionText.text!,
                "versions":[
                    ["id":(id1)]],
                "fixVersions":[
                    ["id":(id2)]],
                "assignee":
                    ["name":assignee.text!],
                "environment":deviceName+"\n"+operatingSystem+"\n\n"+"report by IOS BugEase"
            ]
        }
        
        let reportObj : [String : AnyObject] = ["fields":fields]
        
        var jsondata = try? NSJSONSerialization.dataWithJSONObject(reportObj, options: NSJSONWritingOptions())
        //var jsonData = try? NSJSONSerialization.dataWithJSONObject(fields, options: NSJSONWritingOptions(rawValue: 0))
        var str3 = NSString(data: jsondata!, encoding: NSUTF8StringEncoding)
        print(str3)
        
        var req = NSMutableURLRequest(URL: NSURL(string: "http://jira.corp.youdao.com/rest/api/2/issue/")!)
        req.HTTPMethod = "POST"
        req.HTTPBody = jsondata
        //req.addValue(Cookie, forHTTPHeaderField: "cookie")
        req.addValue((NSUserDefaults.standardUserDefaults().valueForKey("sessionName") as! String!) + "=" + (NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") as! String!), forHTTPHeaderField: "cookie")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print(jsondata)
        
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue(), completionHandler:
            { (response, data, error) -> Void in
                if let e = error {
                    print(response)
                } else {
                    print(response)
                }
                
                var d = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(d)
                
                let httpResponse = response as! NSHTTPURLResponse
                print(httpResponse.statusCode)
                
                if (httpResponse.statusCode == 201) {
                    
                    let json : AnyObject! = try? NSJSONSerialization
                        .JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments)
                    let key : AnyObject = json.objectForKey("key")!
                    print("key" + (key as! String))
                    
                    if (self.iv.image != nil) {
                        self.uploadPic(key as! String)
                    } else {
                        if #available(iOS 8.0, *) {
                            var alert2: UIAlertController!
                            var okAction = UIAlertAction(title: "confirm", style: UIAlertActionStyle.Default) {
                                (action: UIAlertAction!) -> Void in
                                self.summary.text = ""
                                self.descriptionText.text = ""
                                self.assignee.text = ""
                                self.iv.image = nil
                                self.id1 = ""
                                self.id2 = ""
                                self.AffectVersionButton.setTitle("Please Select", forState: UIControlState.Normal)
                                self.FixVersionButton.setTitle("Please Select", forState: UIControlState.Normal)
                                self.summary.text = "【】"
                                self.summary.becomeFirstResponder()
                                let arbitraryValue: Int = 1
                                let newPosition = self.summary.positionFromPosition(self.summary.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: arbitraryValue)
                                self.summary.selectedTextRange = self.summary.textRangeFromPosition(newPosition!, toPosition: newPosition!)
                            }
                            alert2 = UIAlertController(title: "commit success", message: "you've successfully commit a bug", preferredStyle: UIAlertControllerStyle.Alert)
                            alert2.addAction(okAction)
                            
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                self.presentViewController(alert2, animated: true, completion: nil)
                            })
                        }
                        else {
                            // old
                            var alert2 = UIAlertView()
                            alert2.title = "Confirm"
                            alert2.message = "you've successfully commit a bug"
                            alert2.delegate = self
                            alert2.addButtonWithTitle("confrim")
                            dispatch_async(dispatch_get_main_queue(), {
                                alert2.show()
                            })
                            //alert2.show()
                        }
                    }
                    
                    //dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    //    self.presentViewController(self.alert2, animated: true, completion: nil)
                    //})
                    
                } else {
                    
                    if #available(iOS 8.0, *) {
                        var alert4: UIAlertController
                        
                        let cancelAction = UIAlertAction(title: "got it", style: UIAlertActionStyle.Cancel, handler: nil)
                        
                        alert4 = UIAlertController(title: "Commit Error", message: "Commit failed, please double check the contents", preferredStyle: UIAlertControllerStyle.Alert)
                        alert4.addAction(cancelAction)
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            self.presentViewController(alert4, animated: true, completion: nil)
                        })
                    } else {
                        //old
                        var alert4 = UIAlertView()
                        alert4.title = "Commit Error"
                        alert4.message = "Commit failed, please double check the contents"
                        alert4.delegate = self
                        alert4.addButtonWithTitle("got it")
                        dispatch_async(dispatch_get_main_queue(), {
                            alert4.show()
                        })
                        //alert4.show()
                    }
                }
                
        })
        
        
    }
    
    func getVersionIDs() {
        if let index1 = self.VersionArray.indexOf({$0 == self.AffectVersionButton.titleLabel?.text}) {
            print(index1)
            self.id1 = self.VersionIdArray[index1]
        }
        if let index2 = self.VersionArray.indexOf({$0 == self.FixVersionButton.titleLabel?.text}) {
            print(index2)
            self.id2 = self.VersionIdArray[index2]
        }
        /*dispatch_sync(dispatch_get_main_queue(), { () -> Void in
        if let index1 = self.VersionArray.indexOf({$0 == self.AffectVersionButton.titleLabel?.text}) {
        print(index1)
        self.id1 = self.VersionIdArray[index1]
        }
        if let index2 = self.VersionIdArray.indexOf({$0 == self.FixVersionButton.titleLabel?.text}) {
        print(index2)
        self.id2 = self.VersionIdArray[index2]
        }
        })*/
    }
    
    func uploadPic(issueKey : String) {
        let url = NSURL(string: "http://jira.corp.youdao.com/rest/api/2/issue/"+issueKey+"/attachments")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        //request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue("no-check", forHTTPHeaderField: "X-Atlassian-Token")
        request.addValue((NSUserDefaults.standardUserDefaults().valueForKey("sessionName") as! String!) + "=" + (NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") as! String!), forHTTPHeaderField: "cookie")
        //request.addValue(Cookie, forHTTPHeaderField: "cookie")
        request.addValue("utf-8", forHTTPHeaderField: "Charset")
        
        //request.addValue("Basic "+Auth, forHTTPHeaderField: "Authorization")
        //let data = UIImagePNGRepresentation(iv.image!)
        let data = UIImageJPEGRepresentation(iv.image!, 0.8)
        print(data?.length)
        print(imageName)
        
        var boundary:String="----5265"
        var contentType:String="multipart/form-data;boundary="+boundary
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        var body=NSMutableData()
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"file\";filename=\"\(imageName)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data!)
        body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody=body
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: { (resp:NSURLResponse?, data, error) -> Void in
            
            print(resp)
            var d = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(d)
            
            let httpResponse = resp as! NSHTTPURLResponse
            print(httpResponse.statusCode)
            
            if (httpResponse.statusCode == 200) {
                
                if #available(iOS 8.0, *) {
                    var alert2: UIAlertController!
                    var okAction = UIAlertAction(title: "confirm", style: UIAlertActionStyle.Default) {
                        (action: UIAlertAction!) -> Void in
                        self.summary.text = ""
                        self.descriptionText.text = ""
                        self.assignee.text = ""
                        self.iv.image = nil
                        self.id1 = ""
                        self.id2 = ""
                        self.AffectVersionButton.setTitle("Please Select", forState: UIControlState.Normal)
                        self.FixVersionButton.setTitle("Please Select", forState: UIControlState.Normal)
                        self.summary.text = "【】"
                        self.assigneeArray.removeAll()
                        self.summary.becomeFirstResponder()
                        let arbitraryValue: Int = 1
                        let newPosition = self.summary.positionFromPosition(self.summary.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: arbitraryValue)
                        self.summary.selectedTextRange = self.summary.textRangeFromPosition(newPosition!, toPosition: newPosition!)
                    }
                    alert2 = UIAlertController(title: "commit success", message: "you've successfully commit a bug", preferredStyle: UIAlertControllerStyle.Alert)
                    alert2.addAction(okAction)
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert2, animated: true, completion: nil)
                    })
                } else {
                    // old
                    var alert2 = UIAlertView()
                    alert2.title = "Confirm"
                    alert2.message = "you've successfully commit a bug"
                    alert2.delegate = self
                    alert2.addButtonWithTitle("confrim")
                    dispatch_async(dispatch_get_main_queue(), {
                        alert2.show()
                    })
                    //alert2.show()
                }
                
            } else {
                if #available(iOS 8.0, *) {
                    var alert4: UIAlertController
                    
                    let cancelAction = UIAlertAction(title: "got it", style: UIAlertActionStyle.Cancel, handler: nil)
                    
                    alert4 = UIAlertController(title: "Warning", message: "Upload picture failed, but other contents commit success", preferredStyle: UIAlertControllerStyle.Alert)
                    alert4.addAction(cancelAction)
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alert4, animated: true, completion: nil)
                    })
                } else {
                    //old
                    var alert2 = UIAlertView()
                    alert2.title = "Warning"
                    alert2.message = "Upload picture failed, but other contents commit success"
                    alert2.delegate = self
                    alert2.addButtonWithTitle("got it")
                    dispatch_async(dispatch_get_main_queue(), {
                        alert2.show()
                    })
                    //alert2.show()
                }
                
            }
        })
        
        
        
    }
    
    func getDeviceInfo() {
        let deviceName = UIDevice.currentDevice().name
        let systemVersion = UIDevice.currentDevice().systemVersion
        //let ntc:NetworkController = NetworkController.sharedInstance()
        //let imei:String? = ntc.IMEI
        print(deviceName)
        print(systemVersion)
        
        self.deviceName = "设备名称："+deviceName
        self.operatingSystem = "系统版本："+systemVersion
    }
    
    func chooseProject() {
        //switch(ProjectDataSource[ProjectSelector.selectedRowInComponent(0)]) {
        switch((ProjectButton.titleLabel?.text)! as String) {
        case "JIRA测试":
            project_id = "JIRATEST"
            break
        case "IOS词典":
            project_id = "IOSDICT"
            break
        case "IOS翻译官":
            project_id = "TRANSIOS"
            break
        case "考研APP":
            project_id = "POSTGRAD"
            break
        case "课程APP":
            project_id = "CLASSAPP"
            break
        case "口语大师":
            project_id = "ILT"
            break
        case "模考项目软件":
            project_id = "EXAM"
            break
        case "惠惠IOS":
            project_id = "HHIOS"
            break
        case "云笔记IOS":
            project_id = "YNIOS"
            break
        case "课程项目":
            project_id = "BISHENG"
            break
        default:
            project_id = "JIRATEST"
        }
    }
    
    func choosePriority() {
        //switch(PriorityDataSource[PrioritySelctor.selectedRowInComponent(0)]) {
        switch((PriorityButton.titleLabel?.text)! as String) {
        case "Major":
            priority_id = 3
            break
        case "Blocker":
            priority_id = 1
            break
        case "Critical":
            priority_id = 2
            break
        case "Minor":
            priority_id = 4
            break
        case "Trivial":
            priority_id = 5
            break
        default:
            priority_id = 3
        }
    }
    
    override func viewDidLayoutSubviews() {
        MyScrollView.contentSize = CGSize(width: BigView.frame.size.width, height: BigView.frame.size.height*1.4)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        MyScrollView.contentSize = CGSize(width: BigView.frame.size.width, height: BigView.frame.size.height*1.6)
        //MyScrollView.setContentOffset(CGPoint.zero, animated: true)
        
        summary.becomeFirstResponder()
        let arbitraryValue: Int = 1
        let newPosition = summary.positionFromPosition(summary.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: arbitraryValue)
        summary.selectedTextRange = summary.textRangeFromPosition(newPosition!, toPosition: newPosition!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.scrollEnabled = true
        
        //view.addSubview(MyScrollView)
        //MyScrollView.addSubview(BigView)
        //MyScrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        self.getVersions()
        
        lastProject = (ProjectButton.titleLabel?.text)!
        
        self.ProjectSelector.hidden = true
        self.PrioritySelctor.hidden = true
        self.AffectVersionSelector.hidden = true
        self.FixVersionSelector.hidden = true
        
        assignee.borderStyle = UITextBorderStyle.RoundedRect
        
        summary.text = "【】"
        
        assignee.text = ""
        
        BigView.addSubview(assignee)
        
        //print(username)
        UserNameButton.setTitle("\(username)", forState: UIControlState.Normal)
        
        self.PrioritySelctor.dataSource = self
        self.PrioritySelctor.delegate = self
        self.PrioritySelctor.tag = 2
        self.ProjectSelector.dataSource = self
        self.ProjectSelector.delegate = self
        self.ProjectSelector.tag = 1
        self.AffectVersionSelector.dataSource = self
        self.AffectVersionSelector.delegate = self
        self.AffectVersionSelector.tag = 3
        self.FixVersionSelector.dataSource = self
        self.FixVersionSelector.delegate = self
        self.FixVersionSelector.tag = 4
        
        configureTextField()
        handleTextFieldInterfaces()
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        iv.image = image
        
        if (takePic) {
            ALAssetsLibrary().writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!,
                completionBlock:{ (path:NSURL!, error:NSError!) -> Void in
                    print(path)
                    self.imageName = path.lastPathComponent!
                    print(self.imageName)
                    print("haha")
            })
            
            takePic = false
        } else {
            
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            print(imageURL)
            imageName = imageURL.lastPathComponent!
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //保存图片方法
    func savePicture(infodic:NSDictionary){
        
        //拍摄的原始图片
        let originalImage:UIImage?
        let savedImage:UIImage?
        //从字典中获取键值UIImagePickerControllerOriginalImage的值，它直接包含了图片数据
        originalImage = infodic["UIImagePickerControllerOriginalImage"] as? UIImage
        
        savedImage = originalImage
        
        //保存图片到用户的相机胶卷中
        UIImageWriteToSavedPhotosAlbum(savedImage!, nil, nil, nil)
    }
    
    private func configureTextField(){
        //assignee
        assignee.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        assignee.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        assignee.autoCompleteCellHeight = 35.0
        assignee.maximumAutoCompleteCount = 20
        assignee.hidesWhenSelected = true
        assignee.hidesWhenEmpty = true
        assignee.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        assignee.autoCompleteAttributes = attributes
        
    }
    
    private func handleTextFieldInterfaces(){
        assignee.onTextChange = {[weak self] text in
            if !text.isEmpty{
                self?.assigneeArray.removeAll()
                var urlString = "http://jira.corp.youdao.com/rest/api/2/user/assignable/search?"
                self!.chooseProject()
                urlString = urlString+"username="+self!.assignee.text!+"&project="+self!.project_id
                print(urlString)
                let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                if url != nil{
                    let urlRequest = NSMutableURLRequest(URL: url!)
                    urlRequest.HTTPMethod = "GET"
                    
                    if (NSUserDefaults.standardUserDefaults().valueForKey("sessionName") == nil) {
                        //connected = false
                        if #available(iOS 8.0, *) {
                            var alert4: UIAlertController
                            
                            let returnAction = UIAlertAction(title: "got it", style: UIAlertActionStyle.Default) {
                                (action: UIAlertAction!) -> Void in
                                self!.goBack()
                            }
                            
                            alert4 = UIAlertController(title: "Session Out of Date", message: "Session out of date, login again please", preferredStyle: UIAlertControllerStyle.Alert)
                            alert4.addAction(returnAction)
                            self!.presentViewController(alert4, animated: true, completion: nil)
                        } else {
                            //old
                            var alert4 = UIAlertView()
                            alert4.title = "Session Out of Date"
                            alert4.message = "Session out of date, login again please"
                            alert4.delegate = self
                            alert4.addButtonWithTitle("Ok")
                            dispatch_async(dispatch_get_main_queue(), {
                                alert4.show()
                            })
                            //alert4.show()
                        }
                        return
                    }
                    urlRequest.addValue((NSUserDefaults.standardUserDefaults().valueForKey("sessionName") as! String!) + "=" + (NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") as! String!), forHTTPHeaderField: "cookie")
                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler: { (resp:NSURLResponse?, data, error) -> Void in
                        if let r = resp{
                            print(r)
                            let d = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print(d)
                            
                            let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
                                options: NSJSONReadingOptions.MutableContainers) as! NSArray
                            
                            print("记录数：\(jsonArr.count)")
                            if (jsonArr.count > 0) {
                                for json in jsonArr {
                                    print("Name：", json.objectForKey("name")!)
                                    let name = json.objectForKey("name")
                                    self!.assigneeArray.append(name as! String)
                                    /*dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                    self!.assigneeArray.append(String(name))
                                    })*/
                                }
                                if (self!.assigneeArray.count > 0) {
                                    self!.assignee.autoCompleteStrings = self!.assigneeArray
                                }
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    //has some problem
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        BigView.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return ProjectDataSource.count
        }
        if (pickerView.tag == 2) {
            return PriorityDataSource.count
        }
        if (pickerView.tag == 3) {
            return VersionArray.count
        }
        if (pickerView.tag == 4) {
            return VersionArray.count
        }
        return -1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return ProjectDataSource[row]
        }
        if (pickerView.tag == 2) {
            return PriorityDataSource[row]
        }
        if (pickerView.tag == 3) {
            return VersionArray[row]
        }
        if (pickerView.tag == 4) {
            return VersionArray[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            self.ProjectButton.setTitle("\(self.ProjectDataSource[row])", forState: UIControlState.Normal)
            self.ProjectSelector.hidden = true
            //self.getVersions()
            //self.AffectVersionSelector.reloadAllComponents()
        }
        if (pickerView.tag == 2) {
            PriorityButton.setTitle("\(PriorityDataSource[row])", forState: UIControlState.Normal)
            PrioritySelctor.hidden = true
        }
        if (pickerView.tag == 3) {
            AffectVersionButton.setTitle("\(VersionArray[row])", forState: UIControlState.Normal)
            AffectVersionSelector.hidden = true
        }
        if (pickerView.tag == 4) {
            FixVersionButton.setTitle("\(VersionArray[row])", forState: UIControlState.Normal)
            FixVersionSelector.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVersions() {
        print(project_id)
        chooseProject()
        print(project_id)
        var urlString = "http://jira.corp.youdao.com/rest/api/2/project/"+project_id+"/versions"
        print(urlString)
        let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        if url != nil{
            let urlRequest = NSMutableURLRequest(URL: url!)
            urlRequest.HTTPMethod = "GET"
            
            if (NSUserDefaults.standardUserDefaults().valueForKey("sessionName") == nil) {
                //connected = false
                if #available(iOS 8.0, *) {
                    var alert4: UIAlertController
                    
                    let returnAction = UIAlertAction(title: "got it", style: UIAlertActionStyle.Default) {
                        (action: UIAlertAction!) -> Void in
                        self.goBack()
                    }
                    
                    alert4 = UIAlertController(title: "Session Out of Date", message: "Session out of date, login again please", preferredStyle: UIAlertControllerStyle.Alert)
                    alert4.addAction(returnAction)
                    presentViewController(alert4, animated: true, completion: nil)
                } else {
                    //old
                    var alert4 = UIAlertView()
                    alert4.title = "Session Out of Date"
                    alert4.message = "Session out of date, login again please"
                    alert4.delegate = self
                    alert4.addButtonWithTitle("Ok")
                    dispatch_async(dispatch_get_main_queue(), {
                        alert4.show()
                    })
                    //alert4.show()
                }
                return
            }
            urlRequest.addValue((NSUserDefaults.standardUserDefaults().valueForKey("sessionName") as! String!) + "=" + (NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") as! String!), forHTTPHeaderField: "cookie")
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler: { (resp:NSURLResponse?, data, error) -> Void in
                if let r = resp{
                    print(r)
                    let d = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print(d)
                    
                    let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
                        options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
                    print("版本记录数：\(jsonArr.count)")
                    if (jsonArr.count > 0) {
                        for json in jsonArr {
                            print("VersionName：", json.objectForKey("name")!)
                            let name = json.objectForKey("name")
                            let id = json.objectForKey("id")
                            self.VersionArray.append(name as! String)
                            self.VersionIdArray.append(id as! String)
                            /*dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            self!.assigneeArray.append(String(name))
                            })*/
                        }
                    }
                    self.VersionArray = self.VersionArray.reverse()
                    self.VersionIdArray = self.VersionIdArray.reverse()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.AffectVersionSelector.reloadAllComponents()
                        self.FixVersionSelector.reloadAllComponents()
                    })
                }
            })
        }
    }
    
    func isConnected() {
        let urlString = "http://jira.corp.youdao.com/rest/auth/1/session"
        //print(urlString)
        let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        if url != nil{
            let urlRequest = NSMutableURLRequest(URL: url!)
            urlRequest.HTTPMethod = "GET"
            
            if (NSUserDefaults.standardUserDefaults().valueForKey("sessionName") == nil) {
                connected = false
                return
            }
            urlRequest.addValue((NSUserDefaults.standardUserDefaults().valueForKey("sessionName") as! String!) + "=" + (NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") as! String!), forHTTPHeaderField: "cookie")
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler: { (resp:NSURLResponse?, data, error) -> Void in
                
                print(resp)
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                if let r = resp{
                    connected = true
                } else {
                    connected = false
                }
            })
            
        }
    }
}
