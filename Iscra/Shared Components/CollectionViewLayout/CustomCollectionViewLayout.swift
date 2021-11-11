//
//  CustomCollectionViewLayout.swift
//  Iscra
//
//  Created by mac on 21/10/21.
//

import Foundation
import UIKit
protocol CustomCollectionViewLayoutDelegate : class {
    func collectionView(_ collectionView : UICollectionView, getSizeAtIndexPath indexPath : IndexPath)->CGSize
}

class CustomCollectionViewLayout : UICollectionViewLayout{
    
    // CustomCollectionViewLayoutDelegate
    weak var delegate : CustomCollectionViewLayoutDelegate?
    
    // 1. Cache
    /// This is to store the calculated UICollectionViewLayoutAttributes
    private var cache : [UICollectionViewLayoutAttributes] = []
    
    // 2. contentWidth
    private var contentWidth : CGFloat{
        guard let collectionView = collectionView else{
            return 0
        }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    // 3. this will be calculated in Prepare()
    private var contentHeight : CGFloat = 0
    
    
    // 4. contentSize of collectionView
    // we just return the size that comprises of contentHeight and contentWidth
    // this property will be called after Prepare()
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
         // MARK: - Prepare
    // This is the meat of this class
    override func prepare() {
        // We don't need to call super
        
        guard let collectionView = collectionView else{
            return
        }
        
        //1. Clear Cache
        cache.removeAll()
        
        // 2. Set the origin
        var yOrigin : CGFloat = 0
        var xOrigin : CGFloat = 0
        var newXPos : CGFloat = 0
        let overlape : CGFloat = 15
        
        // 3. Here, we assume that we have only one section
        // you can handle multiple section us
        // for section in 0..<collectionView.numberOfSections{}
        
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4. if the delegate is empty, we have a default size of (40, 40)
            let itemSize = delegate?.collectionView(collectionView, getSizeAtIndexPath: indexPath) ?? CGSize(width: 35, height: 35)
            
          
            xOrigin = newXPos
            yOrigin = 0
            // 6. After creating a new frame, we update the new xOrigin
            newXPos = newXPos + (itemSize.width - overlape)
            let frame = CGRect(x: xOrigin, y: yOrigin, width: itemSize.width, height: itemSize.height)

            // 7. We create the UICollectionViewLayoutAttributes
            // and set its frame
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            attributes.frame = frame
            
            // 8. store the attributes in cache
            cache.append(attributes)
            
            // 9. update the contentHeight
            contentHeight = max(contentHeight, yOrigin + itemSize.height)
        }
        
    }
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
      var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
      // Loop through the cache and look for items in the rect
      for attributes in cache {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
      return visibleLayoutAttributes
    }
}
