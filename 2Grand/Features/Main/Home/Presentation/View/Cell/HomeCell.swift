//
//  HomeCell.swift
//  2Grand
//
//  Created by Amin on 25/07/2022.
//

import UIKit
import SDWebImage
class HomeCell: UITableViewCell {
    static let ID = "HOME_CELL"
    
//    @IBOutlet private weak var uiShadowLayer: UIView!
    @IBOutlet private weak var layerView: UIView!
    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var time: UILabel!
    @IBOutlet private weak var uiTitle: UILabel!
    @IBOutlet private weak var uiDesc: UILabel!
    
    func configure(model:Article){
        guard let image = model.urlToImage, let urlImage = URL(string: image),let title = model.title , let author = model.author, let time = model.publishedAt , let desc = model.articleDescription else {
            
            return
        }

        uiImage.sd_setImage(with: urlImage)
        uiTitle.text = title
        self.author.text = author
        self.time.text = time.toDate(WithFormate: .d_MMM_yyyy)
        uiDesc.text = desc
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uiImage.layer.cornerRadius = 12
        
        
        layerView.layer.cornerRadius = 12
        layerView.layer.borderColor = UIColor.darkGray.cgColor
        layerView.layer.borderWidth = 0.1
        
        layerView.layer.shadowColor = UIColor.black.cgColor
        layerView.layer.shadowRadius = 3
        layerView.layer.shadowOpacity = 3
        layerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
