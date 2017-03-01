//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  BankDatabase.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/20/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation

public class BankDatabase: NSObject {

    var docDir: String = ""
    var dbFilename: String = ""

    public func bankInfos() -> [BankInfo] {
        var retval = [BankInfo]()
//        var sqLiteDb: String = URL(fileURLWithPath: self.docDir).appendingPathComponent(self.dbFilename).absoluteString
//        if sqlite3_open(sqLiteDb.utf8, self.database) != SQLITE_OK {
//            print("Failed to open database!")
//        }
//        else {
//            var query: String = "SELECT rowid, appName, appURL, iconURL FROM banks ORDER BY appName ASC"
//            var statement: sqlite3_stmt?
//            if sqlite3_prepare_v2(self.database, query.utf8, -1, statement, nil) == SQLITE_OK {
//                while sqlite3_step(statement) == SQLITE_ROW {
//                    var uniqueId: Int = sqlite3_column_int(statement, 0)
//                    var nameChars = CChar(sqlite3_column_text(statement, 1))
//                    var appChars = CChar(sqlite3_column_text(statement, 2))
//                    var iconChars = CChar(sqlite3_column_text(statement, 3))
//                    var name = String(utf8String: nameChars)
//                    var appURL = String(utf8String: appChars)
//                    var iconURL = String(utf8String: iconChars)
//                    uniqueId = CInt(appURL.replacingOccurrences(of: "itms-apps://itunes.apple.com/app/id", with: ""))
//                    var info = BankInfo(uniqueId: uniqueId, name: name, appURL: appURL, iconURL: iconURL)
//                    retval.append(info)
//                }
//                sqlite3_finalize(statement)
//            }
//        }
//        sqlite3_close(self.database)
        return retval
    }

    public func insert(intoDatabase bank: BankInfo) {
//        var sqLiteDb: String = URL(fileURLWithPath: self.docDir).appendingPathComponent(self.dbFilename).absoluteString
//        if sqlite3_open(sqLiteDb.utf8, self.database) != SQLITE_OK {
//            print("Failed to open database!")
//        }
//        else {
//            var query: String = "create table if not exists banks(appName text, appURL text, iconURL text)"
//            let qstring = query.utf8
//            var errMsg: [CChar]
//            var prepareStatementResult: Int = sqlite3_exec(self.database, qstring, nil, nil, errMsg)
//            if prepareStatementResult == SQLITE_OK {
//                var query2: String = "insert into banks values('\(bank.appName)', '\(bank.appURL)', '\(bank.iconURL)')"
//                let qstring2 = query2.utf8
//                var errMsg2: [CChar]
//                    // Load all data from database to memory.
//                var prepareStatementResult2: Int = sqlite3_exec(self.database, qstring2, nil, nil, errMsg2)
//                if prepareStatementResult2 == SQLITE_OK {
//
//                }
//                else {
//                    print("Error: \(errMsg2)")
//                }
//            }
//            else {
//                print("Error: \(errMsg)")
//            }
//        }
//        sqlite3_close(self.database)
    }

    public static var database: BankDatabase!

    override init() {
        super.init()
        
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        self.docDir = paths[0] as! String
        self.dbFilename = "banklist.sql"
        self.copyIntoDocDir()
    
    }

    func copyIntoDocDir() {
        var dest: String = URL(fileURLWithPath: self.docDir).appendingPathComponent(self.dbFilename).absoluteString
        if !FileManager.default.fileExists(atPath: dest) {
            var source: String = URL(fileURLWithPath: (Bundle.main.resourcePath)!).appendingPathComponent(self.dbFilename).absoluteString
            var error: Error?
            try? FileManager.default.copyItem(atPath: source, toPath: dest)
            if error != nil {
                print("\(error?.localizedDescription)")
            }
        }
    }
}
