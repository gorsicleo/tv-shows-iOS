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

    // MARK: - Private Properties -

    @IBOutlet private weak var showImage: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var showDescription: UITextView!
    @IBOutlet private weak var addReviewButton: CustomButton!

    // MARK: - Public Properties -

    var reviews: [Review] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var show: Show?

    // MARK: - ViewController Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableView()
        setUpReviewButton()
        if let showId = show?.id {
            fetchShowsFromAPI(router: .reviews(showId: showId))
        }
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
        title = show?.title
    }

    func setUpReviewButton() {
        addReviewButton.setBackgroundColor(Constants.Colors.mainRedColor, for: .normal)
        addReviewButton.makeRounded()
    }
}

// MARK: - Table View delegates -

extension ShowDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ShowDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailsCell", for: indexPath) as! ShowDetailsCell
            if let show = show {
                cell.setUpCellUI(for: show)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            cell.setUpCellUI(for: reviews[indexPath.row])
            return cell
        }
    }
}

// MARK: - Setup Table View -

private extension ShowDetailsViewController {

    func setUpTableView() {
        registerCells()
        disableSelection()
    }

    func registerCells() {
        let showDetailsCellNib = UINib(nibName: "ShowDetailsCell", bundle: nil)
        tableView.register(showDetailsCellNib, forCellReuseIdentifier: "ShowDetailsCell")

        let reviewCellNib = UINib(nibName: "ReviewCell", bundle: nil)
        tableView.register(reviewCellNib, forCellReuseIdentifier: "ReviewCell")
    }

    func disableSelection() {
        tableView.allowsSelection = false
    }
}

// MARK: - IBAction -

private extension ShowDetailsViewController {

    @IBAction func addReviewAction(_ sender: Any) {
        let writeReviewController = instantiateWriteReviewViewController()
        writeReviewController.show = show

        writeReviewController.completionHandler = { [weak self] review in
            guard let self = self else { return }
            self.reviews.append(review)
            self.tableView.reloadData()
        }

        let navigationController = UINavigationController(rootViewController: writeReviewController)
        present(navigationController, animated: true)
    }

    func instantiateWriteReviewViewController() -> WriteReviewController {
        let storyboard = UIStoryboard(name: "WriteReview", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewController
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
                    case .failure :
                        self.handleFailure()
                        break
                    }
        }
    }
}

// MARK: - API Response Handlers -

private extension ShowDetailsViewController {

    func handleSuccess(reviews: [Review]) {
        self.reviews = reviews
    }

    func handleFailure() {
        SVProgressHUD.showError(withStatus: Constants.AlertMessages.networkError)
    }
}
