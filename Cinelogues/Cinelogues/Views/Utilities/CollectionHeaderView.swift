//
//  CollectionHeaderView.swift
//  Cinelogues
//
//  Created by AJ on 18/07/25.
//

import Foundation
import UIKit
class CollectionHeaderView: UICollectionReusableView {
    static let identifier = "CollectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds.insetBy(dx: 16, dy: 0)
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
