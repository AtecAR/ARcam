import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    let modelName = "myModel.scn"  // 保存するモデルのファイル名
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ARSCNView の初期設定
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        
        // AR セッションの開始
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // オンラインからモデルをダウンロードし、保存後に読み込む
        if isOnline() {
            let modelURL = URL(string: "https://example.com/path/to/your/model.scn")!
            downloadAndSaveModel(from: modelURL) { success in
                if success {
                    self.loadModel()
                } else {
                    print("Failed to download or save the model.")
                }
            }
        } else {
            // オフラインの場合、ローカルストレージからモデルを読み込む
            loadModel()
        }
    }
    
    // オンライン/オフラインのチェック
    func isOnline() -> Bool {
        let reachability = try? Reachability()
        return reachability?.connection != .unavailable
    }
    
    // モデルのダウンロードと保存
    func downloadAndSaveModel(from url: URL, completion: @escaping (Bool) -> Void) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { localURL, response, error in
            if let localURL = localURL {
                do {
                    let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let savedURL = documentsURL.appendingPathComponent(self.modelName)
                    try FileManager.default.moveItem(at: localURL, to: savedURL)
                    completion(true)
                } catch {
                    print("Error saving model: \(error)")
                    completion(false)
                }
            } else {
                print("Download failed: \(error?.localizedDescription ?? "No error description")")
                completion(false)
            }
        }
        downloadTask.resume()
    }
    
    // ローカルストレージからモデルを読み込み
    func loadModel() {
        guard let modelNode = loadModelFromLocalStorage(named: modelName) else {
            print("Failed to load the model from local storage.")
            return
        }
        
        // モデルの位置を設定してシーンに追加
        modelNode.position = SCNVector3(0, 0, -0.5)  // カメラの前方に配置
        sceneView.scene.rootNode.addChildNode(modelNode)
    }
    
    // ローカルに保存されたモデルの読み込み
    func loadModelFromLocalStorage(named modelName: String) -> SCNNode? {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let modelURL = documentsURL.appendingPathComponent(modelName)
            let scene = try SCNScene(url: modelURL, options: nil)
            return scene.rootNode.childNodes.first
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()  // AR セッションの一時停止
    }
}
