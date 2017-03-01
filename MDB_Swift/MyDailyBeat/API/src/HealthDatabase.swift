//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  HealthDatabase.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
public class HealthDatabase: NSObject {

    var docDir: String = ""
    var dbFilename: String = ""

    public func prescripProviders() -> [PrescripProviderInfo] {
        var retval = [PrescripProviderInfo]()
//        var sqLiteDb: String = URL(fileURLWithPath: self.docDir).appendingPathComponent(self.dbFilename).absoluteString
//        if sqlite3_open(sqLiteDb.utf8, self.database) != SQLITE_OK {
//            print("Failed to open database!")
//        }
//        else {
//            var query: String = "SELECT rowid, URL, logoURL FROM prescripProviders ORDER BY rowid ASC"
//            var statement: sqlite3_stmt?
//            if sqlite3_prepare_v2(self.database, query.utf8, -1, statement, nil) == SQLITE_OK {
//                while sqlite3_step(statement) == SQLITE_ROW {
//                    var uniqueId: Int = sqlite3_column_int(statement, 0)
//                    var nameChars = CChar(sqlite3_column_text(statement, 1))
//                    var appChars = CChar(sqlite3_column_text(statement, 2))
//                    var name = String(utf8String: nameChars)
//                    var appURL = String(utf8String: appChars)
//                    var info = PrescripProviderInfo(uniqueId: uniqueId, url: name, logoURL: appURL)
//                    retval.append(info)
//                }
//                sqlite3_finalize(statement)
//            }
//        }
//        sqlite3_close(self.database)
        return retval
    }

    public func healthPortals() -> [HealthInfo] {
        var retval = [HealthInfo]()
//        var sqLiteDb: String = URL(fileURLWithPath: self.docDir).appendingPathComponent(self.dbFilename).absoluteString
//        if sqlite3_open(sqLiteDb.utf8, self.database) != SQLITE_OK {
//            print("Failed to open database!")
//        }
//        else {
//            var query: String = "SELECT rowid, URL, logoURL FROM healthPortals ORDER BY rowid ASC"
//            var statement: sqlite3_stmt?
//            if sqlite3_prepare_v2(self.database, query.utf8, -1, statement, nil) == SQLITE_OK {
//                while sqlite3_step(statement) == SQLITE_ROW {
//                    var uniqueId: Int = sqlite3_column_int(statement, 0)
//                    var urlChars = CChar(sqlite3_column_text(statement, 1))
//                    var logoChars = CChar(sqlite3_column_text(statement, 2))
//                    var URL = String(utf8String: urlChars)
//                    var logoURL = String(utf8String: logoChars)
//                    var info = HealthInfo(uniqueId: uniqueId, url: URL, logoURL: logoURL)
//                    retval.append(info)
//                }
//                sqlite3_finalize(statement)
//            }
//        }
//        sqlite3_close(self.database)
        return retval
    }

    public func insert(intoDatabase healthPortalOrNil: HealthInfo?, orPrescriptionProvider prescripProviderOrNil: PrescripProviderInfo?) {
        var sqLiteDb: String = URL(fileURLWithPath: self.docDir).appendingPathComponent(self.dbFilename).absoluteString
//        if sqlite3_open(sqLiteDb.utf8, self.database) != SQLITE_OK {
//            print("Failed to open database!")
//        }
//        else {
//            if prescripProviderOrNil != nil {
//                    // prescrip providers
//                var query: String = "create table if not exists prescripProviders(URL text, logoURL text)"
//                let qstring = query.utf8
//                var errMsg: [CChar]
//                var prepareStatementResult: Int = sqlite3_exec(self.database, qstring, nil, nil, errMsg)
//                if prepareStatementResult == SQLITE_OK {
//                    var query2: String = "insert into prescripProviders values('\(prescripProviderOrNil.url)', '\(prescripProviderOrNil.logoURL)')"
//                    let qstring2 = query2.utf8
//                    var errMsg2: [CChar]
//                        // Load all data from database to memory.
//                    var prepareStatementResult2: Int = sqlite3_exec(self.database, qstring2, nil, nil, errMsg2)
//                    if prepareStatementResult2 == SQLITE_OK {
//
//                    }
//                    else {
//                        print("Error: \(errMsg2)")
//                    }
//                }
//                else {
//                    print("Error: \(errMsg)")
//                }
//            }
//            else {
//                    // health portals
//                var query: String = "create table if not exists healthPortals(URL text, logoURL text)"
//                let qstring = query.utf8
//                var errMsg: [CChar]
//                var prepareStatementResult: Int = sqlite3_exec(self.database, qstring, nil, nil, errMsg)
//                if prepareStatementResult == SQLITE_OK {
//                    var query2: String = "insert into healthPortals values('\(healthPortalOrNil.url)', '\(healthPortalOrNil.logoURL)')"
//                    let qstring2 = query2.utf8
//                    var errMsg2: [CChar]
//                        // Load all data from database to memory.
//                    var prepareStatementResult2: Int = sqlite3_exec(self.database, qstring2, nil, nil, errMsg2)
//                    if prepareStatementResult2 == SQLITE_OK {
//
//                    }
//                    else {
//                        print("Error: \(errMsg2)")
//                    }
//                }
//                else {
//                    print("Error: \(errMsg)")
//                }
//            }
//        }
//        sqlite3_close(self.database)
    }

    public static var database: HealthDatabase!

    override init() {
        super.init()
        
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        self.docDir = paths[0] as! String
        self.dbFilename = "healthlist.sql"
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
