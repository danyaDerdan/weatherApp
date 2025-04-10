import UIKit

private struct Constants {
    static let inset: CGFloat = 20
}

final class WeatherCell: UITableViewCell {
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    private var conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func configure(with weather: ViewData.Weather) {
        setupViews()
        cityLabel.text = weather.city
        iconView.image = UIImage(data: weather.icon)
        conditionLabel.text = weather.condition
        tempLabel.text = String(weather.temp) + "°"
        timeLabel.text = weather.time
    }
    
    private func setupViews() {
        let leftStack = UIStackView(arrangedSubviews: [cityLabel, timeLabel, conditionLabel])
        leftStack.axis = .vertical
        
        let rightStack = UIStackView(arrangedSubviews: [iconView, tempLabel])
        rightStack.axis = .horizontal
        rightStack.spacing = 0
        
        let stackView = UIStackView(arrangedSubviews: [leftStack, rightStack])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.inset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.inset)
            ])
    }
}
