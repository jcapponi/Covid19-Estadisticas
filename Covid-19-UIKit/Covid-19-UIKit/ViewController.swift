//
//  ViewController.swift
//  Covid-19-UIKit
//
//  Created by Juan Capponi on 10/12/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contagiados: UIImageView!
    @IBOutlet weak var fallecidos: UIImageView!
    @IBOutlet weak var activos: UIImageView!
    @IBOutlet weak var recuperados: UIImageView!
    @IBOutlet weak var graves: UIImageView!
   
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var cantContagios: UILabel!
    @IBOutlet weak var cantFallecidos: UILabel!
    @IBOutlet weak var cantGraves: UILabel!
    @IBOutlet weak var cantRecuperados: UILabel!
    @IBOutlet weak var cantActivos: UILabel!
    
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBAction func countrySelector(_ sender: Any) {
                getCovidHistory(option: selector.selectedSegmentIndex)
                getCovidInfo(option: selector.selectedSegmentIndex)
    }
    
    let statsView = UIView(frame: .zero)
    let cases_0 = UILabel(frame: .zero)
    let cases_1 = UILabel(frame: .zero)
    let cases_2 = UILabel(frame: .zero)
    let cases_3 = UILabel(frame: .zero)
    let cases_4 = UILabel(frame: .zero)
    let cases_5 = UILabel(frame: .zero)
    let cases_6 = UILabel(frame: .zero)
    
    let viewModel = ViewModel()
    var mainData: MainData!
    var daily : [Daily] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiConfig()
        self.activity.color = .white
        self.activity.style = .large
        self.activity.isHidden = true
        getCovidInfo(option: 0)
        getCovidHistory(option: 0)
    }
    
    func getCovidHistory(option: Int) {
        
        self.cases_0.text = ""
        self.cases_1.text = ""
        self.cases_1.text = ""
        self.cases_1.text = ""
        self.cases_1.text = ""
        self.cases_1.text = ""
        self.cases_1.text = ""
        
        self.activity.startAnimating()
        self.activity.isHidden = false
        
        viewModel.getinfoCovidHistory(option: option) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let daily):
                self?.daily = daily
                self!.uiUpdte() {
                    self!.statisticsView()
                    self!.statisticsBarsView(option: option)
                    self?.activity.stopAnimating()
                    self?.activity.isHidden = true
                }
            }
        }
    }
    
    func getCovidInfo(option: Int) {
        self.activity.startAnimating()
        self.activity.isHidden = false

        viewModel.getinfoCovid(option: option) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let mainData):
                self?.mainData = mainData
                self!.uiUpdte() {
                    self?.cantContagios.text = String(self?.mainData.cases ?? 0)
                    self?.cantFallecidos.text = String(self?.mainData.deaths ?? 0)
                    self?.cantGraves.text = String(self?.mainData.critical ?? 0)
                    self?.cantRecuperados.text = String(self?.mainData.recovered ?? 0)
                    self?.cantActivos.text = String(self?.mainData.active ?? 0)
                }
            }
        }
    }
    
    func uiConfig() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.contagiados.layer.cornerRadius = 10
        self.fallecidos.layer.cornerRadius = 10
        self.activos.layer.cornerRadius = 10
        self.recuperados.layer.cornerRadius = 10
        self.graves.layer.cornerRadius = 10
    }
    
    func uiUpdte(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    func statisticsView() {
        
        statsView.translatesAutoresizingMaskIntoConstraints = false
        statsView.backgroundColor = UIColor.white
        statsView.layer.cornerRadius = 14
        self.view.addSubview(statsView)
            
        NSLayoutConstraint.activate([
            statsView.topAnchor.constraint(equalTo: self.recuperados.bottomAnchor, constant: 30),
            statsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsView.widthAnchor.constraint(equalToConstant: screen.width - 20),
            statsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
    }
    
    func statisticsBarsView(option: Int) {
        
        var multiplier = 1000
        let fontSize: CGFloat = 14
        var multConst = "K"
        if option == 1 {
            multiplier = 1000000
            multConst = "M"
        }
  
        let lastWeek = UILabel(frame: .zero)
        lastWeek.text = "Ultima Semana"
        lastWeek.textColor = .black
        lastWeek.font = UIFont.boldSystemFont(ofSize: 24)
        lastWeek.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(lastWeek)
        
        NSLayoutConstraint.activate([
            lastWeek.topAnchor.constraint(equalTo: statsView.topAnchor, constant: 10),
            lastWeek.widthAnchor.constraint(equalToConstant: 200),
            lastWeek.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 10)
        ])
        
        //20 is padding from main view
        //30 is padding I want from statsView
        let width = screen.width - 20 - 30
        let barwidth = (width / 7) - 30 // 30 Spacing between bars
        
        let barsView_0 = UIView(frame: .zero)
        barsView_0.translatesAutoresizingMaskIntoConstraints = false
        barsView_0.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_0)
            

        NSLayoutConstraint.activate([
            barsView_0.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat( 80  + (1000 - daily[0].cases / multiplier) / 10)),
            barsView_0.leadingAnchor.constraint(equalTo: statsView.leadingAnchor, constant: 30),
            barsView_0.widthAnchor.constraint(equalToConstant: barwidth),
            barsView_0.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])
        
        cases_0.text = ("\(daily[0].cases / multiplier)\(multConst)")
        cases_0.textColor = .black
        cases_0.font =  UIFont.systemFont(ofSize: fontSize)
        cases_0.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_0)
        
        NSLayoutConstraint.activate([
            cases_0.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_0.centerXAnchor.constraint(equalTo: barsView_0.centerXAnchor),
        ])
        
        let date_0 = UILabel(frame: .zero)
        date_0.text = ("\(daily[0].day)")
        date_0.textColor = .black
        date_0.font = UIFont.systemFont(ofSize: 9)
        date_0.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_0)
        
        NSLayoutConstraint.activate([
            date_0.topAnchor.constraint(equalTo: barsView_0.bottomAnchor, constant: 20),
            date_0.centerXAnchor.constraint(equalTo: barsView_0.centerXAnchor),
        ])
        
        let barsView_1 = UIView(frame: .zero)
        barsView_1.translatesAutoresizingMaskIntoConstraints = false
        barsView_1.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_1)
       
        NSLayoutConstraint.activate([
            barsView_1.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat(80 + (1000 - daily[1].cases / multiplier) / 10)),
            barsView_1.leadingAnchor.constraint(equalTo: barsView_0.trailingAnchor, constant: 30),
            barsView_1.widthAnchor.constraint(equalToConstant: barwidth),
            barsView_1.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])
        
        
        cases_1.text = ("\(daily[1].cases / multiplier)\(multConst)")
        cases_1.textColor = .black
        cases_1.font =  UIFont.systemFont(ofSize: fontSize)
        cases_1.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_1)
        
        NSLayoutConstraint.activate([
            cases_1.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_1.centerXAnchor.constraint(equalTo: barsView_1.centerXAnchor),
        ])
        
        
        let date_1 = UILabel(frame: .zero)
        date_1.text = ("\(daily[1].day)")
        date_1.textColor = .black
        date_1.font = UIFont.systemFont(ofSize: 9)
        date_1.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_1)
        
        NSLayoutConstraint.activate([
            date_1.topAnchor.constraint(equalTo: barsView_1.bottomAnchor, constant: 20),
            date_1.centerXAnchor.constraint(equalTo: barsView_1.centerXAnchor),
        ])
        
        let barsView_2 = UIView(frame: .zero)
        barsView_2.translatesAutoresizingMaskIntoConstraints = false
        barsView_2.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_2)
        
        NSLayoutConstraint.activate([
        barsView_2.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat(80 + (1000 - daily[2].cases / multiplier) / 10) ),
        barsView_2.leadingAnchor.constraint(equalTo: barsView_1.trailingAnchor, constant: 30),
        barsView_2.widthAnchor.constraint(equalToConstant: barwidth ),
        barsView_2.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])

        cases_2.text = ("\(daily[2].cases / multiplier)\(multConst)")
        cases_2.textColor = .black
        cases_2.font =  UIFont.systemFont(ofSize: fontSize)
        cases_2.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_2)
        
        NSLayoutConstraint.activate([
            cases_2.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_2.centerXAnchor.constraint(equalTo: barsView_2.centerXAnchor),
        ])
        
        
        let date_2 = UILabel(frame: .zero)
        date_2.text = ("\(daily[2].day)")
        date_2.textColor = .black
        date_2.font = UIFont.systemFont(ofSize: 9)
        date_2.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_2)
        
        NSLayoutConstraint.activate([
            date_2.topAnchor.constraint(equalTo: barsView_2.bottomAnchor, constant: 20),
            date_2.centerXAnchor.constraint(equalTo: barsView_2.centerXAnchor),
        ])
        
        let barsView_3 = UIView(frame: .zero)
        barsView_3.translatesAutoresizingMaskIntoConstraints = false
        barsView_3.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_3)
        
        
        NSLayoutConstraint.activate([
        barsView_3.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat(80 + (1000 - daily[3].cases / multiplier) / 10) ),
        barsView_3.leadingAnchor.constraint(equalTo: barsView_2.trailingAnchor, constant: 30),
        barsView_3.widthAnchor.constraint(equalToConstant: barwidth ),
        barsView_3.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])

        
        cases_3.text = ("\(daily[3].cases / multiplier)\(multConst)")
        cases_3.textColor = .black
        cases_3.font =  UIFont.systemFont(ofSize: fontSize)
        cases_3.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_3)
        
        NSLayoutConstraint.activate([
            cases_3.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_3.centerXAnchor.constraint(equalTo: barsView_3.centerXAnchor),
        ])
        
        
        let date_3 = UILabel(frame: .zero)
        date_3.text = ("\(daily[3].day)")
        date_3.textColor = .black
        date_3.font = UIFont.systemFont(ofSize: 9)
        date_3.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_3)
        
        NSLayoutConstraint.activate([
            date_3.topAnchor.constraint(equalTo: barsView_3.bottomAnchor, constant: 20),
            date_3.centerXAnchor.constraint(equalTo: barsView_3.centerXAnchor),
        ])
        
        let barsView_4 = UIView(frame: .zero)
        barsView_4.translatesAutoresizingMaskIntoConstraints = false
        barsView_4.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_4)
        
        
        NSLayoutConstraint.activate([
        barsView_4.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat(80 + (1000 - daily[4].cases / multiplier) / 10) ),
        barsView_4.leadingAnchor.constraint(equalTo: barsView_3.trailingAnchor, constant: 30),
        barsView_4.widthAnchor.constraint(equalToConstant: barwidth ),
        barsView_4.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])
        
        cases_4.text = ("\(daily[4].cases / multiplier)\(multConst)")
        cases_4.textColor = .black
        cases_4.font =  UIFont.systemFont(ofSize: fontSize)
        cases_4.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_4)
        
        NSLayoutConstraint.activate([
            cases_4.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_4.centerXAnchor.constraint(equalTo: barsView_4.centerXAnchor),
        ])
        
        
        let date_4 = UILabel(frame: .zero)
        date_4.text = ("\(daily[4].day)")
        date_4.textColor = .black
        date_4.font = UIFont.systemFont(ofSize: 9)
        date_4.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_4)
        
        NSLayoutConstraint.activate([
            date_4.topAnchor.constraint(equalTo: barsView_4.bottomAnchor, constant: 20),
            date_4.centerXAnchor.constraint(equalTo: barsView_4.centerXAnchor),
        ])
        
        
        let barsView_5 = UIView(frame: .zero)
        barsView_5.translatesAutoresizingMaskIntoConstraints = false
        barsView_5.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_5)
        
        
        NSLayoutConstraint.activate([
        barsView_5.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat(80 + (1000 - daily[5].cases / multiplier) / 10) ),
        barsView_5.leadingAnchor.constraint(equalTo: barsView_4.trailingAnchor, constant: 30),
        barsView_5.widthAnchor.constraint(equalToConstant: barwidth ),
        barsView_5.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])
        
        cases_5.text = ("\(daily[5].cases / multiplier)\(multConst)")
        cases_5.textColor = .black
        cases_5.font =  UIFont.systemFont(ofSize: fontSize)
        cases_5.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_5)
        
        NSLayoutConstraint.activate([
            cases_5.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_5.centerXAnchor.constraint(equalTo: barsView_5.centerXAnchor),
        ])
        
        
        let date_5 = UILabel(frame: .zero)
        date_5.text = ("\(daily[5].day)")
        date_5.textColor = .black
        date_5.font = UIFont.systemFont(ofSize: 9)
        date_5.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_5)
        
        NSLayoutConstraint.activate([
            date_5.topAnchor.constraint(equalTo: barsView_5.bottomAnchor, constant: 20),
            date_5.centerXAnchor.constraint(equalTo: barsView_5.centerXAnchor),
        ])

        
        let barsView_6 = UIView(frame: .zero)
        barsView_6.translatesAutoresizingMaskIntoConstraints = false
        barsView_6.backgroundColor = UIColor.red
        self.statsView.addSubview(barsView_6)
        
        
        NSLayoutConstraint.activate([
        barsView_6.topAnchor.constraint(equalTo: self.statsView.topAnchor, constant: CGFloat(80 + (1000 - daily[6].cases / multiplier) / 10) ),
        barsView_6.leadingAnchor.constraint(equalTo: barsView_5.trailingAnchor, constant: 30),
        barsView_6.widthAnchor.constraint(equalToConstant: barwidth ),
        barsView_6.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -50)
        ])
 
        cases_6.text = ("\(daily[6].cases / multiplier)\(multConst)")
        cases_6.textColor = .black
        cases_6.font =  UIFont.systemFont(ofSize: fontSize)
        cases_6.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(cases_6)
        
        NSLayoutConstraint.activate([
            cases_6.topAnchor.constraint(equalTo: lastWeek.bottomAnchor, constant: 20),
            cases_6.centerXAnchor.constraint(equalTo: barsView_6.centerXAnchor),
        ])
        
        
        let date_6 = UILabel(frame: .zero)
        date_6.text = ("\(daily[6].day)")
        date_6.textColor = .black
        date_6.font = UIFont.systemFont(ofSize: 9)
        date_6.translatesAutoresizingMaskIntoConstraints = false
        statsView.addSubview(date_6)
        
        NSLayoutConstraint.activate([
            date_6.topAnchor.constraint(equalTo: barsView_6.bottomAnchor, constant: 20),
            date_6.centerXAnchor.constraint(equalTo: barsView_6.centerXAnchor),
        ])
    }
}


struct screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}

class Constants {
    static let urlArgentina = "https://corona.lmao.ninja/v2/countries/argentina?yesterday=false"
    static let urlArgentinaHistory = "https://corona.lmao.ninja/v2/historical/Argentina?lastdays=7"
    static let urlGlobal = "https://corona.lmao.ninja/v2/all?today"
    static let urlGlobalHistory = "https://corona.lmao.ninja/v2/historical/all?lastdays=7"
}
