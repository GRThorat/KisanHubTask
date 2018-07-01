//
//  DetailsViewController.swift
//  GauravThorat
//
//  Created by Mindbowser on 28/06/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var detailListTable: UITableView!
    var dataArray = [DetailModel]()
    var maxTempArray = [DetailModel]()
    var minTempArray = [DetailModel]()
    var meanTempArray = [DetailModel]()
    var sunshineArray = [DetailModel]()
    var rainfallArray = [DetailModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for temp in dataArray {
            switch temp.parameterName {
            case "Max Temp":
                self.maxTempArray.append(temp)
                break
            case "Min Temp":
                self.minTempArray.append(temp)
                break
            case "Mean Temp":
                self.meanTempArray.append(temp)
                break
            case "Sunshine":
                self.sunshineArray.append(temp)
                break
            case "Rainfall":
                self.rainfallArray.append(temp)
                break
            default:
                break
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maxTempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailListTable.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell
        if indexPath.row < maxTempArray.count {
            let model = self.maxTempArray[indexPath.row]
            cell?.yearlabel.text = model.year
            cell?.monthLabel.text = model.key
            cell?.maxTempValueLabel.text = model.value
        } else {
            cell?.yearlabel.text = "NA"
            cell?.monthLabel.text = "NA"
            cell?.maxTempValueLabel.text = "NA"
        }
        if indexPath.row < minTempArray.count {
            let model = self.minTempArray[indexPath.row]
            cell?.minTempValueLabel.text = model.value
        } else {
            cell?.minTempValueLabel.text = "NA"
        }
        if indexPath.row < meanTempArray.count {
            let model = self.meanTempArray[indexPath.row]
            cell?.meanTempValueLabel.text = model.value
        } else {
            cell?.meanTempValueLabel.text = "NA"
        }
        if indexPath.row < sunshineArray.count {
            let model = self.sunshineArray[indexPath.row]
            cell?.sunshineValueLabel.text = model.value
        } else {
            cell?.sunshineValueLabel.text = "NA"
        }
        if indexPath.row < rainfallArray.count {
            let model = self.rainfallArray[indexPath.row]
            cell?.rainfallValueLabel.text = model.value
        } else {
            cell?.rainfallValueLabel.text = "NA"
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
