//
//  HomeVC.swift
//  2Grand
//
//  Created by Amin on 25/07/2022.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import Toast
class HomeVC: UIViewController ,UISearchBarDelegate{

    @IBOutlet weak var uiTableView: UITableView!    
    @IBOutlet weak var uiSearchBar: UISearchBar!
    
    var viewModel:HomeVMProtocol!
    private var activity : NVActivityIndicatorView!
    private var bag:DisposeBag!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivity()
        bag = DisposeBag()
        uiSearchBar.placeholder = "Search for anything..."
        bind()
        viewModel.input.onScreenAppeared.onNext(())
        configureTableView()

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
        viewModel.output.onFinishFetchingNews.asObservable().bind{ [weak self] articles in
            guard let self = self else {return}
            self.uiTableView.reloadData()
            self.uiTableView.refreshControl?.endRefreshing()
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
        viewModel.output.onFinishSearching.bind{ [weak self] _ in
            guard let self = self else {return}
            self.uiTableView.reloadData()
        }.disposed(by: bag)
    }

    private func configureTableView(){
        uiTableView.rowHeight = UITableView.automaticDimension
        uiTableView.estimatedRowHeight = UITableView.automaticDimension
        uiTableView.register(UINib(nibName: R.nib.homeCell.name, bundle: nil), forCellReuseIdentifier: HomeCell.ID)
        
        uiTableView.refreshControl = UIRefreshControl()
        uiTableView.refreshControl?.addTarget(self, action: #selector(pullToRefreshSelector), for: .valueChanged)
        
    }
    @objc func pullToRefreshSelector(){
        viewModel.input.onScreenAppeared.onNext(())
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.input.onSearch.onNext(searchBar.text)
    }
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.output.isSearching{
            return viewModel.output.searchList.count
        }else{
            return viewModel.output.modelCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.ID, for: indexPath) as? HomeCell else {fatalError("unable to dequeue")}
        viewModel.input.configureCell.onNext((cell: cell, indexPath: indexPath))
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.onSelect.onNext(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.output.modelCount - 1 {
            print("paginate")
            viewModel.input.onPaginate.onNext(())
        }
    }
}
