//
//  ExportProgressStateViewController.swift
//  CollageMaker
//
//  Created by Alex on 5/8/21.
//  Copyright © 2021 Alex. All rights reserved.
//

import UIKit

class ExportProgressStateViewController: UIViewController {

    @IBOutlet private var progressView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        progressView?.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        progressView?.stopAnimating()
    }
}
