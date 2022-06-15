//
//  DetailViewController.swift
//  httpMethodExercise
//
//  Created by Ivan Pavic on 15.6.22..
//

import UIKit

class DetailViewController: UIViewController {
    
    var jsonResults: String?
    @IBOutlet weak var resultTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTextView.text = jsonResults
    }

}
