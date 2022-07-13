//
//  ViewController.swift
//  Playo
//
//  Created by yeshwanth srinivas rao bandaru on 13/07/22.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    //
    var newsDataArray = [Articles]()
    
    @IBOutlet var newsTableView: UITableView!
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsDetails()
        refreshController()
    }
    func refreshController(){
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self,
                                                action: #selector(callPullToRefresh),
                                                for: .valueChanged)
    }
    @objc func callPullToRefresh(){
        newsDetails()
        self.newsTableView.refreshControl?.endRefreshing()
    }
    func newsDetails() {
        if Connectivity.isConnectedToInternet {
            self.view.activityStartAnimating()
            guard let myUrl = URL(string: Playo.dataPopulator) else { return  }
            let myUrlRequest = URLRequest(url: myUrl)
            AF.request(myUrlRequest).responseData { myResponse in
                if let data = myResponse.data{
                    do {
                        let fetchingNewsData = try JSONDecoder().decode(NetworkNewsData.self, from: data)
                        DispatchQueue.main.async { [self] in
                            if let articlesData = fetchingNewsData.articles {
                                newsDataArray = articlesData
                                self.view.activityStopAnimating()
                                newsTableView.reloadData()
                            }
                        }
                    } catch  {
                        DispatchQueue.main.async {
                            self.view.activityStopAnimating()
                            self.showAlertWith(title: errorConstants.Error, message: error.localizedDescription, networkFlag: 1)
                        }
                    }
                }
                if let errorResponse = myResponse.error{
                    self.view.activityStopAnimating()
                    self.showAlertWith(title: errorConstants.Error, message: errorResponse.localizedDescription, networkFlag: 1)
                }
            }
        }else{
            self.view.activityStopAnimating()
            self.showAlertWith(title: errorConstants.noNetwork, message: errorConstants.noNetworkDesc, networkFlag: 0)
        }
    }
    func showAlertWith(title: String, message: String, networkFlag: Int) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if networkFlag == 0{
            let retryAction = UIAlertAction.init(title: generalConstants.retry, style: .default) { (action) in
                self.newsDetails()
            }
            alertController.addAction(retryAction)
            let cancelAction = UIAlertAction.init(title: generalConstants.cancel, style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
        }
        else{
            let OKAction = UIAlertAction(title: generalConstants.ok, style: .default, handler: nil)
            alertController.addAction(OKAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        newsCell.titleLabel.text = newsDataArray[indexPath.row].title
        newsCell.descriptionLabel.text = newsDataArray[indexPath.row].description
        newsCell.authorLabel.text = newsDataArray[indexPath.row].author
        
        DispatchQueue.global(qos: .background).async {
            let operation1 = BlockOperation(block: {
                guard let imageString = self.newsDataArray[indexPath.row].urlToImage else{return}
                guard let myUrl = URL(string: imageString) else {return}
                guard let ImgData = try? Data(contentsOf: myUrl) else {return}
                OperationQueue.main.addOperation({
                    newsCell.newsImage.image = UIImage(data: ImgData)
                })
            })
            self.queue.addOperation(operation1)
        }
        
        return newsCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WebKitVC") as! WebKitVC
        webVc.recieveWebUrl = newsDataArray[indexPath.row].url ?? ""
        navigationController?.pushViewController(webVc, animated: true)
    }
}
