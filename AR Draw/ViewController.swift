//
//  ViewController.swift
//  AR Draw
//
//  Created by admin on 1/6/18.
//  Copyright © 2018 Ahsan. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var draw: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        //        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        //        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self
        
    }
    
    //this is the ARSCNViewDelegate function that will help us to draw in app
    //this delegate function gets called everytime a view is about to render a scene so it will be called constatntly
    //this function gets called 60 times a second because app runs at 60fps
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("rendering")
        //we need pointOfView which means current position (location and orientation) of the camera everytime the delegate gets called so that we can update our drawing
        guard let pointOfView = sceneView.pointOfView else {return}
        //location and orientation is encoded in a transform matrix
        let transform = pointOfView.transform
        //orientation means where your phone is facing and lcoation is the phone's location relative to scene view
        //orientation is always in the 3rd column and location in 4th column of matrix 31 means 3rd column 1st row
        //x in 1st row and so on
        //orientation are location values are reversed so we will put a minus before it to make it positive
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        print(orientation.x,orientation.y,orientation.z)
        
        //this holds current position of camera in one variable
        let cameraCurrentPosition =  orientation + location
        
        //now start drawing
        //everything in renderer function happens in the background thread so here we want to perform this in main thread
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphere = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphere.position = cameraCurrentPosition
                sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphere)
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = cameraCurrentPosition
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer"{
                        node.removeFromParentNode()
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
            
            
        }
        
    }
    
}
//we cannot perform addition between two vectors so we have to make this function
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

