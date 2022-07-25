//
//  HomeVC.swift
//  2Grand
//
//  Created by Amin on 25/07/2022.
//

import UIKit

class HomeVC: UIViewController {


    @IBOutlet weak var uiTableView: UITableView!
    var x = [UUID().description,UUID().description + UUID().description + UUID().description + UUID().description]
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView(){
        uiTableView.rowHeight = UITableView.automaticDimension
        uiTableView.estimatedRowHeight = UITableView.automaticDimension
        uiTableView.register(UINib(nibName: R.nib.homeCell.name, bundle: nil), forCellReuseIdentifier: HomeCell.ID)
    }
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.ID, for: indexPath) as? HomeCell else {fatalError("unable to dequeue")}
        cell.configure(desc: x[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
