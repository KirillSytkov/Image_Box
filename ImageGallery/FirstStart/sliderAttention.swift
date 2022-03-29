//
//  sliderAttention.swift
//  ImageGallery
//
//  Created by Kirill Sytkov on 22.01.2022.
//

import UIKit

class sliderAttention: UIView {
    @IBOutlet weak var attentionView: UIView!
    
    func addSettings() {
        self.attentionView.layer.cornerRadius = 15
        self.attentionView.backgroundColor = Settings.shared.secondColor
    }
    static func instanceFromNib() -> sliderAttention {
        guard let view = UINib(nibName: "sliderAttention", bundle: nil).instantiate(withOwner: nil, options: nil).first as? sliderAttention else { return sliderAttention() }
        return view
    }
}
