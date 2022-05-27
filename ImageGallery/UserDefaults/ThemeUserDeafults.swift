
import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    private init() {}
    
    func loadTheme(theme: Int, view: UIView) {        
        switch theme {
        case 0:
            view.window?.overrideUserInterfaceStyle = .unspecified
        case 1:
            view.window?.overrideUserInterfaceStyle = .light
        case 2:
            view.window?.overrideUserInterfaceStyle = .dark
        default:
            break
        }
        
        UserDefaults.standard.set(theme, forKey: keys.settings)
    }
}
