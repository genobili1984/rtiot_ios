//
//  CameraDetailViewController.swift
//  iot
//
//  Created by mao on 1/7/19.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit

class LampDetailViewController: UIViewController {
    
    @IBOutlet weak var enterpriseNameLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var installLocationLabel: UILabel!
    @IBOutlet weak var installTimeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var lampSwitch: UISwitch!
    @IBOutlet weak var equipmentFaultLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var lampInfo : LampInfo?
    
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
        self.enterpriseNameLabel.text = lampInfo?.enterpriseName ?? ""
        self.equipmentNameLabel.text = lampInfo?.equipmentName ?? ""
        self.installLocationLabel.text = lampInfo?.installLocation ?? ""
        self.installTimeLabel.text = lampInfo?.installTime ?? ""
        self.latitudeLabel.text = lampInfo?.latitude ?? ""
        self.longitudeLabel.text = lampInfo?.longitude ?? ""
        self.lampSwitch.setOn(lampInfo?.lampIsOpen ?? false, animated: false)
        self.equipmentFaultLabel.text = lampInfo?.fault ?? "" == "0" ? "正常" : "损坏"
    }
    
    @objc func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String
        print("topic = \(topic) content = \(content)")
    }

    @IBAction func switchChanged(_ sender: Any) {
        
    }
    
}
