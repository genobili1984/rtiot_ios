//
//  CameraDetailViewController.swift
//  iot
//
//  Created by mao on 1/7/19.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit

class SewerCoverDetailViewController: UIViewController {
    
    @IBOutlet weak var enterpriseNameLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var installLocationLabel: UILabel!
    @IBOutlet weak var installTimeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var sewerCoverOpenLabel: UILabel!
    @IBOutlet weak var equipmentFaultLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var sewerCoverInfo : SewerCoverInfo?
    
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
        self.enterpriseNameLabel.text = sewerCoverInfo?.enterpriseName ?? ""
        self.equipmentNameLabel.text = sewerCoverInfo?.equipmentName ?? ""
        self.installLocationLabel.text = sewerCoverInfo?.installLocation ?? ""
        self.installTimeLabel.text = sewerCoverInfo?.installTime ?? ""
        self.latitudeLabel.text = sewerCoverInfo?.latitude ?? ""
        self.longitudeLabel.text = sewerCoverInfo?.longitude ?? ""
        self.sewerCoverOpenLabel.text = sewerCoverInfo?.isOpen ?? false ? "开" : "关"
        self.equipmentFaultLabel.text = sewerCoverInfo?.fault ?? "" == "0" ? "正常" : "损坏"
    }
    
    @objc func receivedMessage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let content = userInfo["message"] as! String
        let topic = userInfo["topic"] as! String
        
    }
}
