//
//  GooglePlaceAutocompleteDataSource.swift
//  DeepLinker
//
//  Created by Hugo Bosc-Ducros on 24/03/2020.
//  Copyright © 2020 HBD. All rights reserved.
//

import Foundation
import UIKit
import HBAutocomplete

class GooglePlaceAutocompleteDataSource:HBAutocompleteDataSource {
    
    let GOOGLE_API_ROOT_PATH = "https://maps.googleapis.com/maps/api/"
    let GOOGLE_PLACE_API_AUTOCOMPLETE_PATH = "place/autocomplete/"
    let GOOGLE_PLACE_API_KEY = //here put your google place API key

    func getSuggestions(autocomplete: HBAutocomplete, input: String, completionHandler: @escaping ([String], [String : Any]?, [String : UIImage]?) -> Void) {
        self.AutocompleteSuggestions(input) { (suggestions) in
            completionHandler(suggestions.map{$0.0}, nil, nil)
        }
    }
    
    private func AutocompleteSuggestions(
        _ input:String,
        completionHandler:@escaping (_ suggestions:[(address:String,placeId:String, placeTypes:[String])]) -> Void) {
        
        //make URL path
        let url = self.makeAutocompleteURLForAPICall(input)
        var suggestions:[(String,String,[String])] = []
        //let places = NSMutableDictionary()
        
        //make API call
        PRestAPICallManager.restAPICall(.get, url: url, postParams: nil, timeOut: 10, accessToken: nil, success: { (jsonResponse, _, _) in
            if let jsonResponseDictionary = jsonResponse as? [String:Any], let suggestionsArray = jsonResponseDictionary["predictions"] as? NSArray {
                for value in suggestionsArray {
                    if let valueDictionary = value as? NSDictionary {
                        if let description = valueDictionary["description"] as? String, let placeId = valueDictionary["place_id"] as? String, let placeTypes = valueDictionary["types"] as? [String] {
                            //suggestions[description] = placeId
                            suggestions.append((description,placeId, placeTypes))
                            //let place = Place(description: description, placeId: placeId)
                            //places.setValue(place, forKey: description)
                        } else {
                            print("One key is not founded in google prediction response")
                        }
                    }
                }
                DispatchQueue.main.async {
                    completionHandler(suggestions)
                }
            }
        }) { (error,_) in
            print(error.localizedDescription)
        }
    }
    
    private func makeAutocompleteURLForAPICall(
        _ input:String,
        language:String? = Locale.current.languageCode,
        radius:String? = nil) -> URL {
        var stringURL = "\(GOOGLE_API_ROOT_PATH)\(GOOGLE_PLACE_API_AUTOCOMPLETE_PATH)json?input=\(input)&key=\(GOOGLE_PLACE_API_KEY)"
        if let language = language {
            stringURL += "&language=\(language)"
        }
        if let radius = radius {
            stringURL += "&radius=\(radius)"
        }
            let UTF8URL = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let url = URL(string:UTF8URL!)
            print("url : \(url!)")
        return url!
    }
}
