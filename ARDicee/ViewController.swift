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
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: - NEW CODE
        
        // SHOWS Where it Finding Points for Nodes DEBUG OPTIONS
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        sceneView.delegate = self
        
        
        //
        //        ///   **SHAPES**            -Units are in *Meters*      -How *rounded* the corners are
        //        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        //        let sphere = SCNSphere(radius: 0.2)
        //
        //        ///MATERIAL Container
        //        let material = SCNMaterial()
        //
        //        ///**Base Material Design**                Texture Map from -  SolarSystemScope.com
        //        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        //        sphere.materials = [material]
        //
        //        ///**Node 1** -- Position in 3-D Space
        //        let node = SCNNode()
        //        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        //
        //        ///ASSIGN Object to Node Position
        //        node.geometry = cube
        //
        //        ///ADD Node to View
        //        sceneView.scene.rootNode.addChildNode(node)
        
        
        
        
        
        
        ///--ADD  **Light**
        sceneView.autoenablesDefaultLighting = true
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        ///SETS UP HORIZONTAL PLANE DETECTION
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    
    /// -- Detects Touches from USER
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .any) {
                let results = sceneView.session.raycast(query)
                
                if let hitResult = results.first {
                    
                    ///Create a new scene
                    let diceScene = SCNScene(named: "art.scnassets/diceCollada_copy.scn")!
                    if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                        
                       
                        diceNode.position = SCNVector3(
                            hitResult.worldTransform.columns.3.x,
                            hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                            hitResult.worldTransform.columns.3.z
                        )
                        
                        diceArray.append(diceNode)
                        
                        sceneView.scene.rootNode.addChildNode(diceNode)
                        
                      
                        roll(dice: diceNode)
                    
                    }
                }
                
            }
            
        }
    }
    

    
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
            roll(dice: dice)
                
            }
        }
    }
    
    func roll(dice: SCNNode) {
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(
            SCNAction.rotateBy(
                x: CGFloat(randomX * 5),
                y: 0,
                z: CGFloat(randomZ * 5),
                duration: 0.5
            )
        )
        
    }
    
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        
        rollAll()
        
    }
    ///SHAKE PHONE will Cause Function 
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
        
    }
    
    

    ///SETS UP HORIZONTAL PLANE
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            ///---Tile on the Ground
            let planeAnchor = anchor as! ARPlaneAnchor
            ///--Render to SceneKit for AR VIEW
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            ///Rotate Plane 90 degrees
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            
            node.addChildNode(planeNode)
            
            
            print("plane detected")
        } else {
            return
        }
    }

}
