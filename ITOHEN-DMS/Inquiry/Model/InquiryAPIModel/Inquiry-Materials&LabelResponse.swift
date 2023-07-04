//
//  Inquiry-Materials&LabelResponse.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 25/04/23.
//

import Foundation

// MARK: - Get Labels IdsResponse
struct LabelInquiryIdsResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [LabelInquiryIdsData]?
}

// MARK: - LabelInquiryIdsResponseData
class LabelInquiryIdsData: NSObject, Codable {
    let id, inquiry_id: Int?
    
}

// MARK: - InquiryPOChat Response
class InquiryPOChatResponse:NSObject, Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [InquiryPOChatData]?
    let serverURL: String?
}

// MARK: - InquiryPOChatData
//struct InquiryPOChatData: Codable {
//    var id, po_id, status: Int?
//    var style_no, article, fabric_composition, category, inq_date, reference_id: String?
//    var type, content, content_type, createdDate, user_type, username, staffname: String?
//
//}

class InquiryPOChatData:NSObject, Codable {
    let id, userId, poId, publishStatus: Int?
    let styleNo, article, fabricComposition, category, inqDate, referenceId: String?
    let type, content, contentType, createdDate, userType, userName, staffName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case publishStatus = "publish_status"
        case article, category, type, content
        case userId = "user_id"
        case poId = "po_id"
        case styleNo = "style_no"
        case fabricComposition = "fabric_composition"
        case inqDate = "inq_date"
        case referenceId = "reference_id"
        case contentType = "content_type"
        case createdDate 
        case userType = "user_type"
        case userName = "username"
        case staffName = "staffname"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(String.self, forKey: .id)
            id = value == "0" ? 0 : Int(value ?? "0")
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        }
        do {
            let value = try container.decodeIfPresent(String.self, forKey: .userId)
            userId = value == "0" ? 0 : Int(value ?? "0")
        } catch DecodingError.typeMismatch {
            userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        }
        do {
            let value = try container.decodeIfPresent(String.self, forKey: .poId)
            poId = value == "0" ? 0 : Int(value ?? "0")
        } catch DecodingError.typeMismatch {
            poId = try container.decodeIfPresent(Int.self, forKey: .poId) ?? 0
        }
        do {
            let value = try container.decodeIfPresent(String.self, forKey: .publishStatus)
            publishStatus = value == "0" ? 0 : Int(value ?? "0")
        } catch DecodingError.typeMismatch {
            publishStatus = try container.decodeIfPresent(Int.self, forKey: .publishStatus) ?? 0
        }
        styleNo = try container.decodeIfPresent(String.self, forKey: .styleNo) ?? ""
        article = try container.decodeIfPresent(String.self, forKey: .article) ?? ""
        fabricComposition = try container.decodeIfPresent(String.self, forKey: .fabricComposition) ?? ""
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        inqDate = try container.decodeIfPresent(String.self, forKey: .inqDate) ?? ""
        referenceId = try container.decodeIfPresent(String.self, forKey: .referenceId) ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        contentType = try container.decodeIfPresent(String.self, forKey: .contentType) ?? ""
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate) ?? ""
        userType = try container.decodeIfPresent(String.self, forKey: .userType) ?? ""
        userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        staffName = try container.decodeIfPresent(String.self, forKey: .staffName) ?? ""
    }
}

struct InquiryPOModel: Codable{
    let id, poId, status: Int?
    let image: [String]?
    let text: [String]?
    let type, printDate, printUser, ref: String?
   
    init(id: Int, poId: Int, image: [String], text: [String], printDate: String, type: String, status: Int, printUser: String, ref: String) {
        // init properties here
        self.id = id
        self.poId = poId
        self.image = image
        self.text = text
        self.type = type
        self.printDate = printDate
        self.status = status
        self.printUser = printUser
        self.ref = ref
    }
}

struct POChatModel: Codable{
    let title, type: String?
    let data: [InquiryPOModel]?
    
    init(title: String, type: String, data: [InquiryPOModel]){
        self.title = title
        self.type = type
        self.data = data
    }
}

class InquiryFileUploadResponse: NSObject, Codable{
    let status: String?
    let status_code: Int?
    let message: String?
    let files: InquiryUploadedFile?
    let data: InquiryUploadedFile?
}

struct InquiryUploadedFile: Codable{
    let files: [InquiryUploadedFiles]?
    let serverURL: String?
}

struct InquiryUploadedFiles: Codable{
    let media_id, id: Int?
    let content, orginalfilename: String?
}
