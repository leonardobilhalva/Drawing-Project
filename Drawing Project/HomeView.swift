//
//  HomeView.swift
//  Drawing Project
//
//  Created by Leonardo on 09/11/23.
//

import SwiftUI
import SceneKit

struct HomeView: View {
    var body: some View {
        Text("Select the shirt to draw").font(.largeTitle)

        
        ScrollView(.horizontal, showsIndicators: true) { // showsIndicators controla a visibilidade da barra de rolagem
                  HStack(spacing: 20) {
                      SceneView(scene: SCNScene (named: models[0].modelName), options:
                                  [.autoenablesDefaultLighting,.allowsCameraControl])
                      .frame (width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                      Spacer (minLength: 0)
                      
                      SceneView(scene: SCNScene (named: models[1].modelName), options:
                                  [.autoenablesDefaultLighting,.allowsCameraControl])
                      .frame (width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                      Spacer (minLength: 0)
                      
                      SceneView(scene: SCNScene (named: models[2].modelName), options:
                                  [.autoenablesDefaultLighting,.allowsCameraControl])
                      .frame (width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                      Spacer (minLength: 0)
                      }
                  }
                  .padding()
              }
      
}
