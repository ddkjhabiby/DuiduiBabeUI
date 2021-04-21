//
//  FileBrowsViewController.swift
//  Inlove
//
//  Created by kuang on 2020/8/26.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

class FileBrowsViewController: UIViewController {
    
    var fileList:[String] = [String]()
    var folderPath: String = ""
    lazy var tableView = { () -> UITableView in
        let _tableView = UITableView.init(frame: self.view.bounds)
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        _tableView.delegate = self
        _tableView.dataSource = self
        return _tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    func initUI(){
        self.view.addSubview(tableView)
        
    }
    
    func config(path:String){
        folderPath = path
        if isFileExistAtPath(fileFullPath: path) {
            do {
                fileList = try FileManager.default.contentsOfDirectory(atPath: path)
            } catch {
            
            }
        }
        tableView.reloadData()
    }
}

fileprivate extension FileBrowsViewController{
    //判断是不是文件夹
    func isFolder(fileFullPath: String) -> Bool{
        var isDir = ObjCBool.init(false)
        _ = FileManager.default.fileExists(atPath: fileFullPath, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    func isFileExistAtPath(fileFullPath: String) -> Bool{
        let isDir = FileManager.default.fileExists(atPath: fileFullPath)
        return isDir
    }
    
    func sharePath(filePath: String){
        if (!self.isFileExistAtPath(fileFullPath: filePath)) {
            return;
        }
        
        let url = URL.init(fileURLWithPath: filePath)
        let objectsToShare = [url]
        let controller = UIActivityViewController.init(activityItems: objectsToShare, applicationActivities: nil)
        let excludedActivities = [UIActivity.ActivityType.message, .mail,
                                  .print,
                                  .saveToCameraRoll,
                                  .addToReadingList, .postToFlickr]

        controller.excludedActivityTypes = excludedActivities;
        self.present(controller, animated: true, completion: nil)
    }
}

extension FileBrowsViewController:UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        
        let name = fileList[indexPath.row]
        let path = folderPath + "/\(name)"
        if self.isFolder(fileFullPath: path){
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.accessoryType = .none
        }
        cell.textLabel?.text = name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = fileList[indexPath.row]
        let path = folderPath + "/\(name)"
        if self.isFolder(fileFullPath: path){
            let vc = FileBrowsViewController.init()
            vc.title = name
            vc.config(path: path)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            sharePath(filePath: path)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let name = fileList[indexPath.row]
        let path = folderPath + "/\(name)"
        
        do {
            try FileManager.default.removeItem(atPath: path)
            fileList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        } catch {
        
        }
        
    }
}
