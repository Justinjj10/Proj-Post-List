//
//  DetailsViewController.swift
//  Proj_Assesment
//
//  Created by Justin Joseph on 08/05/24.
//

import UIKit

class DetailsViewController: UIViewController {
    var post: Posts?
    
    @IBOutlet weak var postUserIdLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        guard let post = post else {
            postUserIdLabel.text = "N/A"
            postBodyLabel.text = "N/A"
            return
        }
        postUserIdLabel.text = "\(post.userId ?? 0)"
        postBodyLabel.text = post.body
        self.title = "ID: \(post.id)"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
