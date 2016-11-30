//
//  ViewController.swift
//  VaultSDKExample
//
//  Created by Fang-Pen Lin on 11/23/16.
//  Copyright © 2016 Very Good Security. All rights reserved.
//

import UIKit

import VaultSDK

class ViewController: UIViewController {

    @IBOutlet weak var senstiveDataField: UITextField!
    @IBOutlet weak var tokenResultField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tokenizeButtonTapped(sender: AnyObject) {
        let api = VaultAPI(
            baseURL: NSURL(string: "https://demo.sandbox.verygoodvault.com")!,
            publishableKey: "demo-user"
        )
        api.createToken(
            senstiveDataField.text!,
            failure: { error in
                print("Error: \(error)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.tokenResultField.text = "Error: \(error)"
                }
            },
            success: { [unowned self] token in
                print("Token: \(token)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.tokenResultField.text = token["id"] as? String
                }
            }
        )
    }

}
