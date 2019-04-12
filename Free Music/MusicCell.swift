//
//  MusicCell.swift
//  Free Music
//
//  Created by Suprianto Djamalu on 12/04/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

class MusicCell : UITableViewCell{
    
    @IBOutlet weak var lbTitle:UILabel!
    @IBOutlet weak var lbArtist:UILabel!
    @IBOutlet weak var imgArt:UIImageView!
    @IBOutlet weak var layoutCell:UIView!
    
    var musics = [Music]()
    var index:Int!
    
    func setup(musics:[Music], index:Int){
        
        self.musics = musics
        self.index = index
        
        MusicPlayer.setTrack(tracks: musics)
        
        lbTitle.text = musics[index].title
        lbArtist.text = musics[index].artist
        imgArt.kf.setImage(with: URL(string: musics[index].art))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MusicCell.onCellTapped))
        
        layoutCell.isUserInteractionEnabled = true
        layoutCell.addGestureRecognizer(tap)
        
    }
    
    @objc
    private func onCellTapped(){
        
        NotificationCenter.default.post(name: Notification.Name("MUSIC"), object: nil, userInfo: [
                "index":String(index)
            ])
        
    }
    
}

extension Notification.Name{
    static let name = Notification.Name("MUSIC")
}


