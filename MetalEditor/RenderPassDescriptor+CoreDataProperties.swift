//
//  RenderPassDescriptor+CoreDataProperties.swift
//  MetalEditor
//
//  Created by Litherum on 8/30/15.
//  Copyright © 2015 Litherum. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RenderPassDescriptor {

    @NSManaged var renderTargetArrayLength: NSNumber
    @NSManaged var visibilityResultBuffer: Texture?
    @NSManaged var renderPass: RenderPass
    @NSManaged var colorAttachments: NSOrderedSet
    @NSManaged var depthAttachment: DepthAttachment
    @NSManaged var stencilAttachment: StencilAttachment

}
