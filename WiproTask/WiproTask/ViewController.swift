//
//  ViewController.swift
//  WiproTask
//
//  Created by apple on 10/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
class ViewController: UITableViewController,UINavigationControllerDelegate {
    let cellId = "cellId"
    var products  = [DetailProducts]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Contacts"
        postOrder()
        tableView.register(ProductCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor.lightGray
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        let currentLastItem = products[indexPath.row]
        cell.product = currentLastItem
        return cell
    }
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func postOrder() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: [:], options: [])
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            let cfEnc = CFStringEncodings.isoLatin5
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
            _ = NSString(data: data!, encoding: enc)
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    _ = json["success"] as? Int
                } else {
                    let cfEnc = CFStringEncodings.isoLatin5
                    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                    let jsonStr = NSString(data: data!, encoding: enc)
                }
            } catch let parseError {
                print(parseError)
                let cfEnc = CFStringEncodings.isoLatin5
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                let jsonStr = NSString(data: data!, encoding: enc)
                let dict = self.convertToDictionary(text: jsonStr as! String)
                let faqList = dict!["rows"] as! [AnyObject]
                if faqList.count > 0
                {
                    self.products.removeAll()
                    for faq in faqList
                    {
                        let quesation  = "\(faq.value(forKey: "title") as AnyObject)"
                        let answer = "\(faq.value(forKey: "description") as AnyObject)"
                        let imageHref = "\(faq.value(forKey: "imageHref") as AnyObject)"
                       
                        print(quesation,answer,imageHref)
                        self.products.append(DetailProducts.init(productNmae: quesation, productImg: imageHref , productDes: answer))
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.navigationItem.title = dict!["title"] as? String
                    self.tableView.reloadData()
                })
            }
         
        }
        
        task.resume()
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
struct DetailProducts {
    var productName : String?
    var productImage : String?
    var productDesc : String?
    
    init(productNmae : String, productImg :String , productDes : String) {
        self.productDesc = productDes
        self.productImage = productImg
        self.productName = productNmae
    }
}


