//
//  TShirtView.swift
//  Drawing Project
//
//  Created by Leonardo on 10/11/23.
//

import SwiftUI
import SceneKit


struct ModelDrawingView: View {
    var model: Model // Suponha que 'Model' é sua estrutura de dados com as informações da camiseta.

    var body: some View {
        // Você pode personalizar esta view com as informações específicas da camiseta
        VStack{
            
            Text("Detalhes para \(model.modelName)")
            SceneView(scene: SCNScene (named: models[0].modelName), options:
                        [.autoenablesDefaultLighting,.allowsCameraControl])
            .frame (width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
            .onAppear{
                applyTextureToModel(modelName: models[0].modelName)
            }
            Spacer (minLength: 0)
            
            
            DrawingView()
        }
    }
}



func applyTextureToModel(modelName: String) {
    // Carregar a cena pelo nome do modelo
    guard let scene = SCNScene(named: modelName) else { return }
    // Supondo que você quer aplicar a textura ao primeiro nó com geometria
    guard let node = scene.rootNode.childNodes.first(where: { $0.geometry != nil }) else { return }

    // Criar o material com a textura
    let material = SCNMaterial()
    // Substitua 'nomeDaSuaImagem' pelo nome da imagem que você quer usar como textura
    material.diffuse.contents = UIImage(named: "nomeDaSuaImagem")
    // Aplicar o material ao nó
    node.geometry?.materials = [material]
}

