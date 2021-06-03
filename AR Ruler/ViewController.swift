//
//  ViewController.swift
//  AR Ruler
//
//  Created by admin on 6/3/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK - ARSCNViewDelegate methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: sceneView) {
            if let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .any) {
                let results = sceneView.session.raycast(query)
                
                if let result = results.first {
                    addDot(at: result)
                }
            }
        }
    }
    
    //MARK: - my functions
    
    func addDot(at result: ARRaycastResult) {
        let sphere = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(
            x: result.worldTransform.columns.3.x,
            y: result.worldTransform.columns.3.y,
            z: result.worldTransform.columns.3.z
        )
        
        sceneView.scene.rootNode.addChildNode(node)
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes.first!
        let end = dotNodes.last!
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print(abs(distance))
    }
}
