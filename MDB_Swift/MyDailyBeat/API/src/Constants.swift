//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  Constants.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
#if !VerveAPI_Constants_h
//#define VerveAPI_Constants_h
public let WELCOME_MESSAGE_1 = "You are about to join the most vibrant community for older adults.\n\nLook No Further!"
public let WELCOME_MESSAGE_2 = "Let MyDailyBeat be the place you come to every day to help manage your personal life, keep you engaged, socialize, and stay connected."
let APP_ID_C_STRING = "com.verve.MyDailyBeat"
let APP_ID_NSSTRING = "com.verve.MyDailyBeat"
public let ASSET_FILENAME = "asset.JPG"
public enum SexualPreference : Int {
    case manLookingForWoman = 0
    case womanLookingForMan = 1
    case manLookingForMan = 2
    case womanLookingForWoman = 3
    case coupleLookingForCouple = 4
    case bisexualLookingForBisexual = 5
}

public let KEY_SCREENNAME = "screenName"
public let KEY_PASSWORD = "password"
public let CREATE_NEW_GROUP = "New Group"
public let GENDER_STRING_LIST = ["Male", "Female", "Transgender Male", "Transgender Female"]
public let STATUS_STRING_LIST = ["Single", "Married", "Widow/Widower"]
public let ETHNICITY_STRING_LIST_1 = ["White/Caucasian", "Black/African-American", "Asian", "Native American Indian/Native Alaskan", "Latino/Hispanic", "Other"]
public let ETHNICITY_STRING_LIST_2 = ["White/Caucasian", "Black/African-American", "Asian", "Native American Indian/Native Alaskan", "Latino/Hispanic", "No Preference"]
public let DRINKER_STRING_LIST = ["I don't drink.", "I seldom drink.", "I enjoy drinking regularly."]
public let BELIEFS_STRING_LIST_1 = ["Buddhist", "Christian", "Catholic", "Hindu", "Jewish", "Muslim", "Agnostic", "Non-religious", "Other"]
public let BELIEFS_STRING_LIST_2 = ["Buddhist", "Christian", "Catholic", "Hindu", "Jewish", "Muslim", "Agnostic", "Non-religious", "No preference"]
public let CONTACT_STRING_LIST = ["MDB online chat", "Mobile - phone/text", "Email", "In person"]
public let AGE_STRING_LIST = ["50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94", "95-99", "100+"]
public let RELATIONSHIP_STRING_LIST = ["Fling", "Companionship", "Committed Relationship"]
public let TOP_TEN_BANKS = ["JPMorgan Chase", "Bank of America", "Citigroup", "Wells Fargo", "The Bank of New York Mellon", "U.S. Bancorp", "HSBC Bank USA", "Capital One", "PNC Financial Services", "State Street Bank", "TD Bank", "BB&T", "SunTrust Banks", "American Express", "Ally Financial", "Santander", "Citizen's Bank", "Eastern Bank"]
public let TRAVEL_SITES = ["kayak.com", "hotels.com", "priceline.com", "orbitz.com", "travelocity.com", "expedia.com", "BreadAndBreakfast.com", "airbnb.com", "Hotwire.com", "cruises.com", "GrandcircleCruiseline.com", "Cheaptickets.com", "Onetravel.com", "CheapAir.com", "fly.com"]
public let PRESCRIP_PROVIDERS = ["caremark.com", "drugstore.com", "familymeds.com", "express-scripts.com"]
public let PRESCRIP_PROVIDER_LOGO_URLS = ["http://info.caremark.com/images/Caremark_Microsite_images/Header/default/caremark_logo/CVS-Caremark-Logo.png", "http://www.drugstore.com/img/sites/0/ds_logo_context.gif", "http://www.familymeds.com/images/jpegs/logo.jpg", "https://www.express-scripts.com/wps/themes/html/SelfService/images/esiLogo.gif"]
public let HEALTH_PORTALS = ["myhealth.atriushealth.org", "myhealthrecord.com", "www.nextmd.com", "my.patientfusion.com", "www.mymedicalencounters.com", "chartmakerpatientportal.com", "app.relayhealth.com"]
public let HEALTH_PORTAL_LOGO_URLS = ["https://rmbt.atriushealth.org/AtriusHealth.jpg", "http://www.greenwayhealth.com/wp-content/themes/greenway_responsive/images/logo.svg", "http://www.memorialcare.org/sites/default/files/nextmd-logo-280_0.png", "https://www.patientfusion.com/content/images/patientFusion-logo-blue.png", "https://www.mymedicalencounters.com/logos/patportal_logo2.jpg", "http://sticomputer.com/newwebsite/wp-content/themes/sti/images/logo.png", "http://media.relayhealth.com/designimages/RelayHealth-Logo-Full-Color-Tagline-new-palette.jpg"]
// hex color
//#define UIColor(netHex: rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
public let RES_LINKS = Bundle.main.path(forResource: "res_links", ofType: "plist")
public enum EVCUserInviteSendingMethod : Int {
    case sendByEmail = 0
    case sendByMobile = 1
}

public enum UserSearchType : Int {
    case searchByScreenName = 0
    case searchByName = 1
    case searchByEmail = 2
}

public enum EVCSearchSortOrder : Int {
    case ascending = 0
    case descending = 1
}

public enum REL_MODE : Int {
    case friends_MODE = 0
    case fling_MODE = 1
    case relationship_MODE = 2
}
public let BLUR_VIEW_TAG = 9001
public let PLACES_API_KEY = "AIzaSyD12-W6HiSv3gVnCIQSUCvDTNtXrQRp1o8"
#endif
