//
//  ViewController.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/29/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, FBLoginViewDelegate{
    var fbl: FBLoginView = FBLoginView()
    @IBOutlet var loginView : FBLoginView
    override func viewDidLoad() {
        super.viewDidLoad()
        fbl.delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginViewShowingLoggedInUser(loginView: FBLoginView) {
    }
    func loginViewFetchedUserInfo(loginView: FBLoginView?, user: FBGraphUser) {
        let secondViewController = self.storyboard.instantiateViewControllerWithIdentifier("EventsController") as EventsController
        self.navigationController.pushViewController(secondViewController, animated: true)
    }
    func loginViewShowingLoggedOutUser(loginView: FBLoginView?) {
    }
}