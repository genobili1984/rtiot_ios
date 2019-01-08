//
//  CameraDetailViewController.swift
//  iot
//
//  Created by mao on 1/7/19.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit

class YonacoDetailViewController: UIViewController {
    
    @IBOutlet weak var enterpriseNameLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var installLocationLabel: UILabel!
    @IBOutlet weak var installTimeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var equipmentStateLabel: UILabel!
    @IBOutlet weak var equipmentFaultLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var PMLabel: UILabel!
    @IBOutlet weak var rainfallLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var yonacoInfo : YonacoInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "摄像头详情"
        self.initDetailInfo()
        
        let name = NSNotification.Name(rawValue: MQTTMessageNoti)
        NotificationCenter.default.addObserver(self, selector: #selector(LampDetailViewController.receivedMessage(notification:)), name: name, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func initDetailInfo() {
        self.enterpriseNameLabel.text = yonacoInfo?.enterpriseName ?? ""
        self.equipmentNameLabel.text = yonacoInfo?.equipmentName ?? ""
        self.installLocationLabel.text = yonacoInfo?.installLocation ?? ""
        self.installTimeLabel.text = yonacoInfo?.installTime ?? ""
        self.latitudeLabel.text = yonacoInfo?.latitude ?? ""
        self.longitudeLabel.text = yonacoInfo?.longitude ?? ""
        self.equipmentStateLabel.text = yonacoInfo?.lampIsOpen ?? false ? "开" : "关"
        self.equipmentFaultLabel.text = yonacoInfo?.fault ?? "" == "0" ? "正常" : "损坏"
        self.directionLabel.text = yonacoInfo?.yonacoDirection ?? ""
        self.humidityLabel.text = yonacoInfo?.yonacoHumidity ?? ""
        self.PMLabel.text = yonacoInfo?.yonacoSpeed ?? ""
        self.rainfallLabel.text = yonacoInfo?.yonacoRainfall ?? ""
        self.speedLabel.text = yonacoInfo?.yonacoSpeed ?? ""
    }
    
    @objc func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String
        
    }

}
