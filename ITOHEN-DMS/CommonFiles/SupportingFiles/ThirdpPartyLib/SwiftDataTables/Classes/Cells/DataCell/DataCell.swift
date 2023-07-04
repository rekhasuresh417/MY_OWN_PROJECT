//
//  DataCell.swift
//  SwiftDataTables
//
//  Created by Pavan Kataria on 22/02/2017.
//  Copyright © 2017 Pavan Kataria. All rights reserved.
//

import UIKit

class DataCell: UICollectionViewCell {

    //MARK: - Properties
    private enum Properties {
        static let verticalMargin: CGFloat = 2
        static let horizontalMargin: CGFloat = 2
        static let widthConstant: CGFloat = 20
    }
    
    let dataLabel = UILabel()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // customized
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        dataLabel.textAlignment = .center
        dataLabel.adjustsFontSizeToFitWidth = true
        dataLabel.lineBreakMode = .byTruncatingTail
        dataLabel.numberOfLines = 0
        dataLabel.font = .appFont(ofSize: 12.0, weight: .regular)
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        contentView.addSubview(dataLabel)
        NSLayoutConstraint.activate([
            dataLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: Properties.widthConstant),
            dataLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Properties.verticalMargin),
            dataLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Properties.verticalMargin),
            dataLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Properties.horizontalMargin),
            dataLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Properties.horizontalMargin),
        ])
    }
    
    func configure(_ viewModel: DataCellViewModel){
        self.dataLabel.text = viewModel.data.stringRepresentation.replacingOccurrences(of: "b/", with: "").replacingOccurrences(of: "t/", with: "")
        // customized
        if viewModel.data.stringRepresentation.contains("b/"){
            dataLabel.textColor = .primaryColor()
            dataLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
            self.backgroundColor = UIColor.init(rgb: 0xF6F6F6)
        }else if viewModel.data.stringRepresentation.contains("t/"){
            dataLabel.textColor = .primaryColor()
            dataLabel.font = .appFont(ofSize: 12.0, weight: .semibold)
            self.backgroundColor = .white
        }else{
            dataLabel.textColor = .customBlackColor()
            dataLabel.font = .appFont(ofSize: 12.0, weight: .regular)
            self.backgroundColor = .white
        }
        self.clipsToBounds = true
    }
}
