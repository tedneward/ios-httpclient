//
//  ViewController.swift
//  HTTPClient
//
//  Created by Ted Neward on 11/4/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var addressField: UITextField!
  @IBOutlet weak var headersLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  var headerString : String = ""
  var bodyString : String = ""
  
  @IBAction func goPushed(_ sender: Any) {
    headersLabel.text! = ""
    bodyLabel.text! = "Sending request \nto \(addressField.text!)..."
    
    // Set up the request before we do the off-UI thread work
    let url = URL(string: self.addressField.text!)
    if url == nil {
      // TODO: Need a better error message
      NSLog("Bad address")
      return
    }

    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    
    headersLabel.text! = "\(request.httpMethod!) \(url!.absoluteString) HTTP/1.1\n"
    let headerFields = request.allHTTPHeaderFields
    for (name, value) in headerFields! {
      headersLabel.text! = headersLabel.text! + "\(name) = \(value)\n"
    }
    
    // Set up a spinner
    spinner.startAnimating()
    
    // Move to a background thread to do some long running work
    (URLSession.shared.dataTask(with: url!) {
      data, response, error in
      
      DispatchQueue.main.async {
        if error == nil {
          NSLog(response!.description)
          
          let response = response! as! HTTPURLResponse
          
          var headers = ""
          headers = "\(response.statusCode)\n"
          for (name, value) in response.allHeaderFields {
            headers += "\(name as! String) = \(value as! String))\n"
          }
          self.headersLabel.text! = headers
          
          if data == nil {
            self.bodyLabel.text! = "<Body is empty>"
          }
          else {
            NSLog(data!.description)
            self.bodyLabel.text! = String(describing: data!)
          }
        }
        else {
          self.headersLabel.text! = error!.localizedDescription
        }
        
        self.spinner.stopAnimating()
      }
    }).resume()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

