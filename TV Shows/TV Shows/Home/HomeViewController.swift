//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 07.02.2022..
//

import UIKit
import Alamofire



final class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var showImage: UIImageView!
    @IBOutlet private weak var showTitle: UILabel!
    
    func setUpCellUI(for show: Show) {
        setUpImageView(url: show.imageURL ?? "")
        setUpTitleLabel(title: show.title)
    }
    
    func setUpImageView(url: String) {
        guard let showImageURL = URL(string: url) else { return }
        showImage.loadImageFromNetwork(url: showImageURL)
    }
    
    func setUpTitleLabel(title: String) {
        showTitle.text = title
    }
    
    override func prepareForReuse() {
        showImage.image = nil
    }
    
}

extension UIImageView {
    func loadImageFromNetwork(url: URL) {
        DispatchQueue
            .global()
            .async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.image = image }
                }
            }
    }
}

final class HomeViewController : UIViewController {
    
    
    // MARK: - Private properties -
    
    private var networkCallInProgress = false
    
    private var currentPage = 1
    private var numberOfPages = 0
    private var numberOfShowsPerPage = 8
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy private var userButton: UIBarButtonItem = {
        let userButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        userButton.setBackgroundImage(UIImage(named: "userIcon"), for: .normal, barMetrics: .default)
        return userButton
    }()
    
    var listOfShows: [Show] = [] {
        didSet {
            tableView.reloadData()
            updateNetworkCallStatus()
            
        }
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShowsFromAPI(router: Router.shows(items: numberOfShowsPerPage, page: currentPage))
        setUpUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        //        setUpCornerRadius()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Extensions -

private extension HomeViewController {
    
    // MARK: - Setup UI -
    
    func setUpUI() {
        hidebackButton()
        addUserIcon()
    }
    
    func hidebackButton() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setViewControllers([self], animated: true)
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

private extension HomeViewController {
    
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
        !networkCallInProgress && currentPage<=numberOfPages
    }
}

private extension HomeViewController {
    
    func handleSuccess(shows: [Show]) {
        self.listOfShows.append(contentsOf: shows)
    }
    
    func handleFailure(error: AFError) {
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Yout tapped me!")
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! ShowTableViewCell
        cell.setUpCellUI(for: listOfShows[indexPath.row])
        return cell
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let scrollViewBottom = tableView.contentSize.height-100-scrollView.frame.height
        if position > scrollViewBottom, canFetchMore() {
            self.tableView.tableFooterView = createSpinnerFooter()
            fetchShowsFromAPI(router: .shows(items: numberOfShowsPerPage, page: currentPage))
            self.tableView.tableFooterView = nil
            print("fetching 2 items from page:" + String(currentPage) + "of: " + String(numberOfPages))
        }
    }
}
