import UIKit

class NewsCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let titleView = UIView()
    private let dateLabel = UILabel()
    private let logo = UIImageView()
    private let activityIndicator = ActivityIndicator()
    static let cellIdentifier = "newsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addingSubviewsAndSettingConstraints()
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addingSubviewsAndSettingConstraints() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleView)
        contentView.addSubview(logo)
        titleView.addSubview(titleLabel)
        titleView.addSubview(dateLabel)
        
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.equalTo(logo.snp.leading).offset(-15)
            make.top.equalToSuperview().offset(5)
            make.height.greaterThanOrEqualTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(dateLabel.snp.top)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        logo.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(5)
            make.height.width.equalTo(70)
        }
    }
    
    private func configureSubViews() {
        titleLabel.backgroundColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        dateLabel.backgroundColor = .white
        dateLabel.textColor = .black
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.alpha = 0.7
        
        logo.layer.cornerRadius = 5
        logo.clipsToBounds = true
        logo.contentMode = .scaleAspectFill
        
        activityIndicator.displayIndicator(view: logo)
        activityIndicator.startAnimating()
    }
    
    func bind(_ news: News) {
        let dateFormatter = DateFormatter()
        titleLabel.text = news.title
        dateLabel.text = dateFormatter.getNewDate(string: news.date)
        
        if let path = news.pathForImage {
            // Заменяем SDWebImage на URLSession
            if let url = URL(string: path) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error loading image: \(error)")
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.logo.image = image
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }.resume()
            }
        }
    }
    
    func newsIsOpen() {
        alpha = 0.2
    }
}
