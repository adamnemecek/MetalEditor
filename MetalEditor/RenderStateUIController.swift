//
//  RenderStateUIController.swift
//  MetalEditor
//
//  Created by Litherum on 8/2/15.
//  Copyright © 2015 Litherum. All rights reserved.
//

import Cocoa

protocol RenderPipelineStateRemoveObserver: class {
    func removeRenderPipelineState(state: RenderPipelineState)
}

class RenderStateUIController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, RenderPipelineStateRemoveObserver {
    var managedObjectContext: NSManagedObjectContext!
    weak var modelObserver: ModelObserver!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var detailColumn: NSTableColumn!

    private func numberOfStates() -> Int {
        let fetchRequest = NSFetchRequest(entityName: "RenderPipelineState")
        var error: NSError?
        let result = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
        assert(error == nil)
        return result
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return numberOfStates()
    }

    private func getState(index: Int) -> RenderPipelineState? {
        let fetchRequest = NSFetchRequest(entityName: "RenderPipelineState")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        // <rdar://problem/22108925> managedObjectContext.executeFetchRequest() crashes if you add two objects.
        // FIXME: This is a hack.
        //fetchRequest.fetchLimit = 1
        //fetchRequest.fetchOffset = index
        
        do {
            let states = try managedObjectContext.executeFetchRequest(fetchRequest) as! [RenderPipelineState]
            if states.count < index {
                return nil
            }
            return states[index]
        } catch {
            return nil
        }
    }

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = tableColumn else {
            return nil
        }
        guard let state = getState(row) else {
            return nil
        }
        guard column == detailColumn else {
            fatalError()
        }
        // FIXME: Seems silly to keep these all around in memory at once
        while childViewControllers.count <= row {
            guard let controller = RenderStateViewController(nibName: "RenderStateViewController", bundle: nil, managedObjectContext: managedObjectContext, modelObserver: modelObserver, state: state, removeObserver: self) else {
                fatalError()
            }
            childViewControllers.append(controller)
        }
        return childViewControllers[row].view
    }

    @IBAction func add(sender: NSButton) {
        let stateCount = numberOfStates()

        let vertexAttribute = NSEntityDescription.insertNewObjectForEntityForName("VertexAttribute", inManagedObjectContext: managedObjectContext) as! VertexAttribute
        vertexAttribute.format = MTLVertexFormat.Float2.rawValue
        vertexAttribute.offset = 0
        vertexAttribute.bufferIndex = 0

        let vertexBufferLayout = NSEntityDescription.insertNewObjectForEntityForName("VertexBufferLayout", inManagedObjectContext: managedObjectContext) as! VertexBufferLayout
        vertexBufferLayout.stepFunction = MTLVertexStepFunction.PerVertex.rawValue
        vertexBufferLayout.stepRate = 1
        vertexBufferLayout.stride = 8

        let colorAttachment = NSEntityDescription.insertNewObjectForEntityForName("RenderPipelineColorAttachment", inManagedObjectContext: managedObjectContext) as! RenderPipelineColorAttachment
        colorAttachment.pixelFormat = nil

        let renderPipelineState = NSEntityDescription.insertNewObjectForEntityForName("RenderPipelineState", inManagedObjectContext: managedObjectContext) as! RenderPipelineState
        renderPipelineState.id = stateCount
        renderPipelineState.name = "Render State \(stateCount)"
        renderPipelineState.vertexFunction = "vertexIdentity"
        renderPipelineState.fragmentFunction = "fragmentRed"
        renderPipelineState.mutableOrderedSetValueForKey("colorAttachments").addObject(colorAttachment)
        renderPipelineState.mutableOrderedSetValueForKey("vertexAttributes").addObject(vertexAttribute)
        renderPipelineState.mutableOrderedSetValueForKey("vertexBufferLayouts").addObject(vertexBufferLayout)

        tableView.reloadData()
        modelObserver.modelDidChange()
    }

    func removeRenderPipelineState(state: RenderPipelineState) {
        for attachment in state.colorAttachments {
            managedObjectContext.deleteObject(attachment as! NSManagedObject)
        }
        for attribute in state.vertexAttributes {
            managedObjectContext.deleteObject(attribute as! NSManagedObject)
        }
        for layout in state.vertexBufferLayouts {
            managedObjectContext.deleteObject(layout as! NSManagedObject)
        }
        managedObjectContext.deleteObject(state)
        tableView.reloadData()
        modelObserver.modelDidChange()
    }
}