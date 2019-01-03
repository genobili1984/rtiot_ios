//
//  HomeViewController.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/3.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var deviceData:[String:[String]] = ["light":["light-001", "light-002"], "camera":["camera-001", "camera-002"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备列表"
        self.tableView.register(UINib(nibName: "iOTCategoryViewCell", bundle: nil), forCellReuseIdentifier: "iOTCategoryViewCell")
        
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
        viewCell?.textLabel?.text = values?[row] ?? ""
        return viewCell!
    }
    
    
}
