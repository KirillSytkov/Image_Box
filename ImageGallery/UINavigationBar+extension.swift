
import Foundation
import UIKit

extension UINavigationItem {

    func setTitle(_ title: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17.0)
        titleLabel.textColor = Settings.shared.textColor

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12.0)
        subtitleLabel.textColor = Settings.shared.textColor

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical

        self.titleView = stackView
    }

}
