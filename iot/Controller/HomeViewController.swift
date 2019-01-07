//
//  HomeViewController.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/3.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var enterPriseID : String?
    
    var deviceData:[String:[DeviceInfo]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备列表"
        self.tableView.register(UINib(nibName: "iOTCategoryViewCell", bundle: nil), forCellReuseIdentifier: "iOTCategoryViewCell")
        
        //获取企业的分类
        if self.enterPriseID?.count ?? 0 > 0  {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                 RTAPIProvider.request(target: .deviceList(enterpriseID: self.enterPriseID!))
            }.done { [weak self] (response) in
                do {
                    let json = try JSON(data: response.data)
                    if json["code"].int ?? -1 == 0 {
                        let dataArray = json["data"].arrayValue
                        if dataArray.count > 0  {
                            let decoder = JSONDecoder()
                            for dic in dataArray {
                                let equipmentType = dic["equipmentType"].rawString() ?? ""
                                let data = try dic.rawData()
                                //let str = String(data: data, encoding: .utf8)
                                var deviceInfo : DeviceInfo?
                                switch equipmentType {
                                case "camera":
                                     deviceInfo = try decoder.decode(CameraInfo.self, from: data)
                                case "lamp":
                                    deviceInfo = try decoder.decode(LampInfo.self, from: data)
                                case "sewerCover":
                                    deviceInfo = try decoder.decode(SewerCoverInfo.self, from: data)
                                case "parking":
                                    deviceInfo = try decoder.decode(ParkingInfo.self, from: data)
                                case "water":
                                    deviceInfo = try decoder.decode(WaterLevelInfo.self, from: data)
                                case "yanaco":
                                    deviceInfo = try decoder.decode(YonacoInfo.self, from: data)
                                default:
                                    deviceInfo = nil
                                }
                                if deviceInfo != nil {
                                    var deviceArray = self?.deviceData[equipmentType]
                                    if deviceArray != nil {
                                        deviceArray!.append(deviceInfo!)
                                        self?.deviceData[equipmentType] = deviceArray!
                                    }else {
                                        self?.deviceData[equipmentType] = [deviceInfo!]
                                    }
                                }
                            }
                        }
                    }
                }catch  {
                    self?.view?.makeToast("数据解析失败", duration: 2.0, position: .bottom)
                }
            }.catch { [weak self](error) in
                self?.view?.makeToast("获取设备列表失败", duration: 2.0, position: .bottom)
            }.finally { [weak self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if self?.deviceData.count ?? 0 > 0 {
                     self?.tableView.reloadData()
                }
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(self.deviceData.keys)[section]
        let values = self.deviceData[key]
        return values?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.deviceData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = Array(self.deviceData.keys)[section]
        return key
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let key = Array(self.deviceData.keys)[section]
        let values = self.deviceData[key]
        let viewCell = tableView.dequeueReusableCell(withIdentifier: "iOTCategoryViewCell") as? iOTCategoryViewCell
        let deviceInfo = values?[row]
        viewCell?.textLabel?.text = deviceInfo?.equipmentCode ?? ""
        return viewCell!
    }
    
    
}
