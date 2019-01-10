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
    
    var lastPlayerState : VLCMediaPlayerState = VLCMediaPlayerState.paused
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "视频监控"
        self.setUpSubViews()
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
    
    private func startLoading() {
        if !self.activityView.isAnimating {
            self.activityView.startAnimating()
        }
        self.activityView.isHidden = false
    }
    
    private func stopLoading() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.activityView.isHidden = true
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
        switch state  {
        case VLCMediaPlayerState.stopped:
            self.mediaPlayer.stop()
            self.stopLoading()
            self.movieView.makeToast("播放停止", duration: 2.0, position: .bottom)
        case VLCMediaPlayerState.opening:
            self.startLoading()
        case VLCMediaPlayerState.playing:
            if self.lastPlayerState != VLCMediaPlayerState.esAdded {
                self.stopLoading()
            }
        case VLCMediaPlayerState.buffering:
            if self.lastPlayerState == VLCMediaPlayerState.esAdded || self.lastPlayerState == VLCMediaPlayerState.buffering {
                self.stopLoading()
            }else{
                self.startLoading()
            }
        case VLCMediaPlayerState.esAdded:
            self.startLoading()
        case VLCMediaPlayerState.error:
            self.mediaPlayer.stop()
            self.stopLoading()
            self.movieView.makeToast("播放错误", duration: 2.0, position: .bottom)
        default:
            break
        }
        self.lastPlayerState = state
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
