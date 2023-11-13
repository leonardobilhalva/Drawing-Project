
import SwiftUI
import UIKit
import SceneKit

struct DrawingView: View {

    @State private var drawnImage: UIImage?
    
    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    
    let engine = DrawingEngine()
    @State private var showConfirmation: Bool = false
    
    var scene: SCNScene
    var nodeName: String // Adicione isso
    var modelName: String
    
    var body: some View {
        
        VStack {
    
            
            HStack {
                ColorPicker("line color", selection: $selectedColor)
                    .labelsHidden()
                Slider(value: $selectedLineWidth, in: 1...20) {
                    Text("linewidth")
                }.frame(maxWidth: 100)
                Text(String(format: "%.0f", selectedLineWidth))
                
                Spacer()
                
                Button {
                    let last = lines.removeLast()
                    deletedLines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }.disabled(lines.count == 0)
                
                Button {
                    let last = deletedLines.removeLast()
                    
                    lines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .imageScale(.large)
                }.disabled(deletedLines.count == 0)

                Button(action: {
                   showConfirmation = true
                }) {
                    Text("Delete")
                }.foregroundColor(.red)
                    .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
                        
                        Button("Delete", role: .destructive) {
                            lines = [Line]()
                            deletedLines = [Line]()
                        }
                    }
                
            }.padding()
        Canvas { context, size in

            for line in lines {
                let path = engine.createPath(for: line.points)
                context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                
    
            }
            
            
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
            let newPoint = value.location
            if value.translation.width + value.translation.height == 0 {
                //TODO: use selected color and linewidth
                lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
            } else {
                let index = lines.count - 1
                lines[index].points.append(newPoint)
            }
            
        }).onEnded({ value in
            if let last = lines.last?.points, last.isEmpty {
                lines.removeLast()
            }
            
            // Calcula o rect para desenhar a imagem baseado nas linhas existentes
            let drawingRect = calculateDrawingRect(forLines: lines, lineWidth: selectedLineWidth)
            // Gera a imagem a partir das linhas desenhadas
            drawnImage = drawLinesAsImage(lines: lines, in: drawingRect)

            do {
                try updateTextureFor3DObject(with: drawnImage)
            } catch TextureUpdateError.imageNotFound {
                print("Erro: Image not found.")
            } catch TextureUpdateError.objectNodeNotFound {
                print("Erro: object node not fund.")
            } catch {
                print("Unknown Error: \(error).")
            }
            
//            applyTextureToModel(modelName: modelName, scene: scene)
           
        })

        
        )
            
        }
    }
    
    func updateTextureFor3DObject(with image: UIImage?) throws {
        guard let image = image else {
            throw TextureUpdateError.imageNotFound
        }
        
        // Attempt to find an existing node with the given name
        let objectNode = scene.rootNode.childNode(withName: nodeName, recursively: true)
        
        // If the node does not exist, create a new one
        let nodeToUpdate: SCNNode
        if let existingNode = objectNode {
            nodeToUpdate = existingNode
        } else {
            // Create a new geometry for the texture, e.g., a plane
            let geometry =  SCNPlane(width: 50.0, height: 50.0)// Adjust size as needed
            nodeToUpdate = SCNNode(geometry: geometry)
            nodeToUpdate.name = nodeName
            scene.rootNode.addChildNode(nodeToUpdate)
        }

        // Create and set the material with the new texture
        let material = SCNMaterial()
        material.diffuse.contents = image
        
        if nodeToUpdate.geometry != nil {
            nodeToUpdate.geometry?.firstMaterial = material
        } else {
            print("unable to get geometry")
        }
    }
    
//    
//    func applyTextureToModel(modelName: String, scene: SCNScene) {
//        guard let node = scene.rootNode.childNodes.first(where: { $0.geometry != nil }) else {
//            print("Erro: Nó do objeto não encontrado.")
//            return
//        }
//        print("leo)")
//
//        let material = SCNMaterial()
//        material.diffuse.contents = drawnImage // Nome do arquivo de imagem
//        node.geometry?.firstMaterial = material
//    }

}


func drawLinesAsImage(lines: [Line], in rect: CGRect) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(bounds: rect)
    return renderer.image { context in
        for line in lines {
            guard let firstPoint = line.points.first else { continue }
            
            let path = UIBezierPath()
            path.move(to: firstPoint)
            
            for point in line.points.dropFirst() {
                path.addLine(to: point)
            }
            
            path.lineWidth = line.lineWidth
            // Converte CustomColor para UIColor e depois define como cor de stroke
            UIColor(red: 0,
                    green: 0,
                    blue: 0,
                    alpha: 1).setStroke()
            
            path.stroke()
        }
    }
}

func calculateDrawingRect(forLines lines: [Line], lineWidth: CGFloat) -> CGRect {
    guard !lines.isEmpty else {
        return .zero // Retornando um CGRect zero se não houver linhas
    }
    
    var minX: CGFloat = CGFloat.greatestFiniteMagnitude
    var maxX: CGFloat = -CGFloat.greatestFiniteMagnitude
    var minY: CGFloat = CGFloat.greatestFiniteMagnitude
    var maxY: CGFloat = -CGFloat.greatestFiniteMagnitude

    for line in lines {
        for point in line.points {
            minX = min(minX, point.x)
            maxX = max(maxX, point.x)
            minY = min(minY, point.y)
            maxY = max(maxY, point.y)
        }
    }

    // Considerar a espessura da linha na área de desenho
    let padding = lineWidth / 2.0
    return CGRect(
        x: minX - padding,
        y: minY - padding,
        width: maxX - minX + (padding * 2),
        height: maxY - minY + (padding * 2)
    )
}


