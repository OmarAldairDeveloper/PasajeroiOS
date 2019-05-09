//
//  SuccessViewController.swift
//  zounyrider
//
//  Created by Omar Aldair Romero Pérez on 5/9/19.
//  Copyright © 2019 Honey Mustard. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func okAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
