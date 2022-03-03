//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 07.02.2022..
//

import UIKit
import Alamofire
import Kingfisher
import SVProgressHUD

enum HomeNavigationOption {
    case showDetails
}

final class ShowsViewController : UIViewController {
    
    // MARK: - Private properties -
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy private var rightNavigationButton: UIBarButtonItem = {
        let rightNavigationButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        rightNavigationButton.setBackgroundImage(UIImage(named: "userIcon"), for: .normal, barMetrics: .default)
        return rightNavigationButton
    }()
    
    private var networkCallInProgress = false
    private var currentPage = 1
    private var numberOfPages = 0
    private var numberOfShowsPerPage = 8
    private var listOfShows: [Show] = [] {
        didSet {
            tableView.reloadData()
            updateNetworkCallStatus()
        }
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpUI()
        fetchShowsFromAPI(router: Router.shows(items: numberOfShowsPerPage, page: currentPage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
}

// MARK: - Extensions -

private extension ShowsViewController {
    
    func setUpNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension ShowsViewController {
    
    // MARK: - Setup Table View -
    
    func setUpTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCells() {
        let cellNib = UINib(nibName: "ShowTitleTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ShowTitleTableViewCell")
    }
}

private extension ShowsViewController {
    
    // MARK: - Setup UI -
    
    func setUpUI() {
        colorNavigationBar(color: Constants.Colors.navigationBarLightGray)
        hidebackButton()
        addRightNavigationButton()
    }
    
    func hidebackButton() {
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setViewControllers([self], animated: true)
        navigationController?.navigationBar.barTintColor = .red
    }
    
    func addRightNavigationButton() {
        navigationItem.rightBarButtonItem = rightNavigationButton
    }
    
    
}

// MARK: - API Call -

private extension ShowsViewController {
    
    func fetchShowsFromAPI(router: Router) {
        networkCallInProgress = true
        APIManager
            .shared
            .call(
                router: router,
                responseType: ShowsResponse.self) { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let payload) :
                        self.handleSuccess(shows: payload.shows)
                        self.numberOfPages = payload.meta.pagination.pages
                        break
                        
                    case .failure :
                        self.handleFailure()
                        break
                    }
                }
    }
    
    func updateNetworkCallStatus() {
        networkCallInProgress = false
        currentPage += 1
    }
    
    func canFetchMore() -> Bool {
        return !networkCallInProgress && currentPage<=numberOfPages
    }
}

private extension ShowsViewController {
    
    func handleSuccess(shows: [Show]) {
        listOfShows.append(contentsOf: shows)
        tableView.tableFooterView = nil
    }
    
    func handleFailure() {
        SVProgressHUD.showError(withStatus: Constants.AlertMessages.networkError)
    }
}

// MARK: - Table View delegates -

extension ShowsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = listOfShows[indexPath.row]
        navigate(to: .showDetails, with: show)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ShowsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTitleTableViewCell", for: indexPath) as! ShowTitleTableViewCell
        cell.setUpCellUI(for: listOfShows[indexPath.row])
        return cell
    }
}

extension ShowsViewController: UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > listOfShows.count - 2, canFetchMore() {
            tableView.tableFooterView = ShowsViewController.createSpinnerFooter(
                frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
            )
            fetchShowsFromAPI(router: .shows(items: numberOfShowsPerPage, page: currentPage))
        }
    }
}

// MARK: - Navigation -

extension ShowsViewController {

    func navigate(to navigationOption: HomeNavigationOption, with show: Show) {
        switch navigationOption {
        case .showDetails:
            let storyboard = UIStoryboard(name: "ShowDetails", bundle: .main)
            let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
            showDetailsViewController.show = show
            navigationController?.pushViewController(showDetailsViewController, animated: true)
        }
    }
}
