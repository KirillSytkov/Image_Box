//
//  FirstAttention.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 17.01.2022.
//

import UIKit

class AlbumAlert: UIView {
    
    //MARK: - Otlets
    @IBOutlet weak var attentionView: UIView!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    //MARK: - Actions
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
        self.blurEffectView.alpha = 0
        self.attentionView.alpha = 0
    }
    
    //MARK: - flow func
    func addSettings() {
        self.attentionButton.backgroundColor = Settings.shared.fourthColor
        self.attentionButton.layer.cornerRadius = 25
        self.attentionView.backgroundColor = Settings.shared.secondColor
        self.attentionView.layer.cornerRadius = 15
        self.attentionView.alpha = 0
        self.blurEffectView.alpha = 0
    }
    
    static func instanceFromNib() -> AlbumAlert {
        guard let view = UINib(nibName: "FirstAttention", bundle: nil).instantiate(withOwner: nil, options: nil).first as? AlbumAlert else { return AlbumAlert() }
        return view
    }
}
