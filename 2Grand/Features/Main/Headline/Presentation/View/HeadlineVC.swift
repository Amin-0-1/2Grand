//
//  HeadlineVC.swift
//  2Grand
//
//  Created by Amin on 25/07/2022.
//

import UIKit
import RxCocoa
import RxSwift
import NVActivityIndicatorView
import Toast
class HeadlineVC: UIViewController {
    
    @IBOutlet weak var uiCollectionView: UICollectionView!
    var viewModel:HeadlineVMProtocol!
    private var activity : NVActivityIndicatorView!
    private var bag:DisposeBag!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        bag = DisposeBag()
        setupActivity()
        bind()
        viewModel.input.onScreenAppeared.onNext(())
    }
    private func setupActivity(){
        activity = NVActivityIndicatorView(frame: .zero, type: .lineScale, color: .black, padding: nil)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activity.widthAnchor.constraint(equalToConstant: 50),
            activity.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func bind(){
        viewModel.output.onFinishFetchingNews.asObservable().bind{ [weak self] _ in
            guard let self = self else {return}
            self.uiCollectionView.reloadData()
        }.disposed(by: bag)
        
        viewModel.output.showProgress.asObservable().bind{ [weak self] _ in
            guard let self = self else {return}
            self.activity.startAnimating()
        }.disposed(by: bag)
        viewModel.output.hideProgress.asObservable().bind{ [weak self] _ in
            guard let self = self else {return}
            self.activity.stopAnimating()
        }.disposed(by: bag)
        viewModel.output.showError.asObservable().bind{ [weak self] msg in
            guard let self = self else {return}
            let style = ToastStyle()
            self.view.makeToast(msg, duration: 2, position: .center, title: nil, image: nil, style: style, completion: nil)
        }.disposed(by: bag)
        
    }
    private func configureCollection(){
        uiCollectionView.register(UINib.init(nibName: R.nib.headlineCell.name, bundle: nil), forCellWithReuseIdentifier: HeadlineCell.ID)
        uiCollectionView.collectionViewLayout = generateLayout()
        
    }
    private func generateLayout()->UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { section, env in
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            
            return section
        })
        return layout
    }
    
}
extension HeadlineVC: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.modelCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadlineCell.ID, for: indexPath) as? HeadlineCell else {fatalError("unable to dequeue")}
        
        viewModel.input.configureCell.onNext((cell: cell, indexPath: indexPath))

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.onSelect.onNext(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if indexPath.item == viewModel.output.modelCount - 1{
            viewModel.input.onPaginate.onNext(())
        }
    }
    
    
}
