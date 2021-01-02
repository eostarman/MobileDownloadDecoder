import MobileDownload

import Foundation

extension RetailPlanogramRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        activeFlag = record.getBool(3)
        addedByEmpNid = record.getRecNidOrNil(4)
        addedTime = record.getDateTimeOrNil(5)
        description = record.getString(6)
        retailPlanogramVisualURL = record.getString(7)
        readyToDeploy = record.getBool(8)
        retailPlanogramLocations = record.getString(9)
    }
}
