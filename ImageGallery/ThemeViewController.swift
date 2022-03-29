//
//  ThemeViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 12.02.2022.
//

import UIKit


class ThemeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var ThemeTableView: UITableView!
    
    
    //MARK: - vars/lets
    var theme = ["Устройство", "Светлая" , "Темная"]
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - IBActions
    
    
    //MARK: - flow func
    private  func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        self.view.backgroundColor = Settings.shared.mainColor
        ThemeTableView.backgroundColor = .clear
        ThemeTableView.separatorColor = Settings.shared.textColor
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
//MARK: - Extensions
extension ThemeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        theme.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell") as? ThemeTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.textLabelCell.text = theme[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ThemeManager.shared.loadTheme(theme: indexPath.row, view: view)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
