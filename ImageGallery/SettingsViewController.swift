//
//  SettingsViewController.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 06.02.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    //MARK: - vars/lets
    var cellsObjects = [Cell(name: "Password", image: UIImage(systemName: "lock")!),
                        Cell(name: "Theme", image: UIImage(systemName: "moon.circle")!)]
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainSettings()
    }
    
    //MARK: - IBActions
    
    
    //MARK: - flow func
    private  func mainSettings() {
        self.navigationController?.navigationBar.tintColor = Settings.shared.textColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.shared.textColor]
        self.view.backgroundColor = Settings.shared.mainColor
        settingsTableView.backgroundColor = .clear
        settingsTableView.separatorColor = Settings.shared.textColor
    }
    
}

//MARK: - Extensions
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.cellLabel.text = cellsObjects[indexPath.row].name
        cell.cellLabel.textColor = Settings.shared.textColor
        cell.imageCell.image = cellsObjects[indexPath.row].image
        cell.imageCell.tintColor = Settings.shared.textColor
        cell.chevronImageCell.tintColor = Settings.shared.textColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "PasswordSettingsViewController") as? PasswordSettingsViewController else { return }
            self.navigationController?.pushViewController(controller, animated: true)
        case 1:
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ThemeViewController") as? ThemeViewController else { return }
            self.navigationController?.pushViewController(controller, animated: true)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
