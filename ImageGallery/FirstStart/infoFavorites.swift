//
//  infoFavorites.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 18.01.2022.
//

import UIKit

class infoFavorites: UIView {
//MARK: - IBotlets
    
    @IBOutlet weak var attentionView: UIView!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
        self.blurEffectView.alpha = 0
    }
//MARK: - flow func
    func addSettings() {
        self.blurEffectView.alpha = 0
        self.attentionView.alpha = 1
        self.attentionButton.backgroundColor = Settings.shared.fourthColor
        self.attentionButton.layer.cornerRadius = 25
        self.attentionView.backgroundColor = Settings.shared.secondColor
        self.attentionView.layer.cornerRadius = 15
    }
    static func instanceFromNib() -> infoFavorites {
        guard let view = UINib(nibName: "infoFavorites", bundle: nil).instantiate(withOwner: nil, options: nil).first as? infoFavorites else { return infoFavorites() }
        return view
    }
}
