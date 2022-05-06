//
//  TopRatedViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 15.02.2022..
//

import UIKit
import Alamofire
import SVProgressHUD

final class TopRatedViewController : UIViewController {
    
    // MARK: - Private properties -
    
    @IBOutlet private weak var tableView: UITableView!
    lazy private var rightNavigationButton: UIBarButtonItem = createRightNavigationButton()

    // MARK: - Public properties -
    
    var listOfShows: [Show] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpUI()
        setUpRefreshControl()
        fetchShowsFromAPI(router: .topRated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Extensions -

private extension TopRatedViewController {

    func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshHandler), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refreshHandler() {
        fetchShowsFromAPI(router: .topRated)
        tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Setup UI -

    func createRightNavigationButton() -> UIBarButtonItem {
        let rightNavigationButton = UIButton(type: .custom)
        rightNavigationButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        rightNavigationButton.setImage(UIImage(named:"userIcon"), for: .normal)
        rightNavigationButton.addTarget(self, action: #selector(userButtonClicked(sender:)), for: UIControl.Event.touchUpInside)

            let rightNavigationButtonItem = UIBarButtonItem(customView: rightNavigationButton)
            let currWidth = rightNavigationButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
            let currHeight = rightNavigationButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true

        return rightNavigationButtonItem
    }

    @objc func userButtonClicked(sender: UIButton){
        let logoutViewController = instantiateLogoutViewController()
        logoutViewController.user = UserDataPersistance.loadUserData()

        let navigationController = UINavigationController(rootViewController: logoutViewController)
        present(navigationController, animated: true)
    }

    func instantiateLogoutViewController() -> LogoutViewController {
        let storyboard = UIStoryboard(name: "Logout", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
    }

    func setUpNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = true
        colorNavigationBar(color: Constants.Colors.navigationBarLightGray)
    }
    
    func setUpUI() {
        hidebackButton()
        addUserIcon()
    }
    
    func hidebackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setViewControllers([self], animated: true)
    }
    
    func addUserIcon() {
        navigationItem.rightBarButtonItem = rightNavigationButton
    }
}

// MARK: - Setup Table View -

private extension TopRatedViewController {

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

// MARK: - API Call -

private extension TopRatedViewController {
    
    func fetchShowsFromAPI(router: Router) {
        APIManager
            .shared
            .call(
                router: router,
                responseType: TopRatedResponse.self) { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let payload) :
                        self.handleSuccess(shows: payload.shows)
                        break
                    
                    case .failure :
                        self.handleFailure()
                        break
                    }
        }
    }
}

private extension TopRatedViewController {
    
    func handleSuccess(shows: [Show]) {
        listOfShows.append(contentsOf: shows)
    }
    
    func handleFailure() {
        SVProgressHUD.showError(withStatus: Constants.AlertMessages.networkError)
    }
}

// MARK: - Table View delegates -

extension TopRatedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = listOfShows[indexPath.row]
        navigate(to: .showDetails, with: show)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension TopRatedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTitleTableViewCell", for: indexPath) as! ShowTitleTableViewCell
        cell.setUpCellUI(for: listOfShows[indexPath.row])
        return cell
    }
}

// MARK: - Navigation -

extension TopRatedViewController {

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
