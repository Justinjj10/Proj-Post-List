//
//  PostTableViewCell.swift
//  Proj_Assesment
//
//  Created by Justin Joseph on 08/05/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postIdLabel: UILabel!
    @IBOutlet weak var postTittleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(with post: Posts) {
        postIdLabel.text = "Id: " + "\(post.id)"
        postTittleLabel.text = post.title
    }

}
