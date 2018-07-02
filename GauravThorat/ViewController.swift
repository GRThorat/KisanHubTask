//
//  ViewController.swift
//  GauravThorat
//
//  Created by Mindbowser on 26/06/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import MessageUI

typealias CompletionHandler = (_ success:Bool, _ localPath: String, _ region: String, _ parameter: String) -> Void

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, MFMailComposeViewControllerDelegate {

    // MARK: - Outlets and Variable declaration

    @IBOutlet weak var selectRegionTextfield: UITextField!
    @IBOutlet weak var detailsTableview: UITableView!
    
    var arrayOfParameters = [DetailModel]()
    var UKFileNames = [UK_Max_Temp, UK_Min_Temp, UK_Mean_Temp, UK_Sunshine, UK_Rainfall]
    var UKUrlArray = [UK_Max_Temp_Url, UK_Min_Temp_Url, UK_Mean_Temp_Url, UK_Sunshine_Url, UK_Rainfall_Url]
    var EnglandFileNames = [Eng_Max_Temp, Eng_Min_Temp, Eng_Mean_Temp, Eng_Sunshine, Eng_Rainfall]
    var EnglandUrlArray = [Eng_Max_Temp_Url, Eng_Min_Temp_Url, Eng_Mean_Temp_Url, Eng_Sunshine_Url, Eng_Rainfall_Url]
    var WalesFileNames = [Wales_Max_Temp, Wales_Min_Temp, Wales_Mean_Temp, Wales_Sunshine, Wales_Rainfall]
    var WalesUrlArray = [Wales_Max_Temp_Url, Wales_Min_Temp_Url, Wales_Mean_Temp_Url, Wales_Sunshine_Url, Wales_Rainfall_Url]
    var ScotlandFileNames = [Scotland_Max_Temp, Scotland_Min_Temp, Scotland_Mean_Temp, Scotland_Sunshine, Scotland_Rainfall]
    var ScotlandUrlArray = [Scotland_Max_Temp_Url, Scotland_Min_Temp_Url, Scotland_Mean_Temp_Url, Scotland_Sunshine_Url, Scotland_Rainfall_Url]
    var regionArray = ["UK", "England", "Wales", "Scotland"]
    var parameterArray = ["Max Temp", "Min Temp", "Mean Temp", "Sunshine", "Rainfall"]
    var  data:[[String:String]] = []
    var  columnTitles:[String] = []
    var arrayOfFilesLocalPath = [String]()
    var arrayOfParametersSelected = [String]()
    var arrayOfRegionSelected = [String]()
    var csvString = "region_code,weather_param,year,key,value"
    var completionCounter = 0
    var dataSet = ["UK" : [DetailModel](), "England" : [DetailModel](), "Wales" : [DetailModel](), "Scotland" : [DetailModel]()] as [String : [DetailModel]]
    var reachability: Reachability?

    // MARK: - Viewcontroller Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if arrayOfFilesLocalPath.count == 0 {
        let path = "\(NSHomeDirectory())/Documents/weather.csv"
        if FileManager.default.fileExists(atPath: path) {
            //nothing to do
            do{
                try FileManager.default.removeItem(atPath: path)
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, message: "We are processing the data...", animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.downloadData()
                    })
                }
            } catch {
                print("Unable to delete...")
            }
        } else {
            do {
                reachability = try Reachability.forInternetConnection()
            } catch {
                print("Unable to create Reachability")
            }
            if reachability!.isReachable() {
                DispatchQueue.main.async {
                    MBProgressHUD.showAdded(to: self.view, message: "We are processing the data...", animated: true)
                }
                self.downloadData()
            } else {
                let errorAlert = UIAlertController(title: "No Internet Connection", message: nil, preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
                errorAlert.addAction(dismiss)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Method to Setup the data for CSV file

    func setUpData(localPath: String, region: String, parameter: String) {
        print(self.arrayOfFilesLocalPath.count)
        if self.arrayOfFilesLocalPath.count == 20 {
            for i in 0..<self.arrayOfFilesLocalPath.count {
                let strData = FileManager.default.contents(atPath: self.arrayOfFilesLocalPath[i])
                let str = String(data: strData!, encoding: String.Encoding.utf8)
                self.convertCSV(file: str!, region: self.arrayOfRegionSelected[i], parameter: self.arrayOfParametersSelected[i])
            }
        }
    }
    
    // MARK: - Method to download the text files

    func downloadData() {
        for temp in UKUrlArray {
            let url = URL(string: temp)
            let path = "\(NSHomeDirectory())/Documents/\(self.UKFileNames[self.UKUrlArray.index(of: temp)!])"
            print(path)
            let localUrl = URL(fileURLWithPath: path)
            let index = self.UKUrlArray.index(of: temp)
            if FileManager.default.fileExists(atPath: path) {
                self.arrayOfFilesLocalPath.append(path)
                self.arrayOfRegionSelected.append("UK")
                self.arrayOfParametersSelected.append(self.parameterArray[index!])
                self.setUpData(localPath: path, region: "UK", parameter: self.parameterArray[index!])
            } else {
                self.load(url: url!, to: localUrl, localPath: path, region: "UK", parameter: self.parameterArray[index!]) { (status, localPath, region, parameter) in
                    print("Success-----")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.arrayOfFilesLocalPath.append(localPath)
                        self.arrayOfRegionSelected.append(region)
                        self.arrayOfParametersSelected.append(parameter)
                        self.setUpData(localPath: localPath, region: region, parameter: parameter)
                    })
                }
            }
        }
        for temp in EnglandUrlArray {
            let url = URL(string: temp)
            let path = "\(NSHomeDirectory())/Documents/\(self.EnglandFileNames[self.EnglandUrlArray.index(of: temp)!])"
            print(path)
            let localUrl = URL(fileURLWithPath: path)
            let index = self.EnglandUrlArray.index(of: temp)
            if FileManager.default.fileExists(atPath: path) {
                self.arrayOfFilesLocalPath.append(path)
                self.arrayOfRegionSelected.append("England")
                self.arrayOfParametersSelected.append(self.parameterArray[index!])
                self.setUpData(localPath: path, region: "England", parameter: self.parameterArray[index!])
            } else {
                self.load(url: url!, to: localUrl, localPath: path, region: "England", parameter: self.parameterArray[index!]) { (status, localPath, region, parameter) in
                    print("Success-----")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.arrayOfFilesLocalPath.append(localPath)
                        self.arrayOfRegionSelected.append(region)
                        self.arrayOfParametersSelected.append(parameter)
                        self.setUpData(localPath: localPath, region: region, parameter: parameter)
                    })
                }
            }
        }
        for temp in WalesUrlArray {
            let url = URL(string: temp)
            let path = "\(NSHomeDirectory())/Documents/\(self.WalesFileNames[self.WalesUrlArray.index(of: temp)!])"
            print(path)
            let localUrl = URL(fileURLWithPath: path)
            let index = self.WalesUrlArray.index(of: temp)
            if FileManager.default.fileExists(atPath: path) {
                self.arrayOfFilesLocalPath.append(path)
                self.arrayOfRegionSelected.append("Wales")
                self.arrayOfParametersSelected.append(self.parameterArray[index!])
                self.setUpData(localPath: path, region: "Wales", parameter: self.parameterArray[index!])
            } else {
                self.load(url: url!, to: localUrl, localPath: path, region: "Wales", parameter: self.parameterArray[index!]) { (status, localPath, region, parameter) in
                    print("Success-----")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.arrayOfFilesLocalPath.append(localPath)
                        self.arrayOfRegionSelected.append(region)
                        self.arrayOfParametersSelected.append(parameter)
                        self.setUpData(localPath: localPath, region: region, parameter: parameter)
                    })
                }
            }
        }
        for temp in ScotlandUrlArray {
            let url = URL(string: temp)
            let path = "\(NSHomeDirectory())/Documents/\(self.ScotlandFileNames[self.ScotlandUrlArray.index(of: temp)!])"
            print(path)
            let localUrl = URL(fileURLWithPath: path)
            let index = self.ScotlandUrlArray.index(of: temp)
            if FileManager.default.fileExists(atPath: path) {
                self.arrayOfFilesLocalPath.append(path)
                self.arrayOfRegionSelected.append("Scotland")
                self.arrayOfParametersSelected.append(self.parameterArray[index!])
                self.setUpData(localPath: path, region: "Scotland", parameter: self.parameterArray[index!])
            } else {
                self.load(url: url!, to: localUrl, localPath: path, region: "Scotland", parameter: self.parameterArray[index!]) { (status, localPath, region, parameter) in
                    print("Success-----")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.arrayOfFilesLocalPath.append(localPath)
                        self.arrayOfRegionSelected.append(region)
                        self.arrayOfParametersSelected.append(parameter)
                        self.setUpData(localPath: localPath, region: region, parameter: parameter)
                    })
                }
            }
        }
    }
    
    // MARK: - Methods to perform download task

    func load(url: URL, to localUrl: URL, localPath: String, region: String, parameter: String, completionHandler: @escaping CompletionHandler) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completionHandler(true,localPath, region, parameter)
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }

    // MARK: - Methods to formatting the text file

    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func getStringFieldsForRow(row:String, delimiter:String)-> [String]{
        let str = row.replacingOccurrences(of: " ", with: " ")
        return str.components(separatedBy: delimiter)
    }
    
    func filterArray(array: [String]) -> [String] {
        var temp2 = [String]()
        for temp in array {
            if temp != "" {
                temp2.append(temp)
            }
        }
        return temp2
    }

    // MARK: - Method to generate csv file

    func convertCSV(file: String, region: String, parameter: String){
        let rows = cleanRows(file: file).components(separatedBy: "\n")
        if rows.count > 0 {
            var data = [[String:String]]()
            columnTitles = getStringFieldsForRow(row: rows[7],delimiter:" ")
            columnTitles = self.filterArray(array: columnTitles)
            for i in 8..<rows.count {
//            for row in rows{
                var fields = getStringFieldsForRow(row: rows[i],delimiter: " ")
                fields = self.filterArray(array: fields)
//                if fields.count != columnTitles.count {continue}
                var dataRow = [String:String]()
                for temp in columnTitles {
                    dataRow[temp] = "NA"
                }
                for (index,field) in fields.enumerated() {
                    dataRow[columnTitles[index]] = field
                }
                data += [dataRow]
            }
            
            for temp in 1..<data.count {
                for i in 0..<columnTitles.count {
                    let str1 = (data[temp] as NSDictionary).value(forKey: "Year")
                    if !(columnTitles[i] as! String).contains("Year") {
                    let temp1 = (data[temp] as NSDictionary).value(forKey: columnTitles[i]) as? String
                    print("\(region),\(parameter),\(str1!),\(columnTitles[i]),\(temp1!)")
                    var str = String()
                    if (temp1 as! String).contains("---") {
                        str = "\(region),\(parameter),\(str1!),\(columnTitles[i]),NA\n"
                        let detail = DetailModel()
                        detail.region = region
                        detail.parameterName = parameter
                        detail.year = "\(str1!)"
                        detail.key = "\(columnTitles[i])"
                        detail.value = "NA"
                        dataSet[region]?.append(detail)
                    } else {
                        str = "\(region),\(parameter),\(str1!),\(columnTitles[i]),\(temp1!)\n"
                        let detail = DetailModel()
                        detail.region = region
                        detail.parameterName = parameter
                        detail.year = "\(str1!)"
                        detail.key = "\(columnTitles[i])"
                        detail.value = "\(temp1!)"
                        dataSet[region]?.append(detail)
                    }
                    self.csvString = "\(self.csvString)\n\(str)"
                }
                }
            }
        } else {
            print("No data in file")
        }
        completionCounter = completionCounter + 1
        if completionCounter == 20 {
            DispatchQueue.main.async {
                let fileManager = FileManager.default
                do {
                    let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                    let fileURL = path.appendingPathComponent("weather.csv")
                    try self.csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                } catch {
                    print("error creating file")
                }
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
        }
    }
    
    // MARK: - IBActions

    @IBAction func shareAction(_ sender: UIButton) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    // MARK: - Method to show a mail composer view

    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject("Weather Report")
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("weather.csv")
            let data = try Data(contentsOf: fileURL)
            mailComposerVC.addAttachmentData(data, mimeType: "text/csv", fileName: "weather.csv")
        } catch {
            print("error creating file")
        }
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: - MailComposer Delegate methods

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview Delegate and Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.detailsTableview.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath)
        cell.textLabel?.text = self.regionArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let control = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        let modelArray = dataSet[self.regionArray[indexPath.row]]
        control?.dataArray = modelArray!
        self.navigationController?.pushViewController(control!, animated: true)
    }
}
