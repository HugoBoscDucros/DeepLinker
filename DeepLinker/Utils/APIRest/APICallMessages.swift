//
//  File.swift
//  Padam
//
//  Created by Hugo Bosc-Ducros on 02/03/2017.
//  Copyright © 2017 OPTIWAYS SAS. All rights reserved.
//

import Foundation


/********
 MARK: - API response managing
 ********/

//var localBundle:Bundle {
//    return Bundle(for: Padam.self)
//}

let HTTP_ERROR_MESSAGE_BEGININ = NSLocalizedString("HTTP_ERROR_MESSAGE_BEGININ", tableName: "APICallMessages", comment: "")
let HTTP_ERROR_MESSAGE_END = NSLocalizedString("HTTP_ERROR_MESSAGE_END", tableName: "APICallMessages", comment: "")
let HTTP_3000_ERROR_END_MESSAGE = NSLocalizedString("HTTP_3000_ERROR_END_MESSAGE", tableName: "APICallMessages", comment: "")
let TIMEOUT_ERROR_MESSAGE = NSLocalizedString("TIMEOUT_ERROR_MESSAGE", tableName: "APICallMessages", comment: "")
let NETWORK_ERROR_MESSAGE = NSLocalizedString("NETWORK_ERROR_MESSAGE", tableName: "APICallMessages", comment: "")


//server test
let SERVER_TEST_SUCCEED_MESSAGE = NSLocalizedString("SERVER_TEST_SUCCEED_MESSAGE", tableName: "APICallMessages", comment: "")
let SERVER_TEST_WITH_TOKEN_SUCCED_MESSAGE = NSLocalizedString("SERVER_TEST_WITH_TOKEN_SUCCED_MESSAGE", tableName: "APICallMessages", comment: "")


/**********
 MARK: - Google API
 **********/

public let FAILED_GET_USER_LOCATION = NSLocalizedString("FAILED_GET_USER_LOCATION", tableName: "APICallMessages", comment: "")
public let FAILED_GET_PLACE_DETAILS = NSLocalizedString("FAILED_GET_PLACE_DETAILS", tableName: "APICallMessages", comment: "")
