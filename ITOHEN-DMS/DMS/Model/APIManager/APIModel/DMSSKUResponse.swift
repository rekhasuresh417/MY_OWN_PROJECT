//
//  DMSSKUResponse.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

// MARK: - Section
struct Section {
    var colorName: String
    var colorId:String
    var collapsed: Bool = false

    var selectedSizes:[SizeModel] = [] {
        didSet{
            self.updateTotalQuantityOfSection()
        }
    }
    var totalSkuQuantityOfSection:String

    init(colorName: String, colorId: String, selectedSizes: [SizeModel], totalSkuQuantityOfSection:String, collapsed: Bool = false) {
        self.colorName = colorName
        self.colorId = colorId
        self.collapsed = collapsed
        self.selectedSizes = selectedSizes
        self.totalSkuQuantityOfSection = totalSkuQuantityOfSection
    }

    mutating func updateTotalQuantityOfSection(){
        totalSkuQuantityOfSection = "0"
        for model in selectedSizes{
            totalSkuQuantityOfSection = "\( (Int(totalSkuQuantityOfSection) ?? 0) + (Int(model.skuQuantityOfSize) ?? 0) )"

           /* if Int(model.totalToleranceQuantity) ?? 0>0{
                totalSkuQuantityOfSection = "\( (Int(totalSkuQuantityOfSection) ?? 0) + (Int(model.totalToleranceQuantity) ?? 0) )"
            }else{
                totalSkuQuantityOfSection = "\( (Int(totalSkuQuantityOfSection) ?? 0) + (Int(model.skuQuantityOfSize) ?? 0) )"
            }*/
        }
    }
}

// MARK: - SizeModel
struct SizeModel {
    var sizeId: String
    var sizeName: String
    var skuQuantityOfSize: String
    var checkPendingQuantity: String
    var totalToleranceQuantity: String
    var totalQty: String? = ""
    var updatedQty: String? = ""
    var pendingQty: String? = ""
}
