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
    var deviceCategory : [String] = []
    let categoryNameDic = ["camera":"摄像头", "lamp":"路灯", "parking":"停车锁", "sewerCover":"井盖", "water":"水位计", "yanoco":"气象计"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备列表"
        self.tableView.register(UINib(nibName: "iOTCategoryViewCell", bundle: nil), forCellReuseIdentifier: "iOTCategoryViewCell")
        self.loadDeviceList()
    
//        let name = NSNotification.Name(rawValue: MQTTMessageNoti)
//        NotificationCenter.default.addObserver(self, selector: #selector(LampDetailViewController.receivedMessage(notification:)), name: name, object: nil)
        MQTTManager.instance.connect()
    }

    deinit {
          //NotificationCenter.default.removeObserver(self)
    }
    
    func loadDeviceList() {
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
                                        do {
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
                                        }catch {
                                            print("error = \(error)")
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
                            self?.deviceCategory = Array(self!.deviceData.keys)
                            self?.deviceCategory.sort {
                                $0 < $1
                            }
                            self?.tableView.reloadData()
                        }
                }
        }
    }
    
    @objc func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String
        
        print("topic = \(topic) content = \(content)")
    }

}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(self.deviceCategory)[section]
        let values = self.deviceData[key]
        return values?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.deviceCategory.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = Array(self.deviceCategory)[section]
        return self.categoryNameDic[key] ?? key
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let key = Array(self.deviceCategory)[section]
        let values = self.deviceData[key]
        let viewCell = tableView.dequeueReusableCell(withIdentifier: "iOTCategoryViewCell") as? iOTCategoryViewCell
        let deviceInfo = values?[row]
        viewCell?.textLabel?.text = deviceInfo?.equipmentCode ?? ""
        return viewCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let key = Array(self.deviceCategory)[section]
        let values = self.deviceData[key]
        let deviceInfo = values?[row]
        let equipmentType = deviceInfo?.equipmentType ?? ""
        switch equipmentType {
        case "camera":
            let detailViewController = CameraDetailViewController(nibName:"CameraDetailViewController", bundle:nil)
            let cameraInfo = deviceInfo as? CameraInfo
            detailViewController.cameraInfo = cameraInfo
            self.navigationController?.pushViewController(detailViewController)
        case "lamp":
            let detailViewController = LampDetailViewController(nibName:"LampDetailViewController", bundle:nil)
            let lampInfo = deviceInfo as? LampInfo
            detailViewController.lampInfo = lampInfo
            self.navigationController?.pushViewController(detailViewController)
        case "sewerCover":
            let detailViewController = SewerCoverDetailViewController(nibName:"SewerCoverDetailViewController", bundle:nil)
            let sewerCoverInfo = deviceInfo as? SewerCoverInfo
            detailViewController.sewerCoverInfo = sewerCoverInfo
            self.navigationController?.pushViewController(detailViewController)
        case "parking":
            let detailViewController = ParkingDetailViewController(nibName:"ParkingDetailViewController", bundle:nil)
            let parkingInfo = deviceInfo as? ParkingInfo
            detailViewController.parkingInfo = parkingInfo
            self.navigationController?.pushViewController(detailViewController)
        case "water":
            let detailViewController = WaterLevelDetailViewController(nibName:"WaterLevelDetailViewController", bundle:nil)
            let waterLevelInfo = deviceInfo as? WaterLevelInfo
            detailViewController.waterLevelInfo = waterLevelInfo
            self.navigationController?.pushViewController(detailViewController)
        case "yanaco":
            let detailViewController = YonacoDetailViewController(nibName:"YonacoDetailViewController", bundle:nil)
            let yonacoInfo = deviceInfo as? YonacoInfo
            detailViewController.yonacoInfo = yonacoInfo
            self.navigationController?.pushViewController(detailViewController)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
