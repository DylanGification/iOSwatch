//
//  ViewController.swift
//  iOSwatch
//
//  Created by Dylan Grace on 23/05/2017.
//  Copyright © 2017 WIT. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController, UITextViewDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var platformSelect: UISegmentedControl!
    @IBOutlet weak var regionSelect: UISegmentedControl!
    @IBOutlet weak var tagTextField: UITextField!
    
    var currentPlayer:Player = Player()
    
    @IBAction func platformSelection(_ sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex){
            
        case 0:
            currentPlayer.platform = "pc"
        case 1:
            currentPlayer.platform = "xbl"
        case 2:
            currentPlayer.platform = "psn"
        default:
            currentPlayer.platform = "pc"
            print("No current selection")
        }
        if(currentPlayer.platform == "xbl" || currentPlayer.platform == "psn"){
            currentPlayer.region = "any"
        }
        print(currentPlayer.platform)
        
    }
    
    @IBAction func regionSelection(_ sender: UISegmentedControl) {
        
        switch(sender.selectedSegmentIndex){
            
        case 0:
            currentPlayer.region = "eu"
        case 1:
            currentPlayer.region = "us"
        case 2:
            currentPlayer.region = "kr"
        case 3:
            currentPlayer.region = "any"
        default:
            currentPlayer.region = "eu"
        }
        print(currentPlayer.region)
    }
    
    func dismissKeyboard() {
        view.endEditing(true) //closes keyboard
    }
    
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func getUserStats(_ sender: AnyObject){
        
        if let str = tagTextField.text {
            dismissKeyboard()
            let urlStr:String = ("https://www.owapi.net/api/v3/u/" + str + "/blob?platform=" + currentPlayer.platform)
            var request = URLRequest(url: URL(string: urlStr)!)
            let session = URLSession.shared
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.blue)
            activityIndicatorView.center = view.center
            view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        do {
                            let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                            if let responseData = jsonDict[self.currentPlayer.region] as? NSDictionary {
                                if let stats = responseData["stats"] as? NSDictionary{
                                    if let competitive = stats["competitive"] as? NSDictionary {
                                        if let average_stats = competitive["average_stats"] as? NSDictionary {
                                            if let avgElims:Int = average_stats["eliminations_avg"] as! Int{
                                                self.currentPlayer.avgElims = String(avgElims)
                                            }
                                        }
                                        if let game_stats = competitive["game_stats"] as? NSDictionary {
                                            if let time:Int = game_stats["time_played"] as! Int {
                                                self.currentPlayer.time = String(time)
                                            }
                                        }
                                        if let overall_stats = competitive["overall_stats"] as? NSDictionary {
                                            if let level:Int = overall_stats["level"] as! Int {
                                                self.currentPlayer.level = String(level)
                                            }
                                            if let rank:Int = overall_stats["comprank"] as! Int {
                                                self.currentPlayer.rank = String(rank)
                                            }
                                            if let totalWinPerc:Int = overall_stats["win_rate"] as! Int {
                                                self.currentPlayer.totalWinPerc = String(totalWinPerc)
                                                print(totalWinPerc)
                                            }
                                            self.currentPlayer.avatar = overall_stats["avatar"] as! String
                                        
                                        }
                                    }
                                }
                            }
                            activityIndicatorView.stopAnimating()
                            self.tagTextField.text = ""
                        }
                        catch let error as NSError{
                            print(error)
                        }
                    }
                }
                else{
                    DispatchQueue.main.async{
                        self.tagTextField.text = "Error"
                    }
                }
            })
            task.resume()
        }
        else {
            self.tagTextField.text = ""
        }
    }
    
    
}
