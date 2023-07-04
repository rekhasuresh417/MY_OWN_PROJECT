//
//  DMSProductionInputResponse.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

// MARK: - DMSGetProductionResponse
struct DMSGetProductionResponse: Codable{
    let status: String
    let status_code: Int
    let message: String?
    let prodType: String
    let data: [CalendarDatum]

    enum CodingKeys: String, CodingKey {
        case status
        case status_code, message
        case prodType = "Production Type"
        case data
    }
}

// MARK: - HolidayData
class HolidayData: NSObject, Codable {
    let id, name, desc: String?
    let holidayStartDate, holidayEndDate: String?
    let days: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case desc = "description"
        case holidayStartDate = "start_date"// holiday_start_date"
        case holidayEndDate = "end_date"//holiday_end_date"
        case days
    }

    init(id: String, name: String, desc: String, holidayStartDate: String, holidayEndDate: String, days: Int) {
        // init properties here
        self.id = id
        self.name = name
        self.desc = desc
        self.holidayStartDate = holidayStartDate
        self.holidayEndDate = holidayEndDate
        self.days = days
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id)
        }

        do {
            let value = try container.decodeIfPresent(String.self, forKey: .days)
            days = value == "0" ? 0 : Int(value ?? "0")
        } catch DecodingError.typeMismatch {
            days = try container.decodeIfPresent(Int.self, forKey: .days)
        }

        name = try container.decodeIfPresent(String.self, forKey: .name)
        desc = try container.decodeIfPresent(String.self, forKey: .desc)
        holidayStartDate = try container.decodeIfPresent(String.self, forKey: .holidayStartDate)
        holidayEndDate = try container.decodeIfPresent(String.self, forKey: .holidayEndDate)
    }
}

// MARK: - DMSGetWeekOffList
struct DMSGetWeekOffList: Codable{
    let status: String
    let status_code: Int
    let message: String?
    let data: [WeekOffData]

    enum CodingKeys: String, CodingKey {
        case status
        case status_code, message
        case data
    }
}

// MARK: - WeekOffData
class WeekOffData: NSObject, Codable{
    let day: Int
}

// MARK: - ColorDatam
struct ColorDatam: Codable {
    let id,colorTitle: String?
    enum CodingKeys: String, CodingKey {
        case id
        case colorTitle = "color_title"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id)
        }

        colorTitle = try container.decodeIfPresent(String.self, forKey: .colorTitle)
    }
}

// MARK: - SizeDatam
struct SizeDatam: Codable {
    let id, sizeTitle: String?
    enum CodingKeys: String, CodingKey {
        case id
        case sizeTitle = "size_title"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .id)
            id = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            id = try container.decodeIfPresent(String.self, forKey: .id)
        }

        sizeTitle = try container.decodeIfPresent(String.self, forKey: .sizeTitle)
    }
}

// MARK: - CalendarDatum
class CalendarDatum: NSObject, Codable {
    var orderID, targetValue, actualValue, holidayFlag, holidayDetail: String?
    var typeOfProduction, dateOfProduction: String?
    var holidayId: String?

    var asDictionary: [String: Any] {
        return [
            "date_of_production" : dateOfProduction ?? "",
            "target_value" : targetValue ?? "",
            "holiday_flag" : holidayFlag ?? "",
            "holiday_detail" : holidayDetail ?? ""
        ]
    }

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case typeOfProduction = "type_of_production"
        case dateOfProduction = "date_of_production"
        case targetValue = "target_value"
        case actualValue = "actual_value"
        case holidayFlag = "holiday_flag"
        case holidayDetail = "holiday_detail"
        case holidayId
    }

    init(dateOfProduction: String, targetValue: String, holidayFlag: String, holidayDetail: String, holidayId: String = "") {
        self.dateOfProduction = dateOfProduction
        self.targetValue = targetValue
        self.holidayFlag = holidayFlag
        self.holidayDetail = holidayDetail
        self.holidayId = holidayId
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .orderID)
            orderID = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            orderID = try container.decodeIfPresent(String.self, forKey: .orderID)
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .targetValue)
            targetValue = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            targetValue = try container.decodeIfPresent(String.self, forKey: .targetValue)
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .actualValue)
            actualValue = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            actualValue = try container.decodeIfPresent(String.self, forKey: .actualValue)
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .holidayFlag)
            holidayFlag = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            holidayFlag = try container.decodeIfPresent(String.self, forKey: .holidayFlag)
        }
        holidayDetail = try container.decodeIfPresent(String.self, forKey: .holidayDetail)
        holidayId = try container.decodeIfPresent(String.self, forKey: .holidayId)
        typeOfProduction = try container.decodeIfPresent(String.self, forKey: .typeOfProduction)
        dateOfProduction = try container.decodeIfPresent(String.self, forKey: .dateOfProduction)
    }
}

// MARK: - Metrics
struct Metrics: Codable {
    let cut, sew, pack: MetricsData?
}

// MARK: - MetricsData
struct MetricsData: Codable {
    let currentRate, currentRateDate, reqRate, reqDate : String

