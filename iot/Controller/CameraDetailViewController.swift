//
//  CameraDetailViewController.swift
//  iot
//
//  Created by mao on 1/7/19.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit

class CameraDetailViewController: UIViewController {
    
    @IBOutlet weak var enterpriseNameLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var installLocationLabel: UILabel!
    @IBOutlet weak var installTimeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var equipmentStateLabel: UILabel!
    @IBOutlet weak var equipmentFaultLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var cameraInfo : CameraInfo?
    
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
        self.enterpriseNameLabel.text = cameraInfo?.enterpriseName ?? ""
        self.equipmentNameLabel.text = cameraInfo?.equipmentName ?? ""
        self.installLocationLabel.text = cameraInfo?.installLocation ?? ""
        self.installTimeLabel.text = cameraInfo?.installTime ?? ""
        self.latitudeLabel.text = cameraInfo?.latitude ?? ""
        self.longitudeLabel.text = cameraInfo?.longitude ?? ""
        self.equipmentStateLabel.text = cameraInfo?.lampIsOpen ?? false ? "开" : "关"
        self.equipmentFaultLabel.text = cameraInfo?.fault ?? "" == "0" ? "正常" : "损坏"
    }
    
    @objc func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String
        
    }
}