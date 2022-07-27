//
//  HeadlineCell.swift
//  2Grand
//
//  Created by Amin on 27/07/2022.
//

import UIKit
import SDWebImage
class HeadlineCell: UICollectionViewCell {
    static let ID = "HEADLINE_CELL"
    @IBOutlet weak var uiDesc: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var uiAuthor: UILabel!
    
    @IBOutlet weak var uiView: UIView!
    func configure(model:Article){
        uiDesc.text = model.articleDescription ?? UUID().description
        uiImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        uiAuthor.text = model.author ?? UUID().uuidString
        guard let image = model.urlToImage, let imageUrl = URL(string: image) else {return}
        uiImage.sd_setImage(with: imageUrl)
        uiView.layer.borderColor = UIColor.darkGray.cgColor
        uiView.layer.borderWidth = 0.3
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
