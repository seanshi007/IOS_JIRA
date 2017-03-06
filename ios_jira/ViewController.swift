//
//  ViewController.swift
//  ios_jira
//
//  Created by sean on 16/2/3.
//  Copyright © 2016年 sean. All rights reserved.
//

import UIKit

var isBack:Bool = false //验证往回跳转
var connected:Bool = false //验证session是否过期

class ViewController: UIViewController, UIAlertViewDelegate {
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    
    //Auth用来最后传图
    var headerAuth:String = ""
    
    @IBAction func LoginButtonPress(sender: AnyObject) {
        
        self.toNext()
        
        if (tvPassword.text == "" || tvUsername.text == "") {
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
                alert4.show()
            }
            return
        }
        
        //登录用户信息JSON对象
        let JSONObject: [String : String] = [
            "username" : tvUsername.text!,
            "password" : tvPassword.text!
        ]
        
        if NSJSONSerialization.isValidJSONObject(JSONObject) {
            
            let req = NSMutableURLRequest(URL: NSURL(string: "http://jira.corp.youdao.com/rest/auth/1/session")!)
            req.HTTPMethod = "POST"
            req.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(JSONObject, options: NSJSONWritingOptions(rawValue: 0))
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print(JSONObject)
            
            NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue(), completionHandler:
                { (response, data, error) -> Void in
                    if let e = error {
                        print(e)
                    } else {
                        print(response)
                    }
                    
                    let httpResponse = response as? NSHTTPURLResponse
                    print(httpResponse?.statusCode)
                    
                    if (httpResponse?.statusCode == 200) {
                        print("yes")
                        
                        let json : AnyObject! = try? NSJSONSerialization
                            .JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments)
                        let session : AnyObject = json.objectForKey("session")!
                        let sessionName : AnyObject = session.objectForKey("name")!
                        let sessionValue : AnyObject = session.objectForKey("value")!
                        //设置Session存储信息
                        NSUserDefaults.standardUserDefaults().setObject(sessionName, forKey: "sessionName")
                        NSUserDefaults.standardUserDefaults().setObject(sessionValue, forKey: "sessionValue")
                        //设置同步
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        let urlString = "http://jira.corp.youdao.com/rest/auth/1/session"
                        let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                        if url != nil{
                            let urlRequest = NSMutableURLRequest(URL: url!)
                            
                            //self.headerCookie = (sessionName as! String) + "=" + (sessionValue as! String)
                            
                            urlRequest.addValue((sessionName as! String) + "=" + (sessionValue as! String), forHTTPHeaderField: "cookie")
                            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler: { (resp:NSURLResponse?, d, e) -> Void in
                                
                                print(resp)
                                print(NSString(data: d!, encoding: NSUTF8StringEncoding))
                            })
                            
                        }
                        
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            
                            if (self.rememberSwitch.on) {
                                //设置存储信息
                                NSUserDefaults.standardUserDefaults().setObject(self.tvUsername.text, forKey: "UserNameKey")
                                NSUserDefaults.standardUserDefaults().setObject(self.tvPassword.text, forKey: "PwdKey")
                                NSUserDefaults.standardUserDefaults().setBool(self.rememberSwitch.on, forKey: "RmbPwdKey")
                                //设置同步
                                NSUserDefaults.standardUserDefaults().synchronize()
                            } else {
                                NSUserDefaults.standardUserDefaults().setBool(self.rememberSwitch.on, forKey: "RmbPwdKey")
                                //设置同步
                                NSUserDefaults.standardUserDefaults().synchronize()
                            }
                            connected = true
                            self.toNext()
                        })
                        
                        //self.isConnected()
                        
                    } else {
                        //login failed
                        if #available(iOS 8.0, *) {
                            var alert4: UIAlertController
                            let cancelAction = UIAlertAction(title: "got it", style: UIAlertActionStyle.Cancel, handler: nil)
                            
                            alert4 = UIAlertController(title: "Login Failed", message: "Please double check your user detail", preferredStyle: UIAlertControllerStyle.Alert)
                            alert4.addAction(cancelAction)
                            self.presentViewController(alert4, animated: true, completion: nil)
                        } else {
                            //old
                            var alert4 = UIAlertView()
                            alert4.title = "Login Failed"
                            alert4.message = "Please double check your user detail"
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
        //connected = true
        //self.toNext()
        
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        if (alertView.title == "Blank Error") {
            switch (buttonIndex) {
            case 0:
                break
            default: break
            }
        }
        if (alertView.title == "Login Failed") {
            switch (buttonIndex) {
            case 0:
                break
            default: break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toSecond") {
            print("in prepare")
            var svc = segue.destinationViewController as! ReportViewController
            svc.username = tvUsername.text
            svc.Auth = headerAuth
        }
    }
    
    func getAuthentication() {
        let plainString = tvUsername.text!+":"+tvPassword.text!
        let plainData = (plainString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        headerAuth = base64String
    }
    
    func toNext() {
        //prepareForSegue(, sender: self)
        performSegueWithIdentifier("toSecond", sender: self)
    }
    
    @IBOutlet weak var tvPassword: UITextField!
    @IBOutlet weak var tvUsername: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            super.viewDidAppear(animated)
        })
        //super.viewDidAppear(animated)
        
        print(isBack)
        if (isBack) {
            tvPassword.text = ""
            tvUsername.text = ""
            rememberSwitch.on = false
            if (NSUserDefaults.standardUserDefaults().valueForKey("UserNameKey") != nil && NSUserDefaults.standardUserDefaults().valueForKey("RmbPwdKey") != nil && NSUserDefaults.standardUserDefaults().valueForKey("PwdKey") != nil) {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("RmbPwdKey")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("UserNameKey")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("PwdKey")
                //设置同步
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            if (NSUserDefaults.standardUserDefaults().valueForKey("sessionName") != nil && NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") != nil) {
                NSUserDefaults.standardUserDefaults().removeObjectForKey("sessionName")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("sessionValue")
                //设置同步
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            isBack = false
        }
        print("finish")
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        MainView.endEditing(true)
    }
    
    override func viewDidLoad() {
        dispatch_async(dispatch_get_main_queue(), {
            super.viewDidLoad()
        })
        //super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("again")
        tvPassword.secureTextEntry = true
        //判断是否第一次启动：
        if((NSUserDefaults.standardUserDefaults().boolForKey("IsFirstLaunch") as Bool!) == false){
            //第一次启动，播放引导页面
            print("第一次启动")
            //设置为非第一次启动
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IsFirstLaunch")
        } else {
            print("不是第一次启动")
            self.rememberSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey("RmbPwdKey") as Bool!
            if (self.rememberSwitch.on){
                self.tvUsername.text =
                    NSUserDefaults.standardUserDefaults().valueForKey("UserNameKey") as! String!
                self.tvPassword.text = NSUserDefaults.standardUserDefaults().valueForKey("PwdKey") as! String!
            }
        }
        
        print(isBack)
        if (!isBack) {
            //isConnected()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isConnected()->Bool {
        let urlString = "http://jira.corp.youdao.com/rest/auth/1/session"
        //print(urlString)
        let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        if url != nil{
            let urlRequest = NSMutableURLRequest(URL: url!)
            urlRequest.HTTPMethod = "GET"
            
            if (NSUserDefaults.standardUserDefaults().valueForKey("sessionName") == nil) {
                return false
            }
            urlRequest.addValue((NSUserDefaults.standardUserDefaults().valueForKey("sessionName") as! String!) + "=" + (NSUserDefaults.standardUserDefaults().valueForKey("sessionValue") as! String!), forHTTPHeaderField: "cookie")
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue(), completionHandler: { (resp:NSURLResponse?, data, error) -> Void in
                
                print(resp)
                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                if let r = resp{
                    connected = true
                    self.toNext()
                } else {
                    connected = false
                }
            })
            
        }
        return false
    }
    
}

