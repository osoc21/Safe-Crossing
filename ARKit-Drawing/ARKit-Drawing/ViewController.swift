import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var distanceToImageLabel: UILabel!
    
    @IBOutlet weak var planeVisualizationSwitch: UISwitch!
    
    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    enum OperationMode {
        case plane, image
    }
    
    var operationMode: OperationMode = .plane {
        didSet {
            reloadConfiguration(removeAnchors: false)
        }
    }
    
    var selectedNode: SCNNode?
    var placedNodes = [SCNNode]()
    var nodesOnPlane = [SCNNode]()
    var showPlane = false {
        didSet {
            for node in nodesOnPlane {
                node.isHidden = !showPlane
            }
        }
    }
    var lastObjectPlacedPosition: CGPoint?
    let touchDistanceThreshold: CGFloat = 40.0
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let node = selectedNode, let touch = touches.first else {
            return
        }
        
        switch operationMode {
        case .plane:
            let touchPoint = touch.location(in: sceneView)
            addNode(node, toPlaneUsingParentNode: touchPoint)
        case .image:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
        guard operationMode == .plane, let node = selectedNode, let touch = touches.first, let lastTouchPoint = lastObjectPlacedPosition else {
            return
        }
        
        let newTouchPoint = touch.location(in: sceneView)
        
        // Euclidean distance
        let distance = sqrt(pow((newTouchPoint.x - lastTouchPoint.x), 2.0) + pow((newTouchPoint.y - lastTouchPoint.y), 2.0))
        
        if distance > touchDistanceThreshold {
            addNode(node, toPlaneUsingParentNode: newTouchPoint)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        lastObjectPlacedPosition = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        // Set default object
        selectedNode = SCNScene(named: "models.scnassets/osoc sphere/osoc sphere.scn")!.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func changePlaneVisualizationMode(_ sender: Any) {
        
        if self.planeVisualizationSwitch.isOn {
            togglePlaneVisualization()
        } else {
            togglePlaneVisualization()
        }
    }
    
    // Pick object
    
    @IBAction func changeObject(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedNode = SCNScene(named: "models.scnassets/osoc sphere/osoc sphere.scn")!.rootNode
        case 1:
            selectedNode = SCNScene(named: "models.scnassets/green sphere/green sphere.scn")!.rootNode
        case 2:
            selectedNode = SCNScene(named: "models.scnassets/sc note/sc note.scn")!.rootNode
        default:
            break
        }
    }
    
    @IBAction func reloadScene(_ sender: Any) {
        resetScene()
    }
    
    @IBAction func changeObjectMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            operationMode = .plane
        case 1:
            operationMode = .image
        default:
            break
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            nodeAdded(node, for: imageAnchor)
        } else if let planeAnchor = anchor as? ARPlaneAnchor {
            nodeAdded(node, for: planeAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes.first, let plane = planeNode.geometry as? SCNPlane else {
            return
        }
        if (operationMode == .image) {
            let anchorPosition = anchor.transform.columns.3
            if let cameraPosition = sceneView.session.currentFrame?.camera.transform.columns.3 {
                // Compute the distance
                let cameraToAnchor = cameraPosition - anchorPosition
                let dist = length(cameraToAnchor)
                // Update the label in the main thread
                DispatchQueue.main.async {
                    self.distanceToImageLabel.text = "Distance to image: " + String(format: "%.2f", dist) + " m"
                }
            }
        } else {
            // Update the label in the main thread
            DispatchQueue.main.async {
                self.distanceToImageLabel.text = "Plane mode"
            }
        }
        
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        node.geometry = geometry
        
        node.eulerAngles.x = -.pi / 2
        node.opacity = 0.25
        
        return node
    }
}

extension ViewController {
    
    func objectSelected(node: SCNNode) {
        dismiss(animated: true, completion: nil)
        selectedNode = node
    }
    
    func addNodeToSceneRoot(_ node: SCNNode) {
        let cloneNode = node.clone()
        sceneView.scene.rootNode.addChildNode(cloneNode)
        placedNodes.append(cloneNode)
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        let plane = createFloor(planeAnchor: anchor)
        plane.isHidden = !showPlane
        node.addChildNode(plane)
        nodesOnPlane.append(plane)
        
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARImageAnchor) {
        if let selectedNode = selectedNode {
            addNode(selectedNode, toImageUsingParentNode: node)
        }
    }
    
    func addNode(_ node: SCNNode, toImageUsingParentNode parentNode: SCNNode) {
        let cloneNode = node.clone()
        parentNode.addChildNode(cloneNode)
        placedNodes.append(cloneNode)
    }
    
    func addNode(_ node: SCNNode, toPlaneUsingParentNode point: CGPoint) {
        let results = sceneView.hitTest(point, types: [.existingPlaneUsingExtent])
        
        if let match = results.first {
            let t = match.worldTransform
            node.position = SCNVector3(x: t.columns.3.x, y: t.columns.3.y, z: t.columns.3.z)
            
            addNodeToSceneRoot(node)
            lastObjectPlacedPosition = point
        }
    }
    
    func togglePlaneVisualization() {
        dismiss(animated: true, completion: nil)
        showPlane = !showPlane
    }
    
    func resetScene() {
        dismiss(animated: true, completion: nil)
        reloadConfiguration()
    }
    
    func reloadConfiguration(removeAnchors: Bool = true) {
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.detectionImages = (operationMode == .image) ? ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) : nil
        let options: ARSession.RunOptions
        
        if removeAnchors {
            options = [.removeExistingAnchors]
            for node in nodesOnPlane {
                node.removeFromParentNode()
            }
            nodesOnPlane.removeAll()
            for node in placedNodes {
                node.removeFromParentNode()
            }
            placedNodes.removeAll()
        } else {
            options = []
        }
        sceneView.session.run(configuration, options: options)
    }
}
