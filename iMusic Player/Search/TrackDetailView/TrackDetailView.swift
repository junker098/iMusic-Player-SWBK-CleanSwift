//
//  TrackDetailView.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 09.10.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

//MARK: - Protocols

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
     //MARK: - Outlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var currentTrackLabel: UILabel!
    @IBOutlet weak var currentAuthorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    weak var delegate: TrackMovingDelegate?
    
    let player: AVPlayer = {
       let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false  //Снимает задержку при загрузке
        return player
    }()
    
        //MARK: - awakeFromNib()
    
    override func awakeFromNib() {
        super .awakeFromNib()
        normalTrackImageSize()
    }
    
     //MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        
        currentTrackLabel.text = viewModel.trackName
        currentAuthorLabel.text = viewModel.artistName
        playTrack(previewURL: viewModel.previewURL)
        monitorStartTime()
        observePlayerrCurrentTime()
        
        let string600 = viewModel.iconURLString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func playTrack(previewURL: String?) {
        guard let stringUrl = previewURL else { return }
        guard let url = URL(string: stringUrl) else { return }
        print(url)
        let playerItem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: playerItem )
        self.player.play()
    }
    
    //MARK: - DefaultSizeImage
    
    private func normalTrackImageSize() {
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
    }
    
    //MARK: - Time setup
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeImageView()
        }
    }
    
     //MARK: - "Show time-interval"
    
    private func observePlayerrCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.currentDurationLabel.text = currentDurationText
            self?.updateCurrentTimeSlider()
        }
    }
    
    //MARK: - Slider time
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationTimeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationTimeSeconds
        
        currentTimeSlider.value = Float(percentage)
    }
    
     //MARK: - Animations
    
    private func enlargeImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = .identity   //return normal state
        }, completion: nil)
    }
    
    private func reduceImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.normalTrackImageSize()
        }, completion: nil)
    }
    
    //MARK: - @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        
        self.removeFromSuperview()
    }
    
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {   //Slider rewind
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        
        if player.timeControlStatus == .paused {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player.play()
            enlargeImageView()
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player.pause()
            reduceImageView()
        }
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
        let nextTrack = delegate?.moveForwardForPreviousTrack()
        guard let track = nextTrack else { return }
        set(viewModel: track)
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
        let nextTrack = delegate?.moveBackForPreviousTrack()
        guard let track = nextTrack else { return }
        set(viewModel: track)
    }
}
