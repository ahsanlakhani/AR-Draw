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
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.showsStatistics = true
        self.sceneView.delegate = self

    }
    
    //this is the ARSCNViewDelegate function that will help us to draw in app
    //this delegate function gets called everytime a view is about to render a scene so it will be called constatntly
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("rendering")
    }

}