    enum CodingKeys: String, CodingKey {
        case currentRate,currentRateDate,reqRate,reqDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .currentRate) ?? 0
            currentRate = value == 0 ? "0" : String(value)
        } catch DecodingError.typeMismatch {
            currentRate = try container.decodeIfPresent(String.self, forKey: .currentRate) ?? ""
        }
        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .reqRate) ?? 0
            reqRate = value == 0 ? "0" : String(value)
        } catch DecodingError.typeMismatch {
            reqRate = try container.decodeIfPresent(String.self, forKey: .reqRate) ?? ""
        }
        currentRateDate = try container.decodeIfPresent(String.self, forKey: .currentRateDate) ?? ""
        reqDate = try container.decodeIfPresent(String.self, forKey: .reqDate) ?? ""
    }
}

// MARK: - DMSGetCalendarResponse
struct DMSGetCalendarResponse: Codable{
    let status: String?
    let status_code: Int
    let message: String?
    let prodType: String?
    let data: DMSGetCalendarData?

    enum CodingKeys: String, CodingKey {
        case status
        case status_code, message
        case prodType = "ProductionType"
        case data
    }
}

// MARK: - DMSGetCalendarData
class DMSGetCalendarData:NSObject, Codable{
    var prodDetails: ProdDetails?
    var knobChart: KnobChart?
    var weekOffs: [WeekOffsData]?
    var holidays: [HolidayData]?
    var skuData: [SKUData]?
    var CalendarData: [CalendarDatum]?
}

// MARK: - ProdDetails
struct ProdDetails: Codable{
    let cutStartDate: String?
    let cutEndDate: String?
    let sewStartDate: String?
    let sewEndDate: String?
    let packStartDate: String?
    let packEndDate: String?
    let isCutAccomplished, isSewAccomplished, isPackAccomplished: Int?
    let cutAccomplishedDate, sewAccomplishedDate, packAccomplishedDate: String?
}

// MARK: - KnobChart
struct KnobChart: Codable{
    let totalQuantity: Int?
    let completedQuantity: Int?
    let pendingQuantity: Int?
    let currentOutputQuantity: Int?
    let reqOutputRate: Int?
}

// MARK: - WeekOffsData
class WeekOffsData: NSObject, Codable{
    let days: Int
}

// MARK: - DMSGetSKUResponse
struct DMSGetSKUResponse: Codable{
    let status: String?
    let status_code: Int
    let message: String?
    let data: [SKUData]?
}

// MARK: - SKUData
class SKUData: NSObject, Codable {
    var colorID, sizeID, skuQuantity, updatedQuantity, dateUpdated, pendingQty, todayUpdatedQty: String?
    var colorTitle, sizeTitle: String?

    enum CodingKeys: String, CodingKey {
        case colorID = "color_id"
        case sizeID = "size_id"
        case colorTitle = "colorName"
        case sizeTitle = "sizeName"
        case skuQuantity = "total_quantity"
        case updatedQuantity = "updated_quantity"
        case pendingQty = "pending_quantity"
        case todayUpdatedQty = "today_updated_quantity"
        case dateUpdated = "date_updated"
    }
    init(colorID:String, sizeID:String, skuQuantity:String, updatedQuantity: String, pendingQty:String, todayUpdatedQty: String, dateUpdated: String, colorTitle:String, sizeTitle:String) {
        self.colorID = colorID
        self.sizeID = sizeID
        self.skuQuantity = skuQuantity
        self.updatedQuantity = updatedQuantity
        self.pendingQty = pendingQty
        self.todayUpdatedQty = todayUpdatedQty
        self.dateUpdated = dateUpdated
        self.colorTitle = colorTitle
        self.sizeTitle = sizeTitle
    }

    required init(from decoder: Decoder) throws {
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

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .updatedQuantity)
            updatedQuantity = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            updatedQuantity = try container.decodeIfPresent(String.self, forKey: .updatedQuantity) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .pendingQty)
            pendingQty = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            pendingQty = try container.decodeIfPresent(String.self, forKey: .pendingQty) ?? "0"
        }

        do {
            let value = try container.decodeIfPresent(Int.self, forKey: .todayUpdatedQty)
            todayUpdatedQty = value == 0 ? "0" : String(value ?? 0)
        } catch DecodingError.typeMismatch {
            todayUpdatedQty = try container.decodeIfPresent(String.self, forKey: .todayUpdatedQty) ?? "0"
        }
        colorTitle = try container.decodeIfPresent(String.self, forKey: .colorTitle) ?? ""
        sizeTitle = try container.decodeIfPresent(String.self, forKey: .sizeTitle) ?? ""
        dateUpdated = try container.decodeIfPresent(String.self, forKey: .dateUpdated) ?? ""
    }
}

// Assign API values
struct ProductionSection {
    var productionType: String
    var startDate: String
    var endDate: String
  
    var weekoffs:[Int] = [] // 1-S,2-M,3-T,4-W,5-T,6-F,7-S - by default saturday & sunday is holiday at initially
    var holidayList:[Date] = []{
        didSet{
            print(holidayList)
        }
    }
    var manualHolidayList:[Date] = []
    var allDaysList:[Date] = []
    var data: [CalendarDatum] = []{
        didSet{
            print(data)
        }
    }
    var holidays: [HolidayData] = []{
        didSet{
            print("holiday", holidays)
        }
    }
    
    var colorData:[ColorDatam] = []{
        didSet{
            print(colorData)
        }
    }
    var sizeData:[SizeDatam] = []{
        didSet{
            print(sizeData)
        }
    }
}

struct colorSection {
    var id, colorTitle: String
}

struct sizeSection {
    var id, colorTitle: String
}
