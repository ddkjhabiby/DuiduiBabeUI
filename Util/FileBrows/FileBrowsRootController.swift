//
//  FileBrowsRootController.swift
//  Inlove
//
//  Created by kuang on 2020/8/26.
//  Copyright © 2020 duiud. All rights reserved.
//

import Foundation
import UIKit

public class FileBrowsRootController: UIViewController {
    
    public static func openFileBrows(){
        let vc = FileBrowsRootController.init()
        vc.title = "文件浏览";
        let navigationVC = UINavigationController.init(rootViewController: vc);
        CommonUIUtil.topViewController()?.present(navigationVC, animated: true, completion: nil)
    }
    
    var fileList:[URL] = [URL]()
    lazy var tableView = { () -> UITableView in
        let _tableView = UITableView.init(frame: self.view.bounds)
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        _tableView.delegate = self
        _tableView.dataSource = self
        return _tableView
    }()
    
    public  override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    
    func initUI(){
        self.view.addSubview(tableView)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back))
        
    }
    
    func initData(){
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last ?? ""
        let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last ?? ""
        let cachesPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).last ?? ""
        let tempPath = NSTemporaryDirectory()
        fileList.append(URL.init(fileURLWithPath: documentPath))
        fileList.append(URL.init(fileURLWithPath: libraryPath))
        fileList.append(URL.init(fileURLWithPath: cachesPath))
        fileList.append(URL.init(fileURLWithPath: tempPath))
    }
    
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension FileBrowsRootController:UITableViewDelegate, UITableViewDataSource{

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = fileList[indexPath.row].lastPathComponent
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
        
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FileBrowsViewController.init()
        vc.title = fileList[indexPath.row].lastPathComponent
        vc.config(path: fileList[indexPath.row].path)
        self.navigationController?.pushViewController(vc, animated: true)
//           [vc configWithFolderPath:path];
//           [self.navigationController pushViewController:vc animated:YES];
    }
}
