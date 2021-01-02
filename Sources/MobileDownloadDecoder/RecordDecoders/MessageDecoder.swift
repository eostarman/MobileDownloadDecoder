import MobileDownload

extension MessageRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        fromEmpNid = record.getRecNidOrZero()
        sentDate = record.getDateOrNil()

        while true {
            let string = record.getString()
            if string.isEmpty || string == "~" { // We're done with read/unread list
                break
            }

            // "4528,True" means empNid = 4528 has read the note already
            let empNids = string.components(separatedBy: ",")

            if empNids.count >= 1, let empNid = Int(empNids[1]) {
                toEmpNids.insert(empNid)

                if empNids.count >= 2, empNids[1].caseInsensitiveCompare("true") != .orderedSame {
                    unreadEmpNids.insert(empNid)
                }
            }
        }

        fromEmployeeRecName = record.getString()
    }
}
