//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 07.02.2022..
//

import UIKit
import Alamofire
import Kingfisher

final class ShowsViewController : UIViewController {
    
    // MARK: - Private properties -
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy private var userButton: UIBarButtonItem = {
        let userButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        userButton.setBackgroundImage(UIImage(named: "userIcon"), for: .normal, barMetrics: .default)
        return userButton
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
        tableView.register(cellNib, forCellReuseIdentifier: "ShowCell")
    }
}

private extension ShowsViewController {
    
    // MARK: - Setup UI -
    
    func setUpUI() {
        colorNavigationBar(color: Constants.Colors.navigationBarLightGray)
        hidebackButton()
        addUserIcon()
    }
    
    func hidebackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setViewControllers([self], animated: true)
        self.navigationController?.navigationBar.barTintColor = .red
    }
    
    func addUserIcon() {
        navigationItem.rightBarButtonItem = userButton
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        return footerView
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
                        
                    case .failure(let error) :
                        self.handleFailure(error: error)
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
        self.listOfShows.append(contentsOf: shows)
        self.tableView.tableFooterView = nil
    }
    
    func handleFailure(error: AFError) {
    }
}

// MARK: - Table View delegates -

extension ShowsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let show = listOfShows[indexPath.row]
        print("Yout tapped show with id: " + show.id + " <<::>> " + show.title)
    }
}

extension ShowsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! ShowTitleTableViewCell
        cell.setUpCellUI(for: listOfShows[indexPath.row])
        return cell
    }
}

extension ShowsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let visiblePaths = tableView.indexPathsForVisibleRows,
            visiblePaths.contains([0, listOfShows.count - 1]), canFetchMore() {
            
            self.tableView.tableFooterView = createSpinnerFooter()
            fetchShowsFromAPI(router: .shows(items: numberOfShowsPerPage, page: currentPage))
        }
    }
}
