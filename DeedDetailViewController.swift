//
//  DeedDetailViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class DeedDetailViewController: UIViewController {

    @IBOutlet weak var deedTF: UITextField!
    var deed: Deed!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            deed = Deed(withDesc: deedTF.text!)
        }
    }

}
