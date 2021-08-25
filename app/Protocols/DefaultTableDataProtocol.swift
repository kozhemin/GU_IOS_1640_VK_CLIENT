//
//  DefaultTableDataProtocol.swift
//  app
//
//  Created by Егор Кожемин on 25.08.2021.
//
import UIKit

protocol DefaultTableDataProtocol {
    var name: String { get set }
    var image: UIImage? { get set }
    var description: String? { get set }
}
