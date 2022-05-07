//
//  deleteAttention.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 22.01.2022.
//

import UIKit

class deleteAttention: UIView {
    @IBOutlet weak var trashImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var attentionView: UIView!
    
    func addSettings() {
        self.attentionView.layer.cornerRadius = 15
        self.cancelButton.backgroundColor = .clear
        self.okButton.layer.cornerRadius = 25
    }
    static func instanceFromNib() -> deleteAttention {
        guard let view = UINib(nibName: "deleteAttention", bundle: nil).instantiate(withOwner: nil, options: nil).first as? deleteAttention else { return deleteAttention() }
        return view
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.removeFromSuperview()
        self.blur.alpha = 0
    }
    
}
