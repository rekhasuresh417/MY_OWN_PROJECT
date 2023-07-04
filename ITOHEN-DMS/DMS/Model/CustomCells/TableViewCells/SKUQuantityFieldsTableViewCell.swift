//
//  SKUQuantityFieldsTableViewCell.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

class SKUQuantityFieldsTableViewCell: UITableViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var collectionView:UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.backgroundColor = .clear
        self.mainView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.collectionView.reloadInputViews()
        self.collectionView.reloadData()
    }
    
    func setContent(section:Section){
        self.mainView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 8.0)
    }
}
