//
//  ViewController.swift
//  ARDicee
//
//  Created by Christopher Hicks on 1/28/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: - NEW CODE
        
     
        sceneView.delegate = self
        
        
        ///   **SHAPES**                                  -Units are in *Meters*                  -How *rounded* the corners are
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let sphere = SCNSphere(radius: 0.2)
        
        ///MATERIAL Container
        let material = SCNMaterial()
        
        ///**Base Material Design**                                   Texture Map from -  SolarSystemScope.com
        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        sphere.materials = [material]
        
        ///**Node 1** -- Position in 3-D Space
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        
        ///ASSIGN Object to Node Position
        node.geometry = cube
        
        ///ADD Node to View
        sceneView.scene.rootNode.addChildNode(node)
        
        ///--ADD  **Light**
        sceneView.autoenablesDefaultLighting = true
        
        
        
        
        //MARK: - NEW CODE ^
        
        
        
        
        
        
    
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
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


}
