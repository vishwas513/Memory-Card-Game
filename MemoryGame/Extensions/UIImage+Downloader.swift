//
//  UIImage+Downloader.swift
//  MemoryGame
//
//  Created by Vishwas Mukund on 17/04/16.
//  
//
//  Based on a method from:
//  https://github.com/PerrchicK/swift-app/blob/master/SomeApp/SomeApp/Classes/Utilities/PerrFuncs.swift
//

import UIKit.UIImage

extension UIImage {
    static func downloadImage(_ url: URL, completion: ((UIImage?) -> Void)?) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
            var image: UIImage? = nil
            
            defer {
                DispatchQueue.main.async {
                    completion?(image)
                }
            }
            
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
        }
    }
}
