//
//  PlayerViewController.swift
//  iot
//
//  Created by Genobili Mao on 2019/1/10.
//  Copyright © 2019 Genobili Mao. All rights reserved.
//

import UIKit
import Toast_Swift

class PlayerViewController: UIViewController {

    var movieView: UIView!
    var activityView : UIActivityIndicatorView!
    
    var videoURL : String?
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()
    
    var previousPlayerStatePaused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "视频监控"
        self.setUpSubViews()
        
        self.mediaPlayer.addObserver(self, forKeyPath: "time", options: [], context: nil)
        //Add rotation observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(PlayerViewController.rotated),
            name:UIDevice.orientationDidChangeNotification,
            object: nil)
        
        //Add tap gesture to movieView for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PlayerViewController.movieViewTapped(_:)))
        self.movieView.addGestureRecognizer(gesture)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")
        
        //Playing HTTP from internet
        //let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")
        
        //Playing RTSP from internet
        //let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")
        //详细格式参照 https://blog.csdn.net/xiejiashu/article/details/71786187
        //let strURL = String(format: "rtsp://%@:1554/Streaming/Channels/101?transportmode=unicast", cameraIP?.count ?? 0 == 0 ? "113.90.238.121" : cameraIP!)
        //let strURL = String(format: "rtsp://%@:1554/Streaming/tracks/101?starttime=20180901t093812z&endtime=20180901t104816z", cameraIP?.count ?? 0 == 0 ? "113.90.238.121" : cameraIP!)
        guard  videoURL != nil else {
            print("Invalid URL")
            return
        }
        let media = VLCMedia(url: URL(string: videoURL!)!)
        media.addOptions([
            "rtsp-user" : "admin",
            "rtsp-pwd" : "topspeak@123"
            ])
        
        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView
        if !mediaPlayer.isPlaying {
            mediaPlayer.play()
        }
    }
    
    deinit {
        self.mediaPlayer.removeObserver(self, forKeyPath: "time")
        mediaPlayer.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   private func setUpSubViews() {
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.gray
        self.movieView.frame = UIScreen.screens[0].bounds
        //Add movieView to view controller
        self.view.addSubview(self.movieView)
    
        activityView = UIActivityIndicatorView(style: .white)
        self.movieView.addSubview(activityView)
        self.activityView.center = self.movieView.center
    }

    @objc func rotated() {
        
        let orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.landscapeLeft || orientation == UIDeviceOrientation.landscapeRight {
            print("Switched to landscape")
        }else {
            print("Switched to portrait")
        }
        
        //Always fill entire screen
        self.movieView.frame = self.view.frame
    }
    
    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {
        
        if mediaPlayer.isPlaying {
            mediaPlayer.pause()
            
            let remaining = mediaPlayer.remainingTime
            let time = mediaPlayer.time
            
            print("Paused at \(time?.stringValue ?? "nil") with \(remaining?.stringValue ?? "nil") time remaining")
        }
        else {
            mediaPlayer.play()
            print("Playing")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "time"  {
            self.updateActivityIndicatorForState(forState: VLCMediaPlayerState.playing)
        }
    }
    
    
    private func updateActivityIndicatorForState(forState state:VLCMediaPlayerState) {
        if state == VLCMediaPlayerState.playing || state == VLCMediaPlayerState.paused  {
            self.previousPlayerStatePaused = state == VLCMediaPlayerState.paused
        }
        let shouldAnimate = state == VLCMediaPlayerState.buffering && !self.previousPlayerStatePaused
        print("shouldAnimate = \(shouldAnimate)")
        if self.activityView.isAnimating != shouldAnimate {
            self.activityView.alpha = shouldAnimate ? 1.0 : 0.0
            shouldAnimate ? self.activityView.startAnimating() : self.activityView.stopAnimating()
        }
    }
}

extension PlayerViewController : VLCMediaPlayerDelegate {
    
//    typedef NS_ENUM(NSInteger, VLCMediaPlayerState)
//    {
//    VLCMediaPlayerStateStopped,        ///< Player has stopped
//    VLCMediaPlayerStateOpening,        ///< Stream is opening
//    VLCMediaPlayerStateBuffering,      ///< Stream is buffering
//    VLCMediaPlayerStateEnded,          ///< Stream has ended
//    VLCMediaPlayerStateError,          ///< Player has generated an error
//    VLCMediaPlayerStatePlaying,        ///< Stream is playing
//    VLCMediaPlayerStatePaused,         ///< Stream is paused
//    VLCMediaPlayerStateESAdded         ///< Elementary Stream added
//    };
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        let mediaPlayer = aNotification.object as? VLCMediaPlayer
        guard let player = mediaPlayer else {
            return
        }
        let state = player.state  //VLCMediaPlayerState
        print( "state = \(state.rawValue)")
        self.updateActivityIndicatorForState(forState: state)
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        
    }
    
    func mediaPlayerTitleChanged(_ aNotification: Notification!) {
        
    }
    
    
    func mediaPlayerChapterChanged(_ aNotification: Notification!) {
        
    }
    
    func mediaPlayerSnapshot(_ aNotification: Notification!) {
        
    }
    
    func mediaPlayerStartedRecording(_ player: VLCMediaPlayer!) {
        
    }
    
    func mediaPlayer(_ player: VLCMediaPlayer!, recordingStoppedAtPath path: String!) {
        
    }
    
}
