//
//  ViewModel.swift
//  Covid-19-UIKit
//
//  Created by Juan Capponi on 10/12/20.
//

import Foundation

class ViewModel {
    
    init(){
        }
    
    func getinfoCovid(option: Int ,completion: @escaping(Result<MainData, Error>) -> Void ) {
    
    var url: URL!
    
    if option == 0 {
        url = URL(string: Constants.urlArgentina)
    } else {
        url = URL(string: Constants.urlGlobal)
    }
    
    guard let requestUrl = url else { fatalError() }
    let request = URLRequest(url: requestUrl)
  
    let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
    
        if error != nil{
            print((error?.localizedDescription)!)
            return
        }
 
        guard let jsondata = data else {
            completion(.failure(error?.localizedDescription as! Error))
            return
        }
        
        do {
            let mainData = try JSONDecoder().decode(MainData.self, from: jsondata)
            completion(.success(mainData))
            
        }catch{
            completion(.failure(error))
            return
        }
    }
    dataTask.resume()
}

    func getinfoCovidHistory(option: Int ,completion: @escaping(Result<[Daily], Error>) -> Void ) {
        var url: URL!
        
        if option == 0 {
            url = URL(string: Constants.urlArgentinaHistory)
        } else {
            url = URL(string: Constants.urlGlobalHistory)
        }
        
        guard let requestUrl = url else { fatalError() }
        let request = URLRequest(url: requestUrl)
      
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
        
            if error != nil{
                print((error?.localizedDescription)!)
                return
            }
     
            guard let jsondata = data else {
                completion(.failure(error?.localizedDescription as! Error))
                return
            }
            
            var cases : [String : Int] = [:]
            
            do {
                if option == 0 {
                    let countryHistory = try JSONDecoder().decode(MyCountry.self, from: jsondata)
                    cases = countryHistory.timeline["cases"]!
                }
                else{
                    let json = try! JSONDecoder().decode(Global.self, from: data!)
                    cases = json.cases
                }
                    
                var count = 0
                var daily : [Daily] = []
                
                for i in cases{
                    daily.append(Daily(id: count, day: i.key, cases: i.value))
                    count += 1
                }
                daily.sort { (t, t1) -> Bool in
                    if t.day < t1.day{
                        return true
                    }
                    else{
                        return false
                    }
                }
                completion(.success(daily))
            } catch{
                completion(.failure(error))
                return
            }
        }
        dataTask.resume()
    }
}
