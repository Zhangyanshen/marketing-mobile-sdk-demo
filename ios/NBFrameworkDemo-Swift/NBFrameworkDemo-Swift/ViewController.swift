//
//  ViewController.swift
//  SwiftOCDemo
//
//  Created by 张延深 on 2019/12/30.
//  Copyright © 2019 张延深. All rights reserved.
//

import UIKit
import NBFramework

class ViewController: UIViewController {

    @IBOutlet weak var tokenField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var dataArray = [
        ["title": "财经早报", "type": NBMarketingHeadline],
        ["title": "财经资讯", "type": NBMarketingNews],
        ["title": "智能名片", "type": NBMarketingCard],
        ["title": "营销线索", "type": NBMarketingLeads],
        ["title": "访客记录", "type": NBMarketingActivity],
        ["title": "营销分析", "type": NBMarketingAnalysis],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 初始化MarketingHelper
        NBMarketingHelper.sharedInstance().delegate = self
    }
    
    //MARK: - Private methods

    func setupUI() {
        tableView.tableFooterView = UIView.init()
    }

}

//MARK: - UITableView代理

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId)
        }
        let data: [String: Any] = dataArray[indexPath.row]
        cell?.textLabel?.text = data["title"] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = dataArray[indexPath.row]
        var token = ""
        if let tokenTmp = tokenField.text {
            token = tokenTmp
        }
        NBMarketingHelper.open(data["type"] as! NBMarketingModule, token: token, from: self)
    }
    
}

//MARK: - NBMarketingHelperDelegate

extension ViewController: NBMarketingHelperDelegate {
    func marketingHelper(_ helper: NBMarketingHelper, shareWebPage data: [AnyHashable : Any], complete callback: (([Any]) -> Void)? = nil) {
        
    }
    
    func marketingHelper(_ helper: NBMarketingHelper, shareImage data: [AnyHashable : Any], complete callback: (([Any]) -> Void)? = nil) {
        
    }
    
    func marketingHelper(_ helper: NBMarketingHelper, shareMini data: [AnyHashable : Any], complete callback: (([Any]) -> Void)? = nil) {
        
    }
    
}

