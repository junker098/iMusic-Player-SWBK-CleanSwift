//
//  TrackCell.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 05.10.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var artistName: String { get }
    var iconURLString: String? { get }
    var trackName: String { get }
    var collectionName: String { get }
    var previewURL: String? { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseIdentifire = "cell"
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    @IBOutlet weak var trackImage: UIImageView!
    
    override func awakeFromNib() {
        super .awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImage.image = nil
    }
    
    func setupCell(trackCellViewModel: TrackCellViewModel) {
        trackNameLabel.text = trackCellViewModel.trackName
        artistNameLabel.text = trackCellViewModel.artistName
        collectionNameLabel.text = trackCellViewModel.collectionName
        
        guard let url = URL(string: trackCellViewModel.iconURLString ?? "") else { return }
        trackImage.sd_setImage(with: url, completed: nil)
        
    }
    
}
