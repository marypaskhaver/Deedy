//
//  UserDefaults+Color.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/19/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("Color error \(error)")
            return nil
        }
    }

    func set(_ value: UIColor?, forKey key: String) {
        guard let color = value else { return }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("Error color key data not saved \(error)")
        }
    }

}
