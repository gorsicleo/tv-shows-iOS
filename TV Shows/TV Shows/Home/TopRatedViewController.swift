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
    lazy private var rightNavigationButton: UIBarButtonItem = {
        let userButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        userButton.setBackgroundImage(
            UIImage(named: "userIcon"),
            for: .normal,
            barMetrics: .default
        )
        return userButton
    }()

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
        fetchShowsFromAPI(router: Router.topRated)
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
    
    // MARK: - Setup UI -

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
