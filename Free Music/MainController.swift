//
//  ViewController.swift
//  Free Music
//
//  Created by Suprianto Djamalu on 12/04/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MainController: UIViewController {

    @IBOutlet weak var tableMusic:UITableView!
    @IBOutlet weak var loading:UIActivityIndicatorView!
    @IBOutlet weak var layoutOnPlaying:UIView!
    @IBOutlet weak var imgOnPlaying:UIImageView!
    @IBOutlet weak var lbTitleOnPlaying:UILabel!
    @IBOutlet weak var lbArtistOnPlaying:UILabel!
    @IBOutlet weak var btnPrevious:UIImageView!
    @IBOutlet weak var btnPlay:UIImageView!
    @IBOutlet weak var btnNext:UIImageView!

    var musics = [Music]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHandle()
        loadMusicFromApi()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if MusicPlayer.isPlaying() {
            btnPlay.image = UIImage(named: "img_pause")
        }else{
            btnPlay.image = UIImage(named: "img_play")
        }
    }
    
    private func viewHandle(){
        tableMusic.dataSource = self
        tableMusic.delegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("MUSIC"), object: nil, queue:nil, using:musicReceiver)
        
        let btnPlayTap = UITapGestureRecognizer(target: self, action: #selector(MainController.btnPlayTapped))
        btnPlay.isUserInteractionEnabled = true
        btnPlay.addGestureRecognizer(btnPlayTap)
        
        let btnNextTap = UITapGestureRecognizer(target: self, action: #selector(MainController.btnNextTapped))
        btnNext.isUserInteractionEnabled = true
        btnNext.addGestureRecognizer(btnNextTap)
        
        let btnPreviousTap = UITapGestureRecognizer(target: self, action: #selector(MainController.btnPreviousTapped))
        btnPrevious.isUserInteractionEnabled = true
        btnPrevious.addGestureRecognizer(btnPreviousTap)
        
    }
    
    private func musicReceiver(notification:Notification) -> Void{
        MusicPlayer.play(index: Int(notification.userInfo!["index"] as! String)!)
        
        layoutOnPlaying.isHidden = false
        lbTitleOnPlaying.text = MusicPlayer.getTitle()
        lbArtistOnPlaying.text = MusicPlayer.getArtist()
        imgOnPlaying.kf.setImage(with: URL(string: MusicPlayer.getArt()))
        btnPlay.image = UIImage(named: "img_pause")
    }
    
    @objc
    private func btnPlayTapped(){
        
        if MusicPlayer.player() != nil{
            
            if MusicPlayer.isPlaying() {
                MusicPlayer.pause()
                btnPlay.image = UIImage(named: "img_play")
            }else{
                MusicPlayer.resume()
                btnPlay.image = UIImage(named: "img_pause")
            }
            
        }else{
            
        }
        
    }
    
    @objc
    private func btnNextTapped(){
        if MusicPlayer.player() != nil{
            MusicPlayer.next()
            lbTitleOnPlaying.text = MusicPlayer.getTitle()
            lbArtistOnPlaying.text = MusicPlayer.getArtist()
            imgOnPlaying.kf.setImage(with: URL(string: MusicPlayer.getArt()))
        }
    }
    
    @objc
    private func btnPreviousTapped(){
        if MusicPlayer.player() != nil{
            MusicPlayer.previous()
            lbTitleOnPlaying.text = MusicPlayer.getTitle()
            lbArtistOnPlaying.text = MusicPlayer.getArtist()
            imgOnPlaying.kf.setImage(with: URL(string: MusicPlayer.getArt()))
        }
    }
    
    private func loadMusicFromApi(){
        
        loading.isHidden = false
        loading.startAnimating()
        
        AF.request("http://192.168.56.1/anows/freemusic/music.php").responseJSON{response in
            
            switch response.result{
                
                case .success(_):
                    
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                    
                    let json = JSON(response.result.value!)
                    
                    for i in 0 ..< json["music"].count{
                        let title = json["music"][i]["title"].string!
                        let artist = json["music"][i]["artist"].string!
                        let file = json["music"][i]["file"].string!
                        let art = json["music"][i]["art"].string!
                        
                        self.musics.append(Music(
                            title: title,
                            artist: artist,
                            file: file,
                            art: art
                        ))
                        
                    }
                    
                    self.tableMusic.reloadData()
                    break
                
                case .failure(_):
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                    break
                
            }
            
            
            
        }
        
    }


}

extension MainController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicCell
        
        let foreground = UIView()
        foreground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        cell.selectedBackgroundView = foreground
        cell.setup(musics: musics, index: indexPath.row)
        
        return cell
    }
    
    
}

