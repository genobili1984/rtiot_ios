//
//  CameraDetailViewController.swift
//  iot
//
//  Created by mao on 1/7/19.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit

class ParkingDetailViewController: UIViewController {
    
    @IBOutlet weak var enterpriseNameLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var installLocationLabel: UILabel!
    @IBOutlet weak var installTimeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var parkingOwnerLabel: UILabel!
    @IBOutlet weak var equipmentFaultLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var parkingInfo : ParkingInfo?
    
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
        self.enterpriseNameLabel.text = parkingInfo?.enterpriseName ?? ""
        self.equipmentNameLabel.text = parkingInfo?.equipmentName ?? ""
        self.installLocationLabel.text = parkingInfo?.installLocation ?? ""
        self.installTimeLabel.text = parkingInfo?.installTime ?? ""
        self.latitudeLabel.text = parkingInfo?.latitude ?? ""
        self.longitudeLabel.text = parkingInfo?.longitude ?? ""
        self.parkingOwnerLabel.text = parkingInfo?.parkingIsOwn ?? false ? "私有" : "公用"
        self.equipmentFaultLabel.text = parkingInfo?.fault ?? "" == "0" ? "正常" : "损坏"
    }
    
    @objc func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String
        
    }

}
