//
//  Model.swift
//  Drawing Project
//
//  Created by Leonardo on 09/11/23.
//

import Foundation


struct Model : Hashable {
    var id : Int
    var name : String
    var modelName : String
}

var models = [
    Model(id: 0, name: "Shirt 01", modelName: "t shirt.usdz"),
    Model(id: 1, name: "Shirt 02", modelName: "CC0_-_Stone.usdz"),
    Model(id: 2, name: "Shirt 03", modelName: "t shirt.usdz"),
]
