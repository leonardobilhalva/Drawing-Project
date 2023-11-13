//
//  TShirtView.swift
//  Drawing Project
//
//  Created by Leonardo on 10/11/23.
//
import SwiftUI
import SceneKit

struct ModelDrawingView: View {
    var model: Model
    @State private var scene: SCNScene?

    var body: some View {
        VStack {
            Text("Detalhes para \(model.modelName)")
            
            if let scene = scene {
                
                SceneView(scene: scene, options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                    .onAppear {
                    }
                
                
                
                DrawingView(scene: scene, nodeName: "TShirtNode", modelName: model.modelName)
            } else {
                Text("Carregando modelo...")
                    .onAppear {
                        self.scene = SCNScene(named: model.modelName)
                    }
            }

            Spacer()
            
        }
    }

//    func applyTextureToModel(modelName: String, scene: SCNScene) {
//        guard let node = scene.rootNode.childNodes.first(where: { $0.geometry != nil }) else {
//            print("Erro: Nó do objeto não encontrado.")
//            return
//        }
//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "nomeDaSuaImagem") // Nome do arquivo de imagem
//        node.geometry?.firstMaterial = material
//    } //@TODO: apagar??
}
