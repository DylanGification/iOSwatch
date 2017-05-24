//
//  Stats.swift
//  iOSwatch
//
//  Created by Dylan Grace on 24/05/2017.
//  Copyright © 2017 WIT. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SDWebImage

class StatsController: UIViewController, UITextViewDelegate, NVActivityIndicatorViewable {
    
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var levelLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var levelNum: UILabel!
//    @IBOutlet weak var quickPlayTitle: UILabel!
//    @IBOutlet weak var competitivePlayTitle: UILabel!
//    @IBOutlet weak var avatarImage: UIImageView!
//    @IBOutlet weak var competitiveRankLabel: UILabel!
//    @IBOutlet weak var competitiveRankNum: UILabel!
//    @IBOutlet weak var quickPercent: UILabel!
//    @IBOutlet weak var compPercent: UILabel!
//    @IBOutlet weak var compPlayTime: UILabel!
//    @IBOutlet weak var quickPlayTime: UILabel!
//    
//    
//    var player:Player? // Player info from last ViewController
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//        self.tabBarController?.title = "Profile"
//    }
//    
//    override func viewDidLoad() {
//        
//        self.nameLabel.text = player!.name
//        self.levelNum.text = player!.level
//        
//        if(player!.rank == ""){
//            player!.rank = "N/A"
//        }
//        self.competitiveRankNum.text = player!.rank
//        self.compPercent.text = player!.totalWinPerc
//        self.compPlayTime.text = player!.time
//        
//        
//        /*
//         * Circular UIImageView
//         **/
//        self.avatarImage.layer.cornerRadius = 10.0
//        self.avatarImage.clipsToBounds = true;
//        
//        /**
//         * Border for UIImageView
//         **/
//        self.avatarImage.layer.borderWidth = 3.0
//        self.avatarImage.layer.borderColor = UIColor.black.cgColor
//        
//        /**
//         * Setup image using SDWebImage Library
//         **/
//        self.avatarImage.sd_setImage(with: URL(string: player!.avatar))
//        
//    }
}
