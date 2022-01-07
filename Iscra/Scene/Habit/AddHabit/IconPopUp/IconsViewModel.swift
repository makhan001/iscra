//
//  IconsViewModel.swift
//  Iscra
//
//  Created by m@k on 04/01/22.
//

import Foundation

final class IconsViewModel {
    
    var iconIndex: Int = 0
    var categoryIndex: Int = 0
    
    var icons = [IconModel]()
    var iconCategory = [IconCategory]()
    var themeColor = HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true)
    
    init() {
        self.parse(jsonData: Utils.readLocalFile(forName: "HabitIconsMock") ?? Data())
    }
    
    private func parse(jsonData: Data) {
        do {
            let iconsModel = try JSONDecoder().decode(IconsHabitModel.self,from: jsonData)
            self.iconCategory = iconsModel.iconCategory
            self.icons = self.iconCategory.first?.icons ?? self.icons
        } catch {
            print(error.localizedDescription)
        }
    }
}
