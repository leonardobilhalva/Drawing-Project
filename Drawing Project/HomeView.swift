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
        NavigationView {
            VStack {
                Text("Select the shirt to draw")
                    .font(.largeTitle)

                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(0..<models.count, id: \.self) { index in
                            NavigationLink(destination: ModelDrawingView(model: models[index])) {
                                SceneView(
                                    scene: SCNScene(named: models[index].modelName),
                                    options: [.autoenablesDefaultLighting, .allowsCameraControl]
                                )
                                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                                .background(Color.gray.opacity(0.3)) // Para melhorar a interação visual
                                .cornerRadius(10) // Para aparência arredondada
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
