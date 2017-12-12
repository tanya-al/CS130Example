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
    let LINE_GAP_1: CGFloat = 4
    let LINE_GAP_2: CGFloat = 4
    let EDGE_GAP: CGFloat = 10
    let DATE_FORMATTER = "MMM dd, yyyy"
    
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
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, transaction: Transaction) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = transaction.description
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.sizeToFit()
        descriptionLabel.frame.origin = CGPoint(x: LEFT_GAP, y: EDGE_GAP)
        self.contentView.addSubview(descriptionLabel)
        
        categoryLabel = UILabel()
        categoryLabel.text = transaction.category
        categoryLabel.textColor = UIColor.gray
        categoryLabel.font = UIFont.italicSystemFont(ofSize: 14)
        categoryLabel.sizeToFit()
        categoryLabel.frame.origin = CGPoint(x: LEFT_GAP, y: EDGE_GAP + descriptionLabel.frame.height + LINE_GAP_1)
        self.contentView.addSubview(categoryLabel)
        
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMATTER
        dateLabel = UILabel()
        dateLabel.text = formatter.string(from: transaction.date)
        dateLabel.textColor = UIColor.gray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.sizeToFit()
        dateLabel.frame.origin = CGPoint(x: LEFT_GAP, y: EDGE_GAP + descriptionLabel.frame.height + categoryLabel.frame.height + LINE_GAP_1 + LINE_GAP_2)
        self.contentView.addSubview(dateLabel)
        
        amountLabel = UILabel()
        amountLabel.text = "$" + String(format: "%.2f", transaction.amount)
        amountLabel.textColor = UIColor.black
        amountLabel.font = UIFont.systemFont(ofSize: 28)
        amountLabel.sizeToFit()
        amountLabel.textAlignment = .right
        amountLabel.frame.origin = CGPoint(x: UIScreen.main.bounds.width - amountLabel.frame.width - RIGHT_GAP,
                                           y: self.dateLabel.frame.origin.y + self.dateLabel.frame.height - amountLabel.frame.height)
        self.contentView.addSubview(amountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
