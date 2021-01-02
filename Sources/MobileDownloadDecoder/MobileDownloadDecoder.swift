//
//  MobileDownloadDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/26/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

public struct MobileDownloadDecoder {

    struct tableHeader {
        var name: String
        var fromOffset: Int
        var thruOffset: Int
        var count: Int
    }

    struct table {
        var name: String
        var records: [[String]]
    }

    public static func decodeCustomerRetailerInfo(customer: CustomerRecord) -> RetailerInfo {
        RetailerInfoDecoder.decodeCustomerRetailerInfo(customer: customer)
    }

    public static func decodeMobileDownload(_ fileUrl: URL, _ databaseSource: MobileDownload.DatabaseSource) -> MobileDownload {
        let md = MobileDownload()

        md.databaseSource = databaseSource

        NSLog("MobileDownload #\(MobileDownload.numberOfInits): init() start")

        defer {
            NSLog("MobileDownload #\(MobileDownload.numberOfInits): init() \(md.isValid ? "completed" : "FAILED")")
        }

        //let sections = RawReaderForEncodedMobileDownload.getSections(fileUrl: fileUrl)
        let sections = MobileDownloadSectionReader.getSections(fileUrl: fileUrl)

        let magicString = sections.first?.first?.first
        if magicString != "EostarMobileDatabase" {
            return md
        }

        let tableHeaderSection = sections[2]
        let recordsSection = sections[3]

        md.header = MobileDownloadHeaderDecoder.decodeMobileDownloadHeader(headerSection: sections[1])

        func getRecNid(record: [String]) -> Int {
            guard let recNid = Int(record[0]) else { return 0 }
            return recNid
        }

        func getRecords(allRecords: [[String]], header: tableHeader) -> [[String]] {
            if header.count == 0 { return [] } // when count == 0, the thruOffset == fromOffset - 1 (a bad range)

            return Array(allRecords[header.fromOffset ... header.thruOffset])
        }

        let allRecords = recordsSection //Array(recordsSection[1...]) // convert the slice to an array

        let allTableHeaders = tableHeaderSection
            .filter { $0.count > 0 }
            .map { p in tableHeader(name: p[0], fromOffset: Int(p[1])!, thruOffset: Int(p[2])!, count: Int(p[3])!) }

        let tableHeaders = allTableHeaders.filter { $0.count > 0 }

        let tables = tableHeaders
            .map { p in table(name: p.name, records: getRecords(allRecords: allRecords, header: p)) }

        let tablesByName = tables.reduce(into: [String: table]()) { dict, rec in dict[rec.name] = rec }

        let taxRatesSection = sections[6]
        let customerArInfoSection = sections[7]
        let cusAllocationsSection = sections[8]
        let autoBumpRulesSection = sections[9]
        let scheduleSequencesSection = sections[10]
        let itemTransfersSection = sections[11]
        let purchasesSection = sections[12]
        _ = sections[13] // mpr: an empty section is now being sent from the web-service ... but, I still want to parse in case there's an old database: Thu Feb  5 10:55:15 EST 2009
        let inventoryTagsSection = sections[14]
        let tapHandlesSection = sections[15]
        let posRequestsSection = sections[16]
        let lastTruckInspectionSection = sections[17]
        let wineByTheGlassSection = sections[18]
        let taxScheduleDetailsSection = sections[19]
        let obsoleteCustomerProductTargetingRules = sections[20]
        let c2cSalesSection = sections[21]
        let palletLinesSection = sections[22]
        let predictedVendInfoSection = sections[23]
        let orderRequestsSection = sections[24]
        let customerNotesSection = sections[25]
        let companyGroupNotesSection = sections[26]
        let pendingReplenishmentOrdersSection = sections[27]
        let additionalInvoiceInfoSection = sections[28]
        let customerRetailPlanogramsSection = sections[29]
        let displayLocationsSection = sections[30]
        let displayLocationSurveysSection = sections[31]

        md.palletLines = PalletLinesDecoder.decodePalletLines(palletLinesSection: palletLinesSection)
        md.customerNotes = CustomerNotesDecoder.decodeCustomerNotes(customerNotesSection: customerNotesSection)
        md.callSequences = CallSequenceDecoder.decodeCallSequences(scheduleSequencesSection: scheduleSequencesSection)
        md.cusAllocations = CusAllocationsDecoder.decodeCusAllocations(cusAllocationsSection: cusAllocationsSection)
        md.taxRates = TaxRatesDecoder.decodeTaxRates(taxRatesSection: taxRatesSection)
        let allArInfoRecords = ArInfoDecoder.decodeArInfoRecords(arInfoSection: customerArInfoSection)
        md.arInfoRecords = Dictionary(grouping: allArInfoRecords, by: { $0.cusNid })
        md.tapHandles = TapHandlesDecoder.decodeTapHandles(tapHandlesSection: tapHandlesSection)

        md.lastTruckInspection = LastTruckInspectionDecoder.decodeLastTruckInspection(truckInspectionSection: lastTruckInspectionSection)

        loadAllRecords(md: md, tablesByName: tablesByName)

        // I'm leaving some encoded data in the returned database - so here're the routines to decode the
        // data when it's needed
        md.salesHistoryDecoder = CustomerSalesDecoder.decodeSalesHistory
        md.promoSectionDecoder = PromoItemDecoder.getPromoItemsAndNote

        md.databaseName = md.header.databaseName

        guard let databaseName = md.databaseName else {
            return md
        }

        if !autoBumpRulesSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding autoBumpRulesSection") }
        if !itemTransfersSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding itemTransfersSection") }
        if !purchasesSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding purchasesSection") }
        if !inventoryTagsSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding inventoryTagsSection") }
        if !posRequestsSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding posRequestsSection") }
        if !wineByTheGlassSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding wineByTheGlassSection") }
        if !taxScheduleDetailsSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding taxScheduleDetailsSection") }
        if !obsoleteCustomerProductTargetingRules.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding obsoleteCustomerProductTargetingRules") }
        if !c2cSalesSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding c2cSalesSection") }
        if !predictedVendInfoSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding predictedVendInfoSection") }
        if !orderRequestsSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding orderRequestsSection") }
        if !companyGroupNotesSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding companyGroupNotesSection") }
        if !pendingReplenishmentOrdersSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding pendingReplenishmentOrdersSection") }
        if !additionalInvoiceInfoSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding additionalInvoiceInfoSection") }
        if !customerRetailPlanogramsSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding customerRetailPlanogramsSection") }
        if !displayLocationsSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding displayLocationsSection") }
        if !displayLocationSurveysSection.isEmpty { print("Mobiledownload ERROR for \(databaseName): not decoding displayLocationSurveysSection") }

        return md
    }

