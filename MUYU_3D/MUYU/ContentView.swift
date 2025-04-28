import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var scene: SCNScene? = nil  // 声明 scene 状态变量
    
    var body: some View {
        SceneKitView(scene: $scene)  // 将 scene 绑定到 SceneKitView
            .frame(width: 300, height: 300)
            .onAppear {
                loadModel()  // 加载模型
            }
    }
    
    func loadModel() {
        print("loadModel 方法被调用")
        
        // 获取模型文件的路径
        if let path = Bundle.main.path(forResource: "muyu", ofType: "usdz") {
            print("模型路径: \(path)")  // 打印路径，检查是否正确
            let url = URL(fileURLWithPath: path)
            
            // 尝试加载场景
            let sceneSource = SCNSceneSource(url: url, options: nil)
            if let loadedScene = try? sceneSource?.scene() {
                scene = loadedScene
                print("模型加载成功")
                addCameraAndLight(to: scene)
                
                // 调试模型节点的boundingBox
                if let rootNode = scene?.rootNode {
                    let boundingBox = rootNode.boundingBox
                    print("模型节点的boundingBox: min=\(boundingBox.min), max=\(boundingBox.max)")
                    
                    // 直接缩放模型的根节点
                    let scaleFactor: Float = 5.0  // 试着减小缩放因子，调整模型大小
                    rootNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)  // 直接设置根节点的缩放
                    print("缩放后的模型尺寸: \(rootNode.boundingBox)")
                    
                    // 调整模型位置，使其更居中
                    rootNode.position = SCNVector3(0, 0, 0)  // 将模型放置在中心位置
                }
            } else {
                print("加载模型失败")
            }
        } else {
            print("没有找到模型文件，请检查文件路径")
        }
    }
    
    // 在场景中添加相机和光照
    func addCameraAndLight(to scene: SCNScene?) {
        guard let scene = scene else { return }
        
        // 添加相机并固定视角
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 0)  // 设置相机位置
        cameraNode.look(at: SCNVector3Zero)  // 相机对准场景中心
        scene.rootNode.addChildNode(cameraNode)
        
        // 添加光源
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 5, z: 1)
        scene.rootNode.addChildNode(lightNode)

        // 添加环境光源
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.intensity = 500
        // 环境光的强度
        scene.rootNode.addChildNode(ambientLightNode)
    }
}

struct SceneKitView: UIViewRepresentable {
    @Binding var scene: SCNScene?  // 使用绑定来传递 scene
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true  // 禁用旋转和缩放
        scnView.backgroundColor = UIColor.white  // 设置背景为白色，确保视图可见
        if let scene = scene {
            scnView.scene = scene  // 设置场景
        }
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if let scene = scene {
            uiView.scene = scene  // 更新场景
        }
    }
}

#Preview {
    ContentView()
}

