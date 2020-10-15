//
//  Data.swift
//  Covid-19-UIKit
//
//  Created by Juan Capponi on 10/12/20.
//

struct Daily: Identifiable{
    
    var id : Int
    var day : String
    var cases : Int
}

struct MainData : Decodable{
    
    var deaths : Int
    var recovered : Int
    var active : Int
    var critical : Int
    var cases : Int
}

struct MyCountry : Decodable {
    
    var timeline : [String : [String : Int]]
}

struct Global : Decodable {
    
    var cases : [String : Int]
}

/*
 
 URL: https://disease.sh/v3/covid-19/countries/argentina?lastdays=7
 
 {
     "updated": 1602540698231,
     "country": "Argentina",
     "countryInfo": {
         "_id": 32,
         "iso2": "AR",
         "iso3": "ARG",
         "lat": -34,
         "long": -64,
         "flag": "https://disease.sh/assets/img/flags/ar.png"
     },
     "cases": 894206,
     "todayCases": 0,
     "deaths": 23868,
     "todayDeaths": 0,
     "recovered": 721380,
     "todayRecovered": 0,
     "active": 148958,
     "critical": 4237,
     "casesPerOneMillion": 19735,
     "deathsPerOneMillion": 527,
     "tests": 2225558,
     "testsPerOneMillion": 49117,
     "population": 45311598,
     "continent": "South America",
     "oneCasePerPeople": 51,
     "oneDeathPerPeople": 1898,
     "oneTestPerPeople": 20,
     "activePerOneMillion": 3287.41,
     "recoveredPerOneMillion": 15920.43,
     "criticalPerOneMillion": 93.51
 }
 
 
 
 URL: https://corona.lmao.ninja/v2/historical/argentina?lastdays=7
 
 Json Response:
 
 {
     "country": "Argentina",
     "province": [
         "mainland"
     ],
     "timeline": {
         "cases": {
             "10/5/20": 809728,
             "10/6/20": 824468,
             "10/7/20": 840915,
             "10/8/20": 856369,
             "10/9/20": 871468,
             "10/10/20": 883882,
             "10/11/20": 894206
         },
         "deaths": {
             "10/5/20": 21468,
             "10/6/20": 21827,
             "10/7/20": 22226,
             "10/8/20": 22710,
             "10/9/20": 23225,
             "10/10/20": 23581,
             "10/11/20": 23868
         },
         "recovered": {
             "10/5/20": 649017,
             "10/6/20": 660272,
             "10/7/20": 670725,
             "10/8/20": 684844,
             "10/9/20": 697141,
             "10/10/20": 709464,
             "10/11/20": 721380
         }
     }
 }
 
 */

