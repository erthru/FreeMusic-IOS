//
//  DetailController.swift
//  Free Music
//
//  Created by Suprianto Djamalu on 13/04/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class DetailController: UIViewController {

    @IBOutlet weak var btnBack:UIImageView!
    @IBOutlet weak var imgArt:UIImageView!
    @IBOutlet weak var lbTitle:UILabel!
    @IBOutlet weak var lbArtist:UILabel!
    @IBOutlet weak var slider:UISlider!
    @IBOutlet weak var btnPrevious:UIImageView!
    @IBOutlet weak var btnPlay:UIImageView!
    @IBOutlet weak var btnNext:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewHandling()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imgArt.kf.setImage(with: URL(string: MusicPlayer.getArt()))
        lbTitle.text = MusicPlayer.getTitle()
        lbArtist.text = MusicPlayer.getArtist()
        if MusicPlayer.isPlaying() {
            btnPlay.image = UIImage(named: "img_pause")
        }else{
            btnPlay.image = UIImage(named: "img_play")
        }
        
        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
    }
    
    @objc
    private func updateSlider(){
        slider.maximumValue = Float(MusicPlayer.duration())
        slider.value = Float(MusicPlayer.currentTime())
    }
    
    private func viewHandling(){
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue:nil, using:avPlayerReceiver)
        
        let btnBackTap = UITapGestureRecognizer(target: self, action: #selector(DetailController.btnBackTapped))
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(btnBackTap)
        
        let btnPlayTap = UITapGestureRecognizer(target: self, action: #selector(DetailController.btnPlayTapped))
        btnPlay.isUserInteractionEnabled = true
        btnPlay.addGestureRecognizer(btnPlayTap)
        
        let btnNextTap = UITapGestureRecognizer(target: self, action: #selector(DetailController.btnNextTapped))
        btnNext.isUserInteractionEnabled = true
        btnNext.addGestureRecognizer(btnNextTap)
        
        let btnPreviousTap = UITapGestureRecognizer(target: self, action: #selector(DetailController.btnPreviousTapped))
        btnPrevious.isUserInteractionEnabled = true
        btnPrevious.addGestureRecognizer(btnPreviousTap)
                
    }
    
    private func avPlayerReceiver(notification:Notification) -> Void{
        btnPlay.image = UIImage(named: "img_play")
        MusicPlayer.stop()
    }
    
    @IBAction
    private func sliderOnSlide(){
        let targetTime = CMTimeMake(value: Int64(slider!.value), timescale: 1)
        MusicPlayer.seekTo(time: targetTime)
    }
    
    @objc
    private func btnBackTapped(){
        dismiss(animated: true, completion: nil)
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
            MusicPlayer.replay()
            btnPlay.image = UIImage(named: "img_pause")
        }
    }
    
    @objc
    private func btnNextTapped(){
        MusicPlayer.next()
        imgArt.kf.setImage(with: URL(string: MusicPlayer.getArt()))
        lbTitle.text = MusicPlayer.getTitle()
        lbArtist.text = MusicPlayer.getArtist()
        btnPlay.image = UIImage(named: "img_pause")
    }
    
    @objc
    private func btnPreviousTapped(){
        MusicPlayer.previous()
        imgArt.kf.setImage(with: URL(string: MusicPlayer.getArt()))
        lbTitle.text = MusicPlayer.getTitle()
        lbArtist.text = MusicPlayer.getArtist()
        btnPlay.image = UIImage(named: "img_pause")
    }
    
}
