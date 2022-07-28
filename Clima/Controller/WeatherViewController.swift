//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        //Diz que essa classe vai cuidar do retorno do UITextField
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    //Essa função vai ser chamada quando o user clicar no ícone da lupa.
    @IBAction func searchPressed(_ sender: UIButton) {
        //print(searchTextField.text!)
        
        //Retira o teclado da tela
        searchTextField.endEditing(true)
    }
    
    //Essa função vai ser chamada quando o user clicar no "go" do teclado.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(searchTextField.text!)
        searchTextField.endEditing(true)
        
        return true
    }
   

    //Função chamada se o user tentar submeter o campo vazio.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != ""){
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    //Função para dar um "clear" no campo, depois de envia-lo
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Chama a func do model WeatherManager
        if let city = searchTextField.text {
            weatherManager.fecthWeather(cityName: city)
        }
        
        //Limpar o text field
        searchTextField.text = ""
    }
    
}

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fecthWeather(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
