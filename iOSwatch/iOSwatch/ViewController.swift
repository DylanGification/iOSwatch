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
import SDWebImage

class ViewController: UIViewController, UITextViewDelegate, NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var platformSelect: UISegmentedControl!
    @IBOutlet weak var regionSelect: UISegmentedControl!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var owIcon: UIImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var userPlatform: UITextField!
    @IBOutlet weak var userRegion: UITextField!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelText: UITextField!
    @IBOutlet weak var prestigeLabel: UILabel!
    @IBOutlet weak var prestigeText: UITextField!
    @IBOutlet weak var RankText: UITextField!
    @IBOutlet weak var RankLabel: UILabel!
    @IBOutlet weak var WinRateLabel: UILabel!
    @IBOutlet weak var WinRateText: UITextField!
    @IBOutlet weak var AvgElimsLabel: UILabel!
    @IBOutlet weak var AvgElimsText: UITextField!
    @IBOutlet weak var TimePlayedLabel: UILabel!
    @IBOutlet weak var TimeText: UITextField!
    @IBOutlet weak var Back: UIButton!
    
    var currentPlayer:Player = Player()
    
    override func viewDidLoad() {
        avatarImage.isHidden = true
        name.isHidden = true
        userPlatform.isHidden = true
        userRegion.isHidden = true
        levelLabel.isHidden = true
        levelText.isHidden = true
        prestigeLabel.isHidden = true
        prestigeText.isHidden = true
        RankText.isHidden = true
        RankLabel.isHidden = true
        WinRateText.isHidden = true
        WinRateLabel.isHidden = true
        AvgElimsText.isHidden = true
        AvgElimsLabel.isHidden = true
        TimePlayedLabel.isHidden = true
        TimeText.isHidden = true
        Back.isHidden = true
    }
    
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
            currentPlayer.name = str
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
                                            if let prestige:Int = overall_stats["prestige"] as! Int {
                                                self.currentPlayer.prestige = String(prestige)
                                            }
                                            if let rank:Int = overall_stats["comprank"] as! Int {
                                                self.currentPlayer.rank = String(rank)
                                            }
                                            if let totalWinPerc:Int = overall_stats["win_rate"] as! Int {
                                                self.currentPlayer.totalWinPerc = String(totalWinPerc)
                                            }
                                            self.currentPlayer.avatar = overall_stats["avatar"] as! String
                                        
                                        }
                                    }
                                }
                            }
                            self.hideStuff()
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
    
    func hideStuff() {
        platformSelect.isHidden = true
        regionSelect.isHidden = true
        tagTextField.isHidden = true
        SearchButton.isHidden = true
        owIcon.isHidden = true
        avatarImage.isHidden = false
        name.isHidden = false
        userPlatform.isHidden = false
        userRegion.isHidden = false
        levelLabel.isHidden = false
        levelText.isHidden = false
        prestigeLabel.isHidden = false
        prestigeText.isHidden = false
        RankText.isHidden = false
        RankLabel.isHidden = false
        WinRateText.isHidden = false
        WinRateLabel.isHidden = false
        AvgElimsText.isHidden = false
        AvgElimsLabel.isHidden = false
        TimePlayedLabel.isHidden = false
        TimeText.isHidden = false
        
        /*
         * Circular UIImageView
         **/
        self.avatarImage.layer.cornerRadius = 10.0
        self.avatarImage.clipsToBounds = true;
        
        /**
         * Border for UIImageView
         **/
        self.avatarImage.layer.borderWidth = 3.0
        self.avatarImage.layer.borderColor = UIColor.black.cgColor
        
        /**
         * Setup image using SDWebImage Library
         **/
        avatarImage.sd_setImage(with: URL(string: currentPlayer.avatar))
        
        name.text = currentPlayer.name
        userPlatform.text = currentPlayer.platform
        userRegion.text = currentPlayer.region
        levelText.text = currentPlayer.level
        prestigeText.text = currentPlayer.prestige
        RankText.text = currentPlayer.rank
        WinRateText.text = currentPlayer.totalWinPerc
        AvgElimsText.text = currentPlayer.avgElims
        TimeText.text = currentPlayer.time
        Back.isHidden = false
    }
    
    @IBAction func backToMain(){
        avatarImage.isHidden = true
        name.isHidden = true
        userPlatform.isHidden = true
        userRegion.isHidden = true
        levelLabel.isHidden = true
        levelText.isHidden = true
        prestigeLabel.isHidden = true
        prestigeText.isHidden = true
        RankText.isHidden = true
        RankLabel.isHidden = true
        WinRateText.isHidden = true
        WinRateLabel.isHidden = true
        AvgElimsText.isHidden = true
        AvgElimsLabel.isHidden = true
        TimePlayedLabel.isHidden = true
        TimeText.isHidden = true
        platformSelect.isHidden = false
        regionSelect.isHidden = false
        tagTextField.isHidden = false
        SearchButton.isHidden = false
        owIcon.isHidden = false
        Back.isHidden = true
    }
    
    
}
