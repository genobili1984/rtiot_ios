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
    
    @IBOutlet weak var browserBtn: UIButton!
    @IBOutlet weak var trackBtn: UIButton!
    
    @IBOutlet weak var ipTextField: UITextField!
    
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
        
        self.browserBtn.layer.masksToBounds = true
        self.browserBtn.layer.cornerRadius = self.browserBtn.frame.size.height/2
        self.browserBtn.backgroundColor = UIColor(red: 0xff, green: 0xda, blue: 0x00) ?? UIColor()
        self.browserBtn.setTitle("浏览视频", for: .normal)
        
        self.trackBtn.layer.masksToBounds = true
        self.trackBtn.layer.cornerRadius = self.trackBtn.frame.size.height/2
        self.trackBtn.backgroundColor = UIColor(red: 0xff, green: 0xda, blue: 0x00) ?? UIColor()
        self.trackBtn.setTitle("视频回放", for: .normal)
    }
    
    @objc func receivedMessage(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        let content = userInfo["message"] as! String
//        let topic = userInfo["topic"] as! String
        
    }
    
    @IBAction func browserVideo(_ sender: Any) {
        let videoViewController = PlayerViewController()
        let ip = ipTextField.text ?? ""
        let url = String(format: "rtsp://%@:1554/Streaming/Channels/101?transportmode=unicast", ip.count == 0  ? "113.90.238.121" : ip)
        videoViewController.videoURL = url
        self.navigationController?.pushViewController(videoViewController, animated: true)
    }
    
    
    @IBAction func trackVideo(_ sender: Any) {
        let videoViewController = PlayerViewController()
        //        self.present(videoViewController, animated: true) {
        //
        //        }
        var date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        var month = calendar.component(.month, from: date)
        var day = calendar.component(.day, from: date)
        var hour = calendar.component(.hour, from: date)
        var minute = calendar.component(.minute, from: date)
        var second = calendar.component(.second, from: date)
        let endTime = String(format: "%d%02d%02dt%02d%02d%02dz", year, month, day, hour, minute, second)
        date = Date(timeIntervalSinceNow: -12*3600)
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        hour = calendar.component(.hour, from: date)
        minute = calendar.component(.minute, from: date)
        second = calendar.component(.second, from: date)
        let startTime = String(format: "%d%02d%02dt%02d%02d%02dz", year, month, day, hour, minute, second)
        let ip = ipTextField.text ?? ""
        let url = String(format: "rtsp://%@:1554/Streaming/tracks/101?starttime=%@&endtime=%@", ip.count == 0 ? "113.90.238.121" : ip, startTime, endTime)
        videoViewController.videoURL = url
        self.navigationController?.pushViewController(videoViewController, animated: true)
    }
}
