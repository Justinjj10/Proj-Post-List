//
//  PostListViewController.swift
//  Proj_Assesment
//
//  Created by Justin Joseph on 08/05/24.
//

import UIKit

class PostListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.isHidden = true
        }
    }
    private var postsList: [Posts] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var fetchSession: URLSessionDataTask?
    var isPaginating: Bool = false
    var currentPage = 1
    private var selectedPost: Posts?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }
    
    private func fetchPosts() {
        if !(fetchSession?.progress.isFinished ?? true) {
            return
        }
        showLoader()
        fetchSession = PostsServiceRequests().getAllPosts(page: currentPage) { [weak self] apiResult in
            self?.fetchSession = nil
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
                self?.hideLoader()
                switch apiResult {
                case .success(let postList):
                    if postList.isEmpty {
                        self?.isPaginating = true
                    } else {
                        self?.isPaginating = false
                        self?.postsList.reserveCapacity((self?.postsList.count ?? 0) + postList.count)
                        self?.postsList.append(contentsOf: postList)
                    }
                   
                case .failure(let error):
                    self?.isPaginating = true
                    self?.showAPIError(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showLoader() {
        if currentPage == 1 {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            tableView.isHidden = true
        }
    }
    
    private func hideLoader() {
        if currentPage == 1 {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func showAPIError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let refreshAction = UIAlertAction(title: "Refresh", style: .default) { [weak self] alertAction in
            self?.tableView.reloadData()
        }
        alertController.addAction(okAction)
        alertController.addAction(refreshAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func createTableSpinnerFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        footer.addSubview(spinner)
        spinner.startAnimating()
        return footer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let destinationVC = segue.destination as? DetailsViewController {
                destinationVC.post = self.selectedPost
            }
        }
    }
}

extension PostListViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let postsCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell {
            postsCell.updateCell(with: postsList[indexPath.row])
            return postsCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPost = postsList[indexPath.row]
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
     //   print("position is \(position) content is \(self.tableView.contentSize.height - 150)")
        if position > self.tableView.contentSize.height - 100 - scrollView.frame.size.height {
            guard !isPaginating else {
                return
            }
            currentPage += 1
            self.tableView.tableFooterView = createTableSpinnerFooter()
            self.fetchPosts()
        }
    }

}
