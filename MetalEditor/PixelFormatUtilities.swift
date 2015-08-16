//
//  PixelFormatUtilities.swift
//  MetalEditor
//
//  Created by Litherum on 8/16/15.
//  Copyright © 2015 Litherum. All rights reserved.
//

import Cocoa

let pixelFormatMenuOrder: [MTLPixelFormat] = [.Invalid, .A8Unorm, .R8Unorm, .R8Snorm, .R8Uint, .R8Sint, .R16Unorm, .R16Snorm, .R16Uint, .R16Sint, .R16Float, .RG8Unorm, .RG8Snorm, .RG8Uint, .RG8Sint, .R32Uint, .R32Sint, .R32Float, .RG16Unorm, .RG16Snorm, .RG16Uint, .RG16Sint, .RG16Float, .RGBA8Unorm, .RGBA8Unorm_sRGB, .RGBA8Snorm, .RGBA8Uint, .RGBA8Sint, .BGRA8Unorm, .BGRA8Unorm_sRGB, .RGB10A2Unorm, .RGB10A2Uint, .RG11B10Float, .RGB9E5Float, .RG32Uint, .RG32Sint, .RG32Float, .RGBA16Unorm, .RGBA16Snorm, .RGBA16Uint, .RGBA16Sint, .RGBA16Float, .RGBA32Uint, .RGBA32Sint, .RGBA32Float, .BC1_RGBA, .BC1_RGBA_sRGB, .BC2_RGBA, .BC2_RGBA_sRGB, .BC3_RGBA, .BC3_RGBA_sRGB, .BC4_RUnorm, .BC4_RSnorm, .BC5_RGUnorm, .BC5_RGSnorm, .BC6H_RGBFloat, .BC6H_RGBUfloat, .BC7_RGBAUnorm, .BC7_RGBAUnorm_sRGB, .GBGR422, .BGRG422, .Depth32Float, .Stencil8, .Depth24Unorm_Stencil8, .Depth32Float_Stencil8]

let pixelFormatNameMap: [MTLPixelFormat : String] = [.Invalid: "Invalid", .A8Unorm: "A8Unorm", .R8Unorm: "R8Unorm", .R8Snorm: "R8Snorm", .R8Uint: "R8Uint", .R8Sint: "R8Sint", .R16Unorm: "R16Unorm", .R16Snorm: "R16Snorm", .R16Uint: "R16Uint", .R16Sint: "R16Sint", .R16Float: "R16Float", .RG8Unorm: "RG8Unorm", .RG8Snorm: "RG8Snorm", .RG8Uint: "RG8Uint", .RG8Sint: "RG8Sint", .R32Uint: "R32Uint", .R32Sint: "R32Sint", .R32Float: "R32Float", .RG16Unorm: "RG16Unorm", .RG16Snorm: "RG16Snorm", .RG16Uint: "RG16Uint", .RG16Sint: "RG16Sint", .RG16Float: "RG16Float", .RGBA8Unorm: "RGBA8Unorm", .RGBA8Unorm_sRGB: "RGBA8Unorm_sRGB", .RGBA8Snorm: "RGBA8Snorm", .RGBA8Uint: "RGBA8Uint", .RGBA8Sint: "RGBA8Sint", .BGRA8Unorm: "BGRA8Unorm", .BGRA8Unorm_sRGB: "BGRA8Unorm_sRGB", .RGB10A2Unorm: "RGB10A2Unorm", .RGB10A2Uint: "RGB10A2Uint", .RG11B10Float: "RG11B10Float", .RGB9E5Float: "RGB9E5Float", .RG32Uint: "RG32Uint", .RG32Sint: "RG32Sint", .RG32Float: "RG32Float", .RGBA16Unorm: "RGBA16Unorm", .RGBA16Snorm: "RGBA16Snorm", .RGBA16Uint: "RGBA16Uint", .RGBA16Sint: "RGBA16Sint", .RGBA16Float: "RGBA16Float", .RGBA32Uint: "RGBA32Uint", .RGBA32Sint: "RGBA32Sint", .RGBA32Float: "RGBA32Float", .BC1_RGBA: "BC1_RGBA", .BC1_RGBA_sRGB: "BC1_RGBA_sRGB", .BC2_RGBA: "BC2_RGBA", .BC2_RGBA_sRGB: "BC2_RGBA_sRGB", .BC3_RGBA: "BC3_RGBA", .BC3_RGBA_sRGB: "BC3_RGBA_sRGB", .BC4_RUnorm: "BC4_RUnorm", .BC4_RSnorm: "BC4_RSnorm", .BC5_RGUnorm: "BC5_RGUnorm", .BC5_RGSnorm: "BC5_RGSnorm", .BC6H_RGBFloat: "BC6H_RGBFloat", .BC6H_RGBUfloat: "BC6H_RGBUfloat", .BC7_RGBAUnorm: "BC7_RGBAUnorm", .BC7_RGBAUnorm_sRGB: "BC7_RGBAUnorm_sRGB", .GBGR422: "GBGR422", .BGRG422: "BGRG422", .Depth32Float: "Depth32Float", .Stencil8: "Stencil8", .Depth24Unorm_Stencil8: "Depth24Unorm_Stencil8", .Depth32Float_Stencil8: "Depth32Float_Stencil8"]

func pixelFormatMenu(includeNone: Bool) -> NSMenu {
    let result = NSMenu()
    if (includeNone) {
        result.addItem(NSMenuItem(title: "None", action: nil, keyEquivalent: ""))
    }
    for i in MTLPixelFormat.Invalid.rawValue ... MTLPixelFormat.Depth32Float_Stencil8.rawValue {
        guard let format = MTLPixelFormat(rawValue: i) else {
            continue
        }
        guard let name = pixelFormatNameMap[format] else {
            continue
        }
        result.addItem(NSMenuItem(title: name, action: nil, keyEquivalent: ""))
    }
    return result
}

func pixelFormatToIndex(pixelFormat: MTLPixelFormat) -> Int {
    for i in 0 ..< pixelFormatMenuOrder.count {
        if pixelFormatMenuOrder[i] == pixelFormat {
            return i
        }
    }
    return 0
}

func indexToPixelFormat(i: Int) -> MTLPixelFormat? {
    guard i > 0 && i < pixelFormatMenuOrder.count else {
        return nil
    }
    return pixelFormatMenuOrder[i]
}