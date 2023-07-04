//
//  DMSOrderInfoResponse.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation


// MARK: - Basic
class Basic: NSObject, Codable {
    var id, orderNo, styleNo, pcuName, factoryName, taskFeeded, buyerName, minProdRange, pendingTasks, closeOrderStatus, quantity: String?
    var buyerId, factoryId, pcuId: String?
    var cutStartDate, sewStartDate, packStartDate: String?
    var cutEndDate, sewEndDate, packEndDate: String?
    var isToleranceRequired, toleranceVolume, tolerancePerc: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNo = "order"
        case styleNo = "style"
        case buyerId = "buyer_id"
        case factoryId = "factory_id"
        case pcuId = "pcu_id"
        case taskFeeded = "task_feeded"
        case buyerName = "buyer"
        case pcuName = "pcu"
        case factoryName = "factory"
        case minProdRange = "minProdRange"
        case pendingTasks = "pending_tasks"
        case closeOrderStatus = "close_order_status"

        case quantity = "quantity"
        case isToleranceRequired = "is_tolerance_req"
        case toleranceVolume = "tolerance_volume"
        case tolerancePerc = "tolerance_perc"

        case cutStartDate = "cutting_start_date"
        case sewStartDate = "sewing_start_date"
        case packStartDate = "packing_start_date"
        case cutEndDate = "cutting_end_date"
        case sewEndDate = "sewing_end_date"
        case packEndDate = "packing_end_date"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .buyerId)
            buyerId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            buyerId = try container.decodeIfPresent(String.self, forKey: .buyerId) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .factoryId)
            factoryId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            factoryId = try container.decodeIfPresent(String.self, forKey: .factoryId) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .pcuId)
            pcuId = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            pcuId = try container.decodeIfPresent(String.self, forKey: .pcuId) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .taskFeeded)
            taskFeeded = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            taskFeeded = try container.decodeIfPresent(String.self, forKey: .taskFeeded) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .minProdRange)
            minProdRange = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            minProdRange = try container.decodeIfPresent(String.self, forKey: .minProdRange) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .pendingTasks)
            pendingTasks = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            pendingTasks = try container.decodeIfPresent(String.self, forKey: .pendingTasks) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .closeOrderStatus)
            closeOrderStatus = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            closeOrderStatus = try container.decodeIfPresent(String.self, forKey: .closeOrderStatus) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .quantity)
            quantity = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            quantity = try container.decodeIfPresent(String.self, forKey: .quantity) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .isToleranceRequired)
            isToleranceRequired = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            isToleranceRequired = try container.decodeIfPresent(String.self, forKey: .isToleranceRequired) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .toleranceVolume)
            toleranceVolume = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            toleranceVolume = try container.decodeIfPresent(String.self, forKey: .toleranceVolume) ?? "0"
        }

        if let int = try? container.decodeIfPresent(Int.self, forKey: .tolerancePerc){
            tolerancePerc = String(int)
        }else if let float = try? container.decodeIfPresent(Float.self, forKey: .tolerancePerc){
            tolerancePerc = String(float)
        }else if let double = try? container.decodeIfPresent(Double.self, forKey: .tolerancePerc){
            tolerancePerc = String(double)
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .buyerName)
            buyerName = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            buyerName = try container.decodeIfPresent(String.self, forKey: .buyerName) ?? "0"
        }

        orderNo = try container.decodeIfPresent(String.self, forKey: .orderNo) ?? ""
        styleNo = try container.decodeIfPresent(String.self, forKey: .styleNo) ?? ""
        factoryName = try container.decodeIfPresent(String.self, forKey: .factoryName) ?? ""
        pcuName = try container.decodeIfPresent(String.self, forKey: .pcuName) ?? ""

        cutStartDate = try container.decodeIfPresent(String.self, forKey: .cutStartDate) ?? ""
        sewStartDate = try container.decodeIfPresent(String.self, forKey: .sewStartDate) ?? ""
        packStartDate = try container.decodeIfPresent(String.self, forKey: .packStartDate) ?? ""
        cutEndDate = try container.decodeIfPresent(String.self, forKey: .cutEndDate) ?? ""
        sewEndDate = try container.decodeIfPresent(String.self, forKey: .sewEndDate) ?? ""
        packEndDate = try container.decodeIfPresent(String.self, forKey: .packEndDate) ?? ""
    }
}

// MARK: - OrderSKUData
struct OrderSKUData: Codable {
    var colorID, sizeID, skuQuantity: String?
    var colorTitle, sizeTitle: String?

    enum CodingKeys: String, CodingKey {
        case colorID = "sku_color_id"
        case sizeID = "sku_size_id"
        case colorTitle = "colorname"
        case sizeTitle = "sizename"
        case skuQuantity = "sku_quantity"
    }
    init(colorID:String, sizeID:String, skuQuantity:String, colorTitle:String, sizeTitle:String) {
        self.colorID = colorID
        self.sizeID = sizeID
        self.skuQuantity = skuQuantity
        self.colorTitle = colorTitle
        self.sizeTitle = sizeTitle
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .colorID)
            colorID = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            colorID = try container.decodeIfPresent(String.self, forKey: .colorID) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .sizeID)
            sizeID = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            sizeID = try container.decodeIfPresent(String.self, forKey: .sizeID) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .skuQuantity)
            skuQuantity = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            skuQuantity = try container.decodeIfPresent(String.self, forKey: .skuQuantity) ?? "0"
        }

        colorTitle = try container.decodeIfPresent(String.self, forKey: .colorTitle) ?? ""
        sizeTitle = try container.decodeIfPresent(String.self, forKey: .sizeTitle) ?? ""
    }
}

// MARK: - Contact
class Contact: NSObject, Codable {
    var id, contactName, contactRole, partnerTitle: String?

    enum CodingKeys: String, CodingKey {
        case id = "staff_id"
        case contactName = "staff_name"
        case contactRole = "contact_role"
        case partnerTitle = "partner_title"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .contactRole)
            contactRole = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            contactRole = try container.decodeIfPresent(String.self, forKey: .contactRole) ?? "0"
        }

        contactName = try container.decodeIfPresent(String.self, forKey: .contactName) ?? ""
        partnerTitle = try container.decodeIfPresent(String.self, forKey: .partnerTitle) ?? ""
    }

    var asDictionary: [String: Any] {
        return [
            "id" : id ?? "",
            "contact_name" : contactName ?? "",
            "contact_role" : contactRole ?? "",
            "partner_title" : partnerTitle ?? ""
        ]
    }
}

// MARK: - ProductionData
struct ProductionData: Codable {
    let totalQuantity: String
    var cuttingDataFeed, sewingDataFeed, packingDataFeed: Bool
    let cutPerc, sewPerc, packPerc: CGFloat?
    let cutPcs, sewPcs, packPcs: String
    let cutBAL, sewBAL, packBAL: String
    let cutPercExp, sewPercExp, packPercExp: CGFloat?

    enum CodingKeys: String, CodingKey {
        case totalQuantity, cuttingDataFeed, sewingDataFeed, packingDataFeed
        case cutPerc = "cut_perc"
        case sewPerc = "sew_perc"
        case packPerc = "pack_perc"
        case cutPcs = "cut_pcs"
        case sewPcs = "sew_pcs"
        case packPcs = "pack_pcs"
        case cutBAL = "cut_bal"
        case sewBAL = "sew_bal"
        case packBAL = "pack_bal"
        case cutPercExp = "cut_perc_exp"
        case sewPercExp = "sew_perc_exp"
        case packPercExp = "pack_perc_exp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .cutPcs)
            cutPcs = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            cutPcs = try container.decodeIfPresent(String.self, forKey: .cutPcs) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .sewPcs)
            sewPcs = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            sewPcs = try container.decodeIfPresent(String.self, forKey: .sewPcs) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .packPcs)
            packPcs = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            packPcs = try container.decodeIfPresent(String.self, forKey: .packPcs) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .cutBAL)
            cutBAL = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            cutBAL = try container.decodeIfPresent(String.self, forKey: .cutBAL) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .sewBAL)
            sewBAL = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            sewBAL = try container.decodeIfPresent(String.self, forKey: .sewBAL) ?? "0"
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .packBAL)
            packBAL = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            packBAL = try container.decodeIfPresent(String.self, forKey: .packBAL) ?? "0"
        }
        totalQuantity = try container.decodeIfPresent(String.self, forKey: .totalQuantity) ?? "0"
        cuttingDataFeed = try container.decodeIfPresent(Bool.self, forKey: .cuttingDataFeed) ?? false
        sewingDataFeed = try container.decodeIfPresent(Bool.self, forKey: .sewingDataFeed) ?? false
        packingDataFeed = try container.decodeIfPresent(Bool.self, forKey: .packingDataFeed) ?? false

        cutPerc = try container.decodeIfPresent(CGFloat.self, forKey: .cutPerc)
        sewPerc = try container.decodeIfPresent(CGFloat.self, forKey: .sewPerc)
        packPerc = try container.decodeIfPresent(CGFloat.self, forKey: .packPerc)
        cutPercExp = try container.decodeIfPresent(CGFloat.self, forKey: .cutPercExp)
        sewPercExp = try container.decodeIfPresent(CGFloat.self, forKey: .sewPercExp)
        packPercExp = try container.decodeIfPresent(CGFloat.self, forKey: .packPercExp)
    }
}
