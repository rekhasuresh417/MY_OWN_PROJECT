//
//  FabricResponse.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 20/03/23.
//

import Foundation

// MARK: - InquiryListResponse
class FabricInquiryListResponse: NSObject, Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: FabricInquiryData?
    let pdfpath: String?
}

// MARK: - FabricInquiryData
struct FabricInquiryData: Codable{
    let current_page, last_page, per_page: Int?
    let data: [FabricInquiryListData]?
}

// MARK: - InquiryListData
struct FabricInquiryListData: Codable {
    let id: Int?
    let yarn_count, yarn_quantity, yarn_quality, meterial, composition, delivery_date, inhouse_date, created_date, supplier_ids: String?
}

// MARK: - FabricMasterDataResponse
struct FabricMasterDataResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricMasterData]?
}

// MARK: - FabricMasterData
class FabricMasterData: NSObject, Codable{
    let id: Int?
    let type, content, reference_id, created_at: String?
}

// MARK: - FabricInquiryIdResponse
struct FabricInquiryIdResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricInquiryIds]?
}

// MARK: - FabricInquiryIds
class FabricInquiryIds: NSObject, Codable{
    let id: Int?
}

// MARK: - FabricInquiryCurrencyResponse
struct FabricInquiryCurrencyResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: String?
}

// MARK: - FabricCurrencyResponse
struct FabricCurrencyResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricCurrencyData]?
}

// MARK: - FabricCurrencyData
class FabricCurrencyData: NSObject, Codable{
    let id: Int?
    let name, symbol: String?
}

// MARK: - FabricInquiryDetailsResponse
struct FabricInquiryDetailsResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricInquityDetailsData]?
}

// MARK: - FabricInquityDetailsData
class FabricInquityDetailsData: NSObject, Codable{
    let id, user_id, staff_id, company_id, workspace_id, reference_inquiry: Int?
    let yarn_count, yarn_quantity, yarn_quality, meterial, composition, currency, delivery_date, inhouse_date, created_date: String?
}

// MARK: - FabricContactResponse
struct FabricContactResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricContactData]?
}

// MARK: - FabricContactData
class FabricContactData: NSObject, Codable{
    let id: Int?
    let supplier, contact_person, contact_number, contact_email: String?
}

// MARK: - FabricSupplierResponse
struct FabricSupplierResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricSupplierData]?
}

// MARK: - FabricSupplierData
class FabricSupplierData: NSObject, Codable{
    let inquiry_id, price: Int?
    let comments, supplier, contact_person, contact_number, contact_email: String?
}

// MARK: - FabricSupplierListResponse
struct FabricSupplierListResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FabricSupplierListData]?
    let currency: String?
}

// MARK: - FabricSupplierListData
class FabricSupplierListData: NSObject, Codable{
    let id: Int?
    let supplier: String?
}
