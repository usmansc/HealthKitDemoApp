//
//  Image.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import Foundation
import SwiftUI

extension Image{
    func presentImage(fromUrl: URL) -> Image{
        if let data = try? Data(contentsOf: fromUrl){
            if let image = UIImage(data: data){
                return Image(uiImage: image)
            }else{
                return Image(systemName: "info.circle")
            }
        }else{
            return Image(systemName: "info.circle")
        }
    }
}
