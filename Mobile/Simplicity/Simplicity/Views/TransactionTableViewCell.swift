//
//  TransactionTableViewCell.swift
//  Simplicity
//
//  Created by Anthony Lai on 12/11/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    let LEFT_GAP: CGFloat = 15
    let RIGHT_GAP: CGFloat = 25
    let LINE_GAP_1: CGFloat = 6
    let LINE_GAP_2: CGFloat = 4
    let EDGE_GAP: CGFloat = 10
    
    // MARK: Properties
    var descriptionLabel: UILabel!
    var categoryLabel: UILabel!
    var dateLabel: UILabel!
    var amountLabel: UILabel!
    
    // MARK: Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Mr. Noodles"
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.sizeToFit()
        descriptionLabel.frame.origin = CGPoint(x: LEFT_GAP, y: EDGE_GAP)
        self.contentView.addSubview(descriptionLabel)
        
        categoryLabel = UILabel()
        categoryLabel.text = "Restaurants"
        //categoryLabel.textColor = UIColor.init(red: 140/255, green: 140/255, blue: 140/255, alpha: 0)
        categoryLabel.textColor = UIColor.gray
        categoryLabel.font = UIFont.italicSystemFont(ofSize: 12)
        categoryLabel.sizeToFit()
        categoryLabel.frame.origin = CGPoint(x: LEFT_GAP, y: EDGE_GAP + descriptionLabel.frame.height + LINE_GAP_1)
        self.contentView.addSubview(categoryLabel)
        
        dateLabel = UILabel()
        dateLabel.text = "Dec 05, 2017"
        //categoryLabel.textColor = UIColor.init(red: 140/255, green: 140/255, blue: 140/255, alpha: 0)
        dateLabel.textColor = UIColor.gray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: LEFT_GAP, y: EDGE_GAP + descriptionLabel.frame.height + categoryLabel.frame.height + LINE_GAP_1 + LINE_GAP_2)
        self.contentView.addSubview(dateLabel)
        
        amountLabel = UILabel()
        amountLabel.text = "$50.00"
        amountLabel.textColor = UIColor.black
        amountLabel.font = UIFont.systemFont(ofSize: 24)
        amountLabel.sizeToFit()
        amountLabel.textAlignment = .right
        amountLabel.frame.origin = CGPoint(x: UIScreen.main.bounds.width - amountLabel.frame.width - RIGHT_GAP,
                                           y: self.dateLabel.frame.origin.y + self.dateLabel.frame.height - amountLabel.frame.height)
        self.contentView.addSubview(amountLabel)
        
        
        //self.contentView.layoutIfNeeded()
//        self.contentView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: EDGE_GAP * 2 + LINE_GAP * 2 + descriptionLabel.frame.height + categoryLabel.frame.height + dateLabel.frame.height)
//            //EDGE_GAP * 2 + LINE_GAP * 2 + descriptionLabel.frame.height + categoryLabel.frame.height + dateLabel.frame.height
//        self.contentView.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
