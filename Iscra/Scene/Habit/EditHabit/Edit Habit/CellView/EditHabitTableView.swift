//
//  EditTableView.swift
//  Iscra
//
//  Created by Dr.Mac on 03/11/21.
//

import UIKit


class EditHabitTableView: UITableView {
    // MARK:Outlets and variables
    let items = [
        MyAccount(titleImage: "ic-Everyday-image", titleName: "Everyday", clickManager: .everyDay),
        MyAccount(titleImage: "ic-Reminader-image", titleName: "Reminder", clickManager: .reminder),
        MyAccount(titleImage: "ic-ChangeColorTheme-image", titleName: "Change color theme", clickManager: .changeColorTheme)]
      
    var delegateNavigate: clickManagerDelegate?
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure() {
        self.tableFooterView = UIView(frame: .zero)
        self.separatorStyle = .none
        self.register(UINib(nibName: "MyAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "MyAccountTableViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
    }
    

}
// MARK: TableView Method
extension EditHabitTableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableViewCell") as? MyAccountTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegateNavigate?.tableViewCellNavigation(performAction: items[indexPath.row].clickManager)
      }
}



