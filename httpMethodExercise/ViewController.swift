//
//  ViewController.swift
//  httpMethodExercise
//
//  Created by Ivan Pavic on 14.6.22..
//

import UIKit

class ViewController: UIViewController {

    var detailVCPrintedJson: String?
    var detailVCTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "HTTPS Methods"
    }
        
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case MethodNames.POST.rawValue:
            postMethod()
        case MethodNames.GET.rawValue:
            getMethod()
        case MethodNames.PUT.rawValue:
            putMethod()
        case MethodNames.DELETE.rawValue:
            deleteMethod()
        case MethodNames.PATCH.rawValue:
            patchMethod()
        default:
            break
        }
    }
    
    // MARK: METHODS
    
    func postMethod() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            print ("Can't create URL")
            return
        }
        let uploadDataModel = POSTMethodUploadData(title: "Some New Data", body: "I added some new data as part of exercise", userId: 25)
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(uploadDataModel) else {
            print ("Error: Trying to convert model to JSON data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            self.prepareResultForDisplay(method: MethodNames.POST.rawValue, data: data)
        }.resume()
    }
    
    func getMethod() {
        guard let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees") else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let data = data else {
                print("Error: invalid data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print("Error: HTTP Request failed")
                print(String(describing: response))
                return
            }
            self.prepareResultForDisplay(method: MethodNames.GET.rawValue, data: data)
        }.resume()
        
    }
    
    func putMethod() {
        guard let url = URL(string: "https://reqres.in/api/users/2") else {
            print("Unable to create URL")
            return
        }
        
        let uploadData = PUTMethodUploadData(name: "Milosava", job: "iOS Developer")
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(uploadData) else {
            print("Error: unable to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let data = data else {
                print("Error: Invalid data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print ("Error calling PUT Method")
                print(String(describing: response))
                return
            }
            self.prepareResultForDisplay(method: MethodNames.PUT.rawValue, data: data)
        }.resume()
    }
    
    func deleteMethod() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            print ("Unable to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let data = data else {
                print("Error: Invalid data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print ("Error calling DELETE Method")
                print(String(describing: response))
                return
            }
            self.prepareResultForDisplay(method: MethodNames.DELETE.rawValue, data: data)
        }.resume()
    }
    
    func patchMethod() {
        guard let url = URL(string: "https://reqres.in/api/users/2") else {
            print("Unable to create URL")
            return
        }
        let uploadModel = PATCHMethodUploadData(name: "Vidosav")
        let jsonEncoder = JSONEncoder()
        guard let jsonUploadData = try? jsonEncoder.encode(uploadModel) else {
            print("Unable to create JSON Data from Upload Model Data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonUploadData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print ("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let data = data else {
                print("Error: Invalid data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print ("Error calling PATCH Method")
                print(String(describing: response))
                return
            }
            self.prepareResultForDisplay(method: MethodNames.PATCH.rawValue, data: data)
        }.resume()
    }
        
    
    func openDetailsVC(jsonString: String, title: String) {
        detailVCPrintedJson = jsonString
        detailVCTitle = title
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Detail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "Detail" {
            let destViewController = segue.destination as? DetailViewController
            destViewController?.title = detailVCTitle
            destViewController?.jsonResults = detailVCPrintedJson ?? ""
        }
    }
    
    func prepareResultForDisplay(method name: String, data: Data) {
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error converting data to JSON Object")
                return
            }
            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                print("Error converting JSON Object to Pretty JSON Data")
                return
            }
            guard let jsonString = String(data: prettyJsonData, encoding: .utf8) else {
                print("Error: failed to convert Pretty JSON Data to String")
                return
            }
            self.openDetailsVC(jsonString: jsonString, title: "\(name) METHOD")
        } catch {
            print("Error: failed to convert JSON data to String")
            return
        }
    }
}

