//
//  CoverFlowLayout.swift
//  Cinelogues
//
//  Created by AJ on 17/07/25.
//


import UIKit

class CoverFlowLayout: UICollectionViewFlowLayout {
    let activeDistance: CGFloat = 100
    let zoomFactor: CGFloat = 0.1
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 20
        
        if let collectionView = collectionView {
            self.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        }
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let collectionView = collectionView else { return nil }
        
        for attributes in superAttributes {
            attributes.transform3D = CATransform3DIdentity
            attributes.zIndex = 0
        }
        
        return superAttributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // Snapping to center the cells on scroll end
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }
        
        let collectionViewSize = collectionView.bounds.size
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2
        
        let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        layoutAttributes?.forEach { attributes in
            // Skip headers and footers
            if attributes.representedElementCategory != .cell {
                return
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                return
            }
            
            if abs(attributes.center.x - proposedContentOffsetCenterX) < abs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        guard let finalAttributes = candidateAttributes else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset,
                                             withScrollingVelocity: velocity)
        }
        
        let targetContentOffsetX = finalAttributes.center.x - collectionViewSize.width / 2
        return CGPoint(x: targetContentOffsetX, y: proposedContentOffset.y)
    }
}