    static func loadAllRecords(md: MobileDownload, tablesByName: [String: table]) {
        func encodedRecords(_ recordSet: RecordSet) -> [EncodedRecord] {
            let tablename = recordSet.tableName

            guard let table = tablesByName[tablename] else {
                return []
            }

            return table.records.map {
                EncodedRecord(name: table.name, $0)
            }
        }

        let handhelds = Records(encodedRecords(.Handhelds).map { HandheldRecord($0) })

        md.handheld = handhelds.getAll().first ?? HandheldRecord()

        md.actionItemTypes = Records(encodedRecords(.ActionItemTypes).map { ActionItemTypeRecord($0) })
        md.actionItems = Records(encodedRecords(.ActionItems).map { ActionItemRecord($0) })
        md.adAlerts = Records(encodedRecords(.AdAlerts).map { AdAlertRecord($0) })
        md.authorizedItemLists = Records(encodedRecords(.AuthorizedItemLists).map { AuthorizedItemListRecord($0) })
        md.backorderRequests = Records(encodedRecords(.BackorderRequests).map { BackorderRequestRecord($0) })
        md.barCodes = Records(encodedRecords(.BarCodes).map { BarCodeRecord($0) })
        md.beerAvailabilities = Records(encodedRecords(.BeerAvailabilities).map { BeerAvailabilityRecord($0) })
        md.beerBreweries = Records(encodedRecords(.BeerBreweries).map { BeerBreweryRecord($0) })
        md.beerCraftCategories = Records(encodedRecords(.BeerCraftCategories).map { BeerCraftCategoryRecord($0) })
        md.beerGlasswares = Records(encodedRecords(.BeerGlasswares).map { BeerGlasswareRecord($0) })
        md.beerRegionCategories = Records(encodedRecords(.BeerRegionCategories).map { BeerRegionCategoryRecord($0) })
        md.beerStyles = Records(encodedRecords(.BeerStyles).map { BeerStyleRecord($0) })
        md.beerTypes = Records(encodedRecords(.BeerTypes).map { BeerTypeRecord($0) })
        md.brandFamilies = Records(encodedRecords(.BrandFamilies).map { BrandFamilyRecord($0) })
        md.brands = Records(encodedRecords(.Brands).map { BrandRecord($0) })
        md.categories = Records(encodedRecords(.Categories).map { CategoryRecord($0) })
        md.chains = Records(encodedRecords(.Chains).map { ChainRecord($0) })
        md.companies = Records(encodedRecords(.Companies).map { CompanyRecord($0) })
        md.companyGroups = Records(encodedRecords(.CompanyGroups).map { CompanyGroupRecord($0) })
        md.complaintCodes = Records(encodedRecords(.ComplaintCodes).map { ComplaintCodeRecord($0) })
        md.contacts = Records(encodedRecords(.Contacts).map { ContactRecord($0) })
        md.containers = Records(encodedRecords(.Containers).map { ContainerRecord($0) })
        md.continents = Records(encodedRecords(.Continents).map { ContinentRecord($0) })
        md.coops = Records(encodedRecords(.Coops).map { CoopRecord($0) })
        md.counties = Records(encodedRecords(.Counties).map { CountyRecord($0) })
        md.countries = Records(encodedRecords(.Countries).map { CountryRecord($0) })
        md.creditCalendars = Records(encodedRecords(.CreditCalendars).map { CreditCalendarRecord($0) })
        md.crvContainerTypes = Records(encodedRecords(.CrvContainerTypes).map { CrvContainerTypeRecord($0) })
        md.currencies = Records(encodedRecords(.Currencies).map { CurrencyRecord($0) })
        md.cusLostReasons = Records(encodedRecords(.CusLostReasons).map { CusLostReasonRecord($0) })
        md.customerProductTargetingRules = Records(encodedRecords(.CustomerProductTargetingRules).map { CustomerProductTargetingRuleRecord($0) })
        md.customerSets = Records(encodedRecords(.CustomerSets).map { CustomerSetRecord($0) })
        md.customers = Records(encodedRecords(.Customers).map { CustomerRecord($0) })
        md.deliveries = Records(encodedRecords(.Deliveries).map { DeliveryRecord($0) })
        md.deliveryCharges = Records(encodedRecords(.DeliveryCharges).map { DeliveryChargeRecord($0) })
        md.displayLocationTypes = Records(encodedRecords(.DisplayLocationTypes).map { DisplayLocationTypeRecord($0) })
        md.dropPoints = Records(encodedRecords(.DropPoints).map { DropPointRecord($0) })
        md.ediPartners = Records(encodedRecords(.EdiPartners).map { TradingPartnerRecord($0) })
        md.employees = Records(encodedRecords(.Employees).map { EmployeeRecord($0) })
        md.equipment = Records(encodedRecords(.Equipment).map { EquipmentRecord($0) })
        md.equipmentModels = Records(encodedRecords(.EquipmentModels).map { EquipmentModelRecord($0) })
        md.equipmentTypes = Records(encodedRecords(.EquipmentTypes).map { EquipmentTypeRecord($0) })
        md.geographicAreas = Records(encodedRecords(.GeographicAreas).map { GeographicAreaRecord($0) })
        md.holdCodes = Records(encodedRecords(.HoldCodes).map { HoldCodeRecord($0) })
        md.invoiceLogos = Records(encodedRecords(.InvoiceLogos).map { InvoiceLogoRecord($0) })
        md.itemWriteoffs = Records(encodedRecords(.ItemWriteoffs).map { ItemWriteoffRecord($0) })
        md.items = Records(encodedRecords(.Items).map { ItemRecord($0) })
        md.manufacturers = Records(encodedRecords(.Manufacturers).map { ManufacturerRecord($0) })
        md.mboGoals = Records(encodedRecords(.MboGoals).map { MboGoalRecord($0) })
        md.mboIncentivePrograms = Records(encodedRecords(.MboIncentivePrograms).map { MboIncentiveProgramRecord($0) })
        md.messages = Records(encodedRecords(.Messages).map { MessageRecord($0) })
        md.minimumOrderQtys = Records(encodedRecords(.MinimumOrderQtys).map { MinimumOrderQtyRecord($0) })
        md.nonServiceReasons = Records(encodedRecords(.NonServiceReasons).map { NonServiceReasonRecord($0) })
        md.objectiveTypes = Records(encodedRecords(.ObjectiveTypes).map { ObjectiveTypeRecord($0) })
        md.objectives = Records(encodedRecords(.Objectives).map { ObjectiveRecord($0) })
        md.orderTypes = Records(encodedRecords(.OrderTypes).map { OrderTypeRecord($0) })
        md.ordersToPick = Records(encodedRecords(.OrdersToPick).map { OrderToPickRecord($0) })
        md.packageTypes = Records(encodedRecords(.PackageTypes).map { PackageTypeRecord($0) })
        md.packages = Records(encodedRecords(.Packages).map { PackageRecord($0) })
        md.paymentTerms = Records(encodedRecords(.PaymentTerms).map { PaymentTermRecord($0) })
        md.permits = Records(encodedRecords(.Permits).map { PermitRecord($0) })
        md.plants = Records(encodedRecords(.Plants).map { PlantRecord($0) })
        md.priceBasis = Records(encodedRecords(.PriceBasis).map { PriceBasisRecord($0) })
        md.priceBooks = Records(encodedRecords(.PriceBooks).map { PriceBookRecord($0) })
        md.priceRules = Records(encodedRecords(.PriceRules).map { PriceRuleRecord($0) })
        md.priceSheets = Records(encodedRecords(.PriceSheets).map { PriceSheetRecord($0) })
        md.productClasses = Records(encodedRecords(.ProductClasses).map { ProductClassRecord($0) })
        md.productSets = Records(encodedRecords(.ProductSets).map { ProductSetRecord($0) })
        md.promoCodes = Records(encodedRecords(.PromoCodes).map { PromoCodeRecord($0) })
        md.promoSections = Records(encodedRecords(.PromoSections).map { PromoSectionRecord($0) })
        md.purchaseCategories = Records(encodedRecords(.PurchaseCategories).map { PurchaseCategoryRecord($0) })
        md.retailInitiatives = Records(encodedRecords(.RetailInitiatives).map { RetailInitiativeRecord($0) })
        md.retailPlanograms = Records(encodedRecords(.RetailPlanograms).map { RetailPlanogramRecord($0) })
        md.retailPriceLists = Records(encodedRecords(.RetailPriceLists).map { RetailPriceListRecord($0) })
        md.retailerListTypes = Records(encodedRecords(.RetailerListTypes).map { RetailerListTypeRecord($0) })
        md.salesBalancingRules = Records(encodedRecords(.SalesBalancingRules).map { SalesBalancingRuleRecord($0) })
        md.salesChannels = Records(encodedRecords(.SalesChannels).map { SalesChannelRecord($0) })
        md.serviceZones = Records(encodedRecords(.ServiceZones).map { ServiceZoneRecord($0) })
        md.shelfSequences = Records(encodedRecords(.ShelfSequences).map { ShelfSequenceRecord($0) })
        md.shippers = Records(encodedRecords(.Shippers).map { ShipperRecord($0) })
        md.skinnyCustomers = Records(encodedRecords(.SkinnyCustomers).map { SkinnyCustomerRecord($0) })
        md.skinnyItems = Records(encodedRecords(.SkinnyItems).map { SkinnyItemRecord($0) })
        md.splitCaseCharges = Records(encodedRecords(.SplitCaseCharges).map { SplitCaseChargeRecord($0) })
        md.states = Records(encodedRecords(.States).map { StateRecord($0) })
        md.suppliers = Records(encodedRecords(.Suppliers).map { SupplierRecord($0) })
        md.surveys = Records(encodedRecords(.Surveys).map { SurveyRecord($0) })
        md.tapLocations = Records(encodedRecords(.TapLocations).map { TapLocationRecord($0) })
        md.taxAreas = Records(encodedRecords(.TaxAreas).map { TaxAreaRecord($0) })
        md.taxClasses = Records(encodedRecords(.TaxClasses).map { TaxClassRecord($0) })
        md.tdLinxFoodTypes = Records(encodedRecords(.TDLinxFoodTypes).map { TDLinxFoodTypeRecord($0) })
        md.tdLinxNeighborhoods = Records(encodedRecords(.TDLinxNeighborhoods).map { TDLinxNeighborhoodRecord($0) })
        md.tdLinxSubChannels = Records(encodedRecords(.TDLinxSubChannels).map { TDLinxSubChannelRecord($0) })
        md.tdLinxTradeChannels = Records(encodedRecords(.TDLinxTradeChannels).map { TDLinxTradeChannelRecord($0) })
        md.territories = Records(encodedRecords(.Territories).map { TerritoryRecord($0) })
        md.tiCategories = Records(encodedRecords(.TICategories).map { TICategoryRecord($0) })
        md.tiItems = Records(encodedRecords(.TIItems).map { TIItemRecord($0) })
        md.tradingPartnerSupplements = Records(encodedRecords(.TradingPartnerSupplements).map { TradingPartnerSupplementRecord($0) })
        md.trucks = Records(encodedRecords(.Trucks).map { TruckRecord($0) })
        md.uxFields = Records(encodedRecords(.UxFields).map { UxFieldRecord($0) })
        md.uxSurveyDownloadAnswers = Records(encodedRecords(.UxSurveyDownloadAnswers).map { UxSurveyDownloadAnswerRecord($0) })
        md.uxSurveyLines = Records(encodedRecords(.UxSurveyLines).map { UxSurveyLineRecord($0) })
        md.uxSurveys = Records(encodedRecords(.UxSurveys).map { UxSurveyRecord($0) })
        md.vendPlanograms = Records(encodedRecords(.VendPlanograms).map { VendPlanogramRecord($0) })
        md.voidReasons = Records(encodedRecords(.VoidReasons).map { VoidReasonRecord($0) })
        md.wBTGMenus = Records(encodedRecords(.WBTGMenus).map { WBTGMenuRecord($0) })
        md.warehouses = Records(encodedRecords(.Warehouses).map { WarehouseRecord($0) })
        md.webLinkAudiences = Records(encodedRecords(.WebLinkAudiences).map { WebLinkAudienceRecord($0) })
        md.webLinks = Records(encodedRecords(.WebLinks).map { WebLinkRecord($0) })
        md.wineAppellations = Records(encodedRecords(.WineAppellations).map { WineAppellationRecord($0) })
        md.wineCharacters = Records(encodedRecords(.WineCharacters).map { WineCharacterRecord($0) })
        md.wineClassifications = Records(encodedRecords(.WineClassifications).map { WineClassificationRecord($0) })
        md.wineColors = Records(encodedRecords(.WineColors).map { WineColorRecord($0) })
        md.wineRegions = Records(encodedRecords(.WineRegions).map { WineRegionRecord($0) })
        md.wineTypes = Records(encodedRecords(.WineTypes).map { WineTypeRecord($0) })
        md.wineVarietals = Records(encodedRecords(.WineVarietals).map { WineVarietalRecord($0) })
    }
}
