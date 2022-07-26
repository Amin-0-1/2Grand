//
//  DetailsVC.swift
//  2Grand
//
//  Created by Amin on 26/07/2022.
//

import UIKit

class DetailsVC: UIViewController {

    @IBOutlet weak var uiName: UILabel!
    @IBOutlet weak var uiContent: UILabel!
    @IBOutlet weak var uiDate: UILabel!
    @IBOutlet weak var uiImage: UIImageView!
    @IBOutlet weak var uiTitle: UILabel!
    @IBOutlet weak var uiDesc: UILabel!
    
    var model:Article!
    var viewModel:DetailsVMPrtotocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        uiName.text = model.author
        uiContent.text = model.content ?? UUID().description
        uiDate.text = model.publishedAt?.toDate(WithFormate: .d_MMM_yyyy) ?? UUID().uuidString
        uiTitle.text = model.title ?? UUID().uuidString
        uiDesc.text = model.articleDescription ?? UUID().description
        guard let image = model.urlToImage ,let imageUrl = URL(string: image) else {return}
        uiImage.sd_setImage(with: imageUrl)
        
    }
    @IBAction func uiLinkButton(_ sender: UIButton) {
        let vc = NewsSourceVC()
        vc.url = model.url
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func uiClose(_ sender: UIButton) {
        viewModel.input.dismiss.onNext(())
    }
}
