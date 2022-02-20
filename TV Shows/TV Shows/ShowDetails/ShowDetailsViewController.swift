//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import Foundation
import UIKit

final class ShowDetailsViewController: UIViewController {

    var closure: ((_ text:String?) -> ())?
    var showId: String? {
        didSet {
            fetchShowFromAPI(router: <#T##Router#>)
        }
    }


    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
}

// MARK: - Extensions -

private extension ShowDetailsViewController {

    func setUpNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension ShowDetailsViewController {

    // MARK: - Setup Table View -

    func setUpTableView() {
//        registerCells()
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    func registerCells() {
//        let cellNib = UINib(nibName: "ShowTitleTableViewCell", bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: "ShowTitleTableViewCell")
    }
}


// MARK: - API Call -

private extension ShowDetailsViewController {

    func fetchShowFromAPI(router: Router) {
        APIManager
            .shared
            .call(
                router: router,
                responseType: TopRatedResponse.self) { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let payload) :
//                        self.handleSuccess(shows: payload.shows)
                        break

                    case .failure(let error) :
//                        self.handleFailure(error: error)
                        break
                    }
                }
    }
}

