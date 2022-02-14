//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 07.02.2022..
//

import UIKit
import Alamofire

final class ShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var showTitle: UILabel!
    
    func setUpCell(show: Show) {
        setUpImageView(url: show.imageURL ?? "")
        setUpTitleLabel(title: show.title)
    }
    
    func setUpImageView(url: String) {
        guard let showImageURL = URL(string: url) else { return }
        showImage.load(url: showImageURL)
    }
    
    func setUpTitleLabel(title: String) {
        showTitle.text = title
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

final class HomeViewController : UIViewController {
    
    
    // MARK: - Private properties -
    
    @IBOutlet private weak var tableView: UITableView!
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
        fetchShowsFromAPI(router: Router.shows(items: 20, page: 1))
        setUpUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        setUpCornerRadius()
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
    
}

// MARK: - API Call -

private extension HomeViewController {
    
    func fetchShowsFromAPI(router: Router) {
        APIManager
            .shared
            .call(
                router: router,
                responseType: ShowsResponse.self) { [weak self] response in
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

private extension HomeViewController {
    
    func handleSuccess(shows: [Show]) {
        self.listOfShows = shows
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
        cell.setUpCell(show: listOfShows[indexPath.row])
        return cell
    }
}
