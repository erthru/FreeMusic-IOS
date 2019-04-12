//
//  MusicPlayer.swift
//  Free Music
//
//  Created by Suprianto Djamalu on 12/04/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import AVFoundation
class MusicPlayer{
    
    private static var title:String!
    private static var artist:String!
    private static var file:String!
    private static var art:String!
    private static var avPlayer:AVPlayer?
    private static var on = false
    private static var current = 0
    
    private static var tracks = [Music]()
    
    static func play(index:Int){
        
        self.title = tracks[index].title
        self.artist = tracks[index].artist
        self.file = tracks[index].file
        self.art = tracks[index].art
        self.current = index
        
        let url = URL.init(string: self.file)
        let playerItem = AVPlayerItem.init(url: url!)
        avPlayer = AVPlayer.init(playerItem: playerItem)
        avPlayer?.play()
        on = true
        
    }
    
    static func isPlaying() -> Bool{
        return on
    }
    
    static func stop(){
        if avPlayer != nil{
            avPlayer?.pause()
            avPlayer = nil
            on = false
        }
    }
    
    static func pause(){
        if avPlayer != nil{
            avPlayer?.pause()
            on = false
        }
    }
    
    static func resume(){
        if avPlayer != nil{
            avPlayer?.play()
            on = true
        }
    }
    
    static func next(){
        if current == tracks.count - 1{
            play(index: current)
        }else{
            play(index: current + 1)
        }
    }
    
    static func player() -> AVPlayer?{
        return avPlayer
    }
    
    static func previous(){
        if current == 0{
            play(index: 0)
        }else{
            play(index: current - 1)
        }
    }
    
    static func getTitle() -> String{
        return self.title
    }
    
    static func getArtist() -> String{
        return self.artist
    }
    
    static func getFile() -> String{
        return self.file
    }
    
    static func getArt() -> String{
        return self.art
    }
    
    static func setTrack(tracks:[Music]){
        self.tracks = tracks
    }
    
}
