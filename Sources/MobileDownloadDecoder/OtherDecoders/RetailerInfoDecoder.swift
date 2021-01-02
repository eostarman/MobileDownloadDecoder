//
//  RetailerInfoBlobService.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 9/18/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

/// decode the customer's retailerInfoBlob as transmitted in the MobileDownload
struct RetailerInfoDecoder {
    enum eToken: Character {
        case CusNid = "c"
        case RetailerListTypeNid = "l"
        case ListSectionBy = "x"
        case Description = "d"
        case SectionSectionBy = "s"
        case ItemSelection = "i"
        case PlacementType = "t"
        case AisleOrRegisterNumber = "a"
        case SectionRecNid = "r"
        case ManualSectionName = "m"
        case ItemNid = "f"
        case LocationPar = "o"
        case DisplaySequence = "p"
        case RetailerListEnd = "q"
        case Alphabetical = "b"
        case Automatic = "g"
        case EraseWhenPostingToSQL = "z"
        case UseRetailerPacks = "u"
        case RetailerItemNote_ItemNid = "I"
        case RetailerItemNote_NumericNote = "C"
        case RetailerItemNote_EmpNid = "E"
        case RetailerItemNote_NoteEntryDate = "D"
        case ObsoleteRetailerItemNote_MoreInfo = "M"
        case RetailerItemNote_EraseWhenPostingToSQL = "Z"
    }

    struct MyToken {
        let token: eToken
        let string: String
        var double: Double { Double(string) ?? 0 }
        var integer: Int { Int(string) ?? 0 }
        var bool: Bool { integer == 1 }
        var date: Date? { Date.fromDownloadedDate(string) }
    }

    static func decodeCustomerRetailerInfo(retailerInfoBlob: String) -> RetailerInfo {
        if retailerInfoBlob.isEmpty {
            return RetailerInfo()
        }

        let retailerInfo = RetailerInfo()
        var list = RetailerList()
        var section = RetailerList.Section()
        var item = RetailerList.Item()
        var itemNote = RetailerList.ItemNote()

        for myToken in getTokens(blob: retailerInfoBlob) {
            switch myToken.token {
            case .RetailerItemNote_EraseWhenPostingToSQL:
                itemNote.eraseWhenPostingToSQL = true
            case .RetailerItemNote_EmpNid:
                itemNote.empNid = myToken.integer
            case .RetailerItemNote_NoteEntryDate:
                itemNote.noteEntryDate = myToken.date ?? Date()
            case .RetailerItemNote_NumericNote:
                itemNote.numericNote = myToken.integer
            case .RetailerItemNote_ItemNid:
                itemNote.itemNid = myToken.integer
                retailerInfo.itemNotes.append(itemNote)
                itemNote = RetailerList.ItemNote()

            case .CusNid:
                retailerInfo.cusNid = myToken.integer

            case .EraseWhenPostingToSQL:
                list.eraseWhenPostingToSQL = true
            case .RetailerListTypeNid:
                list.retailerListTypeNid = myToken.integer

                // defer to the fixup() routine (since mobileDownload isn't fully decoded yet)
                // let retailerListType = mobileDownload.retailerListTypes[myToken.integer]
                // list.retailerListCategory = retailerListType.retailerListCategory
                // list.retailerListTypeRecName = retailerListType.recName

            case .DisplaySequence:
                list.displaySequence = myToken.integer

            case .Description:
                list.description = myToken.string

            case .ListSectionBy:
                list.sectionBy = eRetailerListSectionBy(rawValue: myToken.integer) ?? .NoSections
            case .ItemSelection:
                list.itemSelection = eRetailerListItemSelection(rawValue: myToken.integer) ?? .AllItems
            case .PlacementType:
                list.placementType = eRetailPlacementType(rawValue: myToken.integer) ?? .NoPlacementInfo

            case .AisleOrRegisterNumber:
                list.aisleOrRegisterNumber = myToken.integer

            case .LocationPar:
                item.locationPar = myToken.double
            case .ItemNid:
                item.itemNid = myToken.integer
                section.items.append(item)
                item = RetailerList.Item()

            case .ManualSectionName:
                section.manualSectionName = myToken.string
            case .SectionSectionBy:
                section.sectionBy = eRetailerListSectionBy(rawValue: myToken.integer) ?? .NoSections
            case .SectionRecNid:
                section.sectionRecNid = myToken.integer
                list.sections.append(section)
                section = RetailerList.Section()

            case .RetailerListEnd:

                if list.isBackstock {
                    retailerInfo.backstockLocations.append(list)
                } else if list.isRetailLocation {
                    retailerInfo.retailLocations.append(list)
                } else {
                    retailerInfo.productLists.append(list)
                }
                list = RetailerList()

            case .Alphabetical:
                list.isAlphabetical = myToken.bool
            case .Automatic:
                list.isAutomatic = myToken.bool
            case .UseRetailerPacks:
                list.usesRetailerPacks = true // noted in c# as being "unreliable" myToken.bool
            case .ObsoleteRetailerItemNote_MoreInfo:
                break
            }
        }


        return retailerInfo
    }

    /// this is encoded as a value followed by a token (the value is either a string like ~xxx~ or a number - not both)
    private static func getTokens(blob: String) -> [MyToken] {
        var tokens = [MyToken]()

        var isGatheringString = false
        var charactersInValue = [Character]()

        let numerics = Set<Character>(["-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])

        for chr in blob {
            if isGatheringString {
                if chr == "~" {
                    isGatheringString = false
                } else {
                    charactersInValue.append(chr)
                }
                continue
            }

            if chr == "~" {
                isGatheringString = true
                continue
            }

            if numerics.contains(chr) {
                charactersInValue.append(chr)
                continue
            }

            if let token = eToken(rawValue: chr) {
                let string = String(charactersInValue)

                let myToken = MyToken(token: token, string: string)
                tokens.append(myToken)
            }

            charactersInValue = []
        }

        return tokens
    }
}

extension RetailerInfo {

    func fixup(mobileDownload: MobileDownload) {

        // mpr: I think we can get rid of a lot of this (it's lifted from c# RetailerInfo.cs)
        for list in allRetailAndBackstockLocations {
            list.cusNid = cusNid

            let retailerListType = mobileDownload.retailerListTypes[list.retailerListTypeNid]

            list.retailerListCategory = retailerListType.retailerListCategory
            list.retailerListTypeRecName = retailerListType.recName

            var sectionNumber = 0
            for section in list.sections {
                section.sectionNumber = sectionNumber
                section.cusNid = cusNid
                section.retailerListTypeNid = list.retailerListTypeNid
                sectionNumber += 1

                var itemDisplaySequence = 0
                for item in section.items {
                    item.displaySequence = itemDisplaySequence
                    item.cusNid = cusNid
                    item.retailerListTypeNid = list.retailerListTypeNid
                    item.sectionNumber = section.sectionNumber

                    itemDisplaySequence += 1
                }
            }
        }

        // now, do a bit of "cleanup" - c#: GetRetailInfoCleanedUpAfterFromBlob()
        for note in itemNotes {
            note.cusNid = cusNid
        }
    }
}
