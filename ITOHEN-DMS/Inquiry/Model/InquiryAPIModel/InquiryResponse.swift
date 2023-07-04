//
//  InquiryResponse.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 25/01/23.
//

import Foundation

// MARK: - InquiryListResponse
class InquiryListResponse: NSObject, Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: InquiryData?
    let factories: [InquiryFactoryData]?
    let articles: [InquiryArticlesData]?
    let pdfpath: String?
}

// MARK: - Inquiry Data
struct InquiryData: Codable{
    let current_page, last_page, per_page: Int?
    let data: [InquiryListData]?
}

// MARK: - InquiryListData
struct InquiryListData: Codable {
    let id, is_po_generated: Int?
    let style_no: String?
    let name, factory_ids: String?
    var notification: Int?
    let created_date: String?
}

// MARK: - InquiryFactoryData
struct InquiryFactoryData: Codable{
    let id: Int?
    let factory: String?
}

// MARK: - InquiryArticlesData
struct InquiryArticlesData: Codable{
    let id: Int?
    let name: String?
}

// MARK: - FactoryResponse
struct FactoryResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FactoryResponseData]?
}

// MARK: - FactoryResponseData
class FactoryResponseData: NSObject, Codable {
    let factory_id, inquiry_id, factory_contact_id, is_po_generated, price: Int?
    let comments, factory, contact_person, contact_number, contact_email: String?
    let name: String?
    let created_date: String?
}

// MARK: - FactoryInquiryResponse
class FactoryInquiryResponse: NSObject, Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: FactoryInquiryData?
    let articles: [InquiryArticlesData]?
    let users: [InquiryArticlesData]?
    let response: [Int]?
    let pdfPath: String?
}

// MARK: - Factory Inquiry Data
struct FactoryInquiryData: Codable{
    let current_page, last_page, per_page: Int?
    let data: [FactoryInquiryResponseData]?
}

// MARK: - FactoryInquiryResponseData
class FactoryInquiryResponseData: NSObject, Codable {
    var id, is_read: Int?
    let due_days: Double?
    let style_no, name, user, created_date, due_date, response_date, currency: String?
}

// MARK: - InquiryNotificationResponse
struct InquiryNotificationResponse: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let notifications: Int?
}

// MARK: - FactoryInquiryListResponse
class FactoryInquiryListResponse: NSObject, Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [FactoryInquiryListResponseData]?
    let currency: String?
}

// MARK: - FactoryInquiryListResponseData
struct FactoryInquiryListResponseData: Codable {
    var id: Int?
    let factory: String?
}

// MARK: - Inquiry factory contact
struct InquiryFactoryList: Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: [InquiryFactoryListData]?
}

// MARK: - InquiryFactoryListResponseData
class InquiryFactoryListData: NSObject, Codable {
    var id: Int?
    let factory, contact_person, contact_number, contact_email: String?
}

// MARK: - PurchaseOrderList
class PurchaseOrderList: NSObject, Codable {
    let status: String?
    let status_code: Int?
    let message: String?
    let data: PurchaseOrderResponseData?
    let pdfpath: String?
}

// MARK: - PurchaseOrderResponseData
struct PurchaseOrderResponseData: Codable{
    let current_page, last_page, per_page: Int?
    let data: [PurchaseOrderListData]?
}

// MARK: - PurchaseOrderListData
struct PurchaseOrderListData: Codable {
    var po_id, factory_id, inquiry_id, po_status: Int?
    let factory: String?
}
