//
//  Connections.swift
//  MalamkarAbhijeet_The_Game
//
//  Created by Abhijeet Malamkar on 7/12/17.
//  Copyright © 2017 abhijeetmalamkar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class Connection: NSObject,MCBrowserViewControllerDelegate, MCSessionDelegate {
    // four main building blocks of an MC application
    //our device id as viewed by another browsing devices
    var peerId:MCPeerID!
    //the "connection" between devices
    var session:MCSession!
    //prebuilt browser view controller
    var browser:MCBrowserViewController!
    //helps us easily advertise to nearby MCBrowser
    var advertiser:MCAdvertiserAssistant!
    
    var viewController:UIViewController?
    
    var delegate:getPosition?
    
    let serviceID = "mdf2-chat"
    
    override init() {
        super.init()
        
        peerId = MCPeerID(displayName: UIDevice.current.name)
        
        // setup the session
        session = MCSession(peer: peerId)
        session.delegate = self
        
        //using the previous data to setup advertiser and start advertising
        advertiser = MCAdvertiserAssistant(serviceType: serviceID, discoveryInfo: nil, session: session)
        advertiser.start()
        
        //self.progressViewWidthConstraint = self.progressViewWidthConstraint.setMultiplier(multiplier: 1)
        
        //our browser will look for advertisers that share same serviceID
        browser = MCBrowserViewController(serviceType: serviceID, session: session)
        browser.delegate = self
    }
    
    public func numDevices() -> Int {
       return session.connectedPeers.count
    }
    
    func connect(viewController:UIViewController){
        self.viewController = viewController
        viewController.present(browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browser.dismiss(animated: true, completion: nil)
    }
    
    // Remote peer changed state.
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState){
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func send(_message: String){
        if let message:Data = _message.data(using: .utf8) {
            do {
                try session.send(message, toPeers: session.connectedPeers, with: .unreliable)
            } catch {
                print("Not working")
            }
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        DispatchQueue.main.async {
            if let selectedString:String = String(data: data, encoding: .utf8) {
                self.delegate?.getPosition(message: selectedString)
            }
        }
    }
    
    // Received a byte stream from remote peer.
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        
    }
    
    
    // Start receiving a resource from remote peer.
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress){
        
    }
    
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

public protocol getPosition {
    func getPosition(message:String)
}



