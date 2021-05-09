//
//  PictureCompoundPerformer.m
//  CollageMaker
//
//  Created by Alex on 12/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

#import "PictureCompoundPerformer.h"

@interface PictureCompoundPerformer()

@property CGContextRef context;
@property ExportCanvas *canvas;

@end

@implementation PictureCompoundPerformer

- (nonnull instancetype)initWithCanvas:(nonnull ExportCanvas *)canvas {
    self = [super init];
    if (self) {
        _canvas = canvas;
        unsigned char *rawData = (unsigned char *)canvas.rawDataContainer.bytes;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSUInteger bitsPerComponent = 8;
        NSUInteger bytesPerPixel = 4;
        _context = CGBitmapContextCreate(rawData, canvas.size.width, canvas.size.height,
                                             bitsPerComponent, canvas.size.width * bytesPerPixel, colorSpace,
                                             kCGImageAlphaPremultipliedLast);
    }
    return self;
}

- (void)drawImage:(nonnull UIImage *)image atRect:(CGRect)rect {
    CGImageRef imageRefG = [image CGImage];
    CGContextDrawImage(self.context, rect, imageRefG);
}

- (UIImage *)buildImage {
    CGImageRef imgRef = CGBitmapContextCreateImage(self.context);
    UIImage* img = [UIImage imageWithCGImage:imgRef];
    return img;
}

@end
