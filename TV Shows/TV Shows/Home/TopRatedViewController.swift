//
//  TopRatedViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 15.02.2022..
//

import UIKit
import Alamofire

final class TopRatedViewController : UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties -

    lazy private var userButton: UIBarButtonItem = {
        let userButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        userButton.setBackgroundImage(UIImage(named: "userIcon"), for: .normal, barMetrics: .default)
        return userButton
    }()
    
    var listOfShows: [Show] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShowsFromAPI(router: Router.topRated)
        setUpUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
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

private extension TopRatedViewController {
    
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
                    
                    case .failure(let error) :
                        self.handleFailure(error: error)
                        break
                    }
        }
    }
}

private extension TopRatedViewController {
    
    func handleSuccess(shows: [Show]) {
        self.listOfShows.append(contentsOf: shows)
    }
    
    func handleFailure(error: AFError) {
    }
}

// MARK: - Table View delegates -

extension TopRatedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me!")
    }
}

extension TopRatedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! ShowTableViewCell
        cell.setUpCellUI(for: listOfShows[indexPath.row])
        return cell
    }
}
