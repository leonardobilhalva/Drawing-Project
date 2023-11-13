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
                
                
                Button(action: {
                    
                    // Attempt to find an existing node with the given name
                    let objectNode = scene.rootNode.childNode(withName: "TShirtNode", recursively: true)
                    
                    // If the node does not exist, create a new one
                    let nodeToUpdate: SCNNode
                    if let existingNode = objectNode {
                        nodeToUpdate = existingNode
                    } else {
                        // Create a new geometry for the texture, e.g., a plane
                        let geometry = SCNPlane(width: 100.0, height: 100.0) // Adjust size as needed
                        nodeToUpdate = SCNNode(geometry: geometry)
                        nodeToUpdate.name = "TShirtNode"
                        scene.rootNode.addChildNode(nodeToUpdate)
                    }

                    // Create and set the material with the new texture
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor.red
                    
                    if nodeToUpdate.geometry != nil {
                        nodeToUpdate.geometry?.firstMaterial = material
                    } else {
                        print("unable to get geometry")
                    }
                    
                    
                    
                }, label: {
                    Text("sadiuhasiudsa")
                })
                
                
                
                SceneView(scene: scene, options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                    .onAppear {
                        self.applyTextureToModel(modelName: model.modelName, scene: scene)
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

    func applyTextureToModel(modelName: String, scene: SCNScene) {
        guard let node = scene.rootNode.childNodes.first(where: { $0.geometry != nil }) else {
            print("Erro: Nó do objeto não encontrado.")
            return
        }

        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "nomeDaSuaImagem") // Nome do arquivo de imagem
        node.geometry?.firstMaterial = material
    }
}
