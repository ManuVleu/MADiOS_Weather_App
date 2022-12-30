
import UIKit
import Foundation

class CityCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CityCell"
    
    let nameLabel = UILabel()
    let weatherIconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(weatherIconImageView)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            weatherIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
        ])
    }
    
    func configure(with city: City) {
        nameLabel.text = city.name
    }
    
}
