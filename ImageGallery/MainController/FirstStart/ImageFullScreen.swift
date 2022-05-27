
import UIKit

class ImageFullScreen: UIView {

    @IBOutlet weak var imageZoom: ImageZoomView!
    
    static func instanceFromNib() -> ImageFullScreen {
        guard let view = UINib(nibName: "ImageFullScreen", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ImageFullScreen else { return ImageFullScreen() }
        return view
    }
    
}
