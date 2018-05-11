//
//  LaunchScreen.swift
//  ARC Decision Tool
//
//  Created by Michael McKenna on 4/3/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import UIKit
import RealmSwift

/// Temp screen displayed at app launch which directs the user to the proper controller depending on whether a `Hurricane` exists
class LaunchScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        
        DispatchQueue.main.async {
            if realm.objects(Hurricane.self).count == 0 {
                self.performSegue(withIdentifier: "toCreateHurricane", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toTaskList", sender: nil)
            }
        }
    }
}
