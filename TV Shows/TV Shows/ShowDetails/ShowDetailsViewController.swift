//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD

final class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showDescription: UITextView!
    var closure: ((_ text:Show?) -> ())?
    var reviews: [Review] = [] {
        didSet {

        }
    }
    var show: Show? {
        didSet {

        }
    }


    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "ShowDetailsTableViewFirstCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ShowDetailsTableViewFirstCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 720
        tableView.delegate = self
        tableView.dataSource = self
        

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

extension ShowDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ShowDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        reviews.count
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailsTableViewFirstCell", for: indexPath) as! ShowDetailsTableViewFirstCell
        print("Pred ulazom sam")
        if let show = show {
            print("Usao sam")
            cell.setUpCellUI(for: show)
        }
        print("Izvan ifa")

        return cell
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

    func fetchShowsFromAPI(router: Router) {
        APIManager
            .shared
            .call(
                router: router,
                responseType: ReviewsResponse.self) { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let payload) :
                        self.handleSuccess(reviews: payload.reviews)
                        break

                    case .failure(let error) :
                        self.handleFailure(error: error)
                        break
                    }
        }
    }
}

private extension ShowDetailsViewController {

    func handleSuccess(reviews: [Review]) {
        self.reviews = reviews
    }

    func handleFailure(error: AFError) {
        SVProgressHUD.showError(withStatus: Constants.AlertMessages.networkError)
    }
}
