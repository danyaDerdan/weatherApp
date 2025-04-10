import UIKit

final class WeatherCell: UITableViewCell {
    private var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func configure(with weather: ViewData.Weather) {
        setupViews()
        label.text = weather.city
        iconView.image = UIImage(data: weather.icon)
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [label, iconView])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
}
