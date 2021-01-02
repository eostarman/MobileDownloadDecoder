//
//  RetailInitiativeParser.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 9/10/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

/// parse the retail initiative information downloaded from eonetservice as XML
class RetailInitiativeXMLDecoder: NSObject, XMLParserDelegate {
    var sections: [RetailInitiative.Section] = []

    var section: RetailInitiative.Section?

    func parse(xml: String) -> [RetailInitiative.Section] {
        let xmlData = xml.data(using: .utf8)!
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
        return sections
    }

    func parser(_: XMLParser, didStartElement elementName: String, namespaceURI _: String?, qualifiedName _: String?, attributes attributeDict: [String: String] = [:]) {
        func getSectionHeader() -> RetailInitiative.Section? {
            if let description = attributeDict["Description"],
               let sequence = Int(attributeDict["Sequence"] ?? "")
            {
                return RetailInitiative.Section(description: description, sequence: sequence)
            }
            return nil
        }

        // <DocumentItem Sequence="0" Description="4th of July theme" DocumentURL="http://www.wiki-eostar.com/images/2/2d/Eagle_800.jpg" />
        func getDocumentLink() -> RetailInitiative.DocumentLink? {
            if let description = attributeDict["Description"],
               let sequence = Int(attributeDict["Sequence"] ?? ""),
               let documentURL = URL(string: attributeDict["DocumentURL"] ?? "")
            {
                return RetailInitiative.DocumentLink(description: description, sequence: sequence, documentURL: documentURL)
            }
            return nil
        }

        // <ObjectiveItem Sequence="0" Description="Display objective" ObjectiveTypeNid="1" ObjectiveStartDate="2019-05-21" ObjectiveDueByDate="2019-06-07" SqlDescription="Sell in Swing into Summer display" />
        func getObjective() -> RetailInitiative.Objective? {
            let objectiveTypeNid = Int(attributeDict["ObjectiveTypeNid"] ?? "")
            let supNid = Int(attributeDict["SupNid"] ?? "")
            let startDate = Date.fromDownloadedDate(attributeDict["ObjectiveStartDate"] ?? "")
            let dueByDate = Date.fromDownloadedDate(attributeDict["ObjectiveDueByDate"] ?? "")
            let sqlDescription = attributeDict["SqlDescription"] ?? ""

            if let description = attributeDict["Description"],
               let sequence = Int(attributeDict["Sequence"] ?? "")
            {
                return RetailInitiative.Objective(description: description, sequence: sequence, objectiveTypeNid: objectiveTypeNid, supNid: supNid, startDate: startDate, dueByDate: dueByDate, sqlDescription: sqlDescription)
            }

            return nil
        }

        if elementName == "Section" {
            section = getSectionHeader()
        } else if let section = section {
            if elementName == "DocumentItem" {
                if let documentLink = getDocumentLink() {
                    section.items.append(documentLink)
                }
            } else if elementName == "ObjectiveItem" {
                if let objective = getObjective() {
                    section.items.append(objective)
                }
            }
        }
    }

    func parser(_: XMLParser, didEndElement elementName: String, namespaceURI _: String?, qualifiedName _: String?) {
        if elementName == "Section" {
            if let section = section {
                sections.append(section)
            }
            section = nil
        }
    }
}
