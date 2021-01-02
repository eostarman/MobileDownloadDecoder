//
//  eToken.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 8/31/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

extension MobileOrder {
    enum orderTokenType: String { // aka 'eToken.cs'
        // case zzz_AutoPrice = "E"
        // case zzz_Promo1Disc = "H"

        case OrderNumber = "a"
        case CusNid = "b"
        case DeliveryDate = "c"
        case DriverNid = "d"
        case TaxableFlag = "e"
        case PONum = "f"
        case PlacedWith = "g"
        case DeliveryNote = "h"
        case DiscountAmt = "i"
        case TotalTax = "j"
        case OrderType = "k"
        case IsExistingOrder = "l"
        case ReceivedBy = "m"
        case IsChargeFlag = "n"
        case PaymentTermsNid = "o"
        case OffInvoiceDiscPct = "p"
        case TotalFreight = "q"
        case TrkNid = "r"
        case SlsEmpNid = "s"
        case EntryTime = "t" // not used (only seen in Legacy - pre 2011 - MobileUploads)
        case PushOffDate = "u"
        case VoidedStatus = "v"
        case WhseNid = "w"
        case DeliveredStatus = "x"
        case VoidReason = "y"
        case PushOffReason = "z"
        case PackNote = "%"

        case ItemNid = "A" // using CAPS for tokens that are related to line-items (no real reason for this ...)
        case QtyOrdered = "B"
        case UnitPrice = "C"
        case UnitDisc = "D"
        case UnitSplitCaseCharge = "\\"

        case Promo1Nid = "F"
        case ItemWriteoffNid = "J"
        case HeldStatus = "K"
        case ItemNameOverride = "L"
        case IsFromDistributor = "M"
        case IsToDistributor = "N"
        case SerializedItems = "O"
        case NumberSummarized = "P"
        case SummaryOrderNumber = "Q"
        case QtyShipped = "R"
        case UnitDeposit = "S"
        case CoopTicketNumber = "0"
        case ShipAdr1 = "_"
        case ShipAdr2 = "<"
        case ShipCity = ">"
        case ShipState = "&"
        case ShipZip = "="
        case IsHotShot = "π"

        case UnitFreight = "G"
        case UnitDeliveryCharge = "I"

        case EFTFlag = "T"
        case BuildTo = "U"
        case Count = "V"
        case RouteBookBuildTo = "{"
        case IsEarlyPay = "W"
        case EarlyPayDiscountAmt = "X"
        case TermDiscountDays = "Y"
        case TermDiscountPct = "Z"

        case OrderTypeNid = "@"

        case SalesTaxCounty = "1"
        case SalesTaxState = "2"
        case SalesTaxLocal = "3"
        case SalesTaxCity = "4"
        case SalesTaxWholesale = "."

        case PrintedReviewInvoice = "?"
        case IsBulkOrderFlag = "*"
        case ShelfCount = "^"
        case IsNewBuildTo = "~"
        case IsBillAndHold = "|"

        case IsAutoDeliveryCharge = "("
        case DeliveryChargeNid = ")"
        case QtyDeliveryDriverAdjustment = "["
        case IsNewlyAddedItem = "]"
        case UsedCombinedForm = "#"
        case RetailPrice = "}"
        case EditedRetailPrice = "+"
        case MergeSequenceTag = "$"
        case AutoFreeGoodsLine = "`"

        case RetailDateCode = "5" // KJQ 5/11/10 ... only used on mobile devices
        case RetailDateCodeQty = "6" // KJQ 5/11/10 ... only used on mobile devices
        case EditedRetailDateCodeEntry = "7" // KJQ 5/11/10 ... only used on mobile devices

        case CarrierDeposit = "8"
        case IsPreferredFreeGoodLine = "9"
        case ParentOrderedDate = "!"
        case ParentSlsEmpNid = "-"
        case VoidReasonNid = ":"
        case CompanyNid = ";"
        case QtyShippedWhenOpened = "/" // CDF 1/20/12 ... only used on mobile devices
        case CommaCommand = ","

        //  VAT = " " // TODO FIGURE OUT TOKEN
        //  Levy = " ' // TODO FIGURE OUT TOKEN
    }
}
