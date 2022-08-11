//
//  CountryTableViewCell.swift
//  Task_21_elizbar_kheladze
//
//  Created by alta on 8/11/22.
//

import UIKit


class CountryTableViewCellViewModel {
    let title: String
    let imageurl: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        imageurl: URL?
    ){
        self.title = title
        self.imageurl = imageurl
        
    }
}

class CountryTableViewCell: UITableViewCell {

static let identifier = "CountryTableViewCell"
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let countryimageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(countryimageView)
        contentView.addSubview(countryNameLabel)
        
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        countryNameLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 120, height: contentView.frame.size.height/2)
        countryimageView.frame = CGRect(x: contentView.frame.size.width-200, y: 5, width:190, height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countryNameLabel.text = nil
        countryimageView.image = nil
    }
    
    func configure(with viewModel: CountryTableViewCellViewModel){
        countryNameLabel.text = viewModel.title
        if let data = viewModel.imageData {
            countryimageView.image = UIImage(data: data)
        }else if let url = viewModel.imageurl {
            URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.countryimageView.image = UIImage(data: data)
                }
            }.resume()
        }
    
    }
}
