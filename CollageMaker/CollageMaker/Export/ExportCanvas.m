//
//  ExportCanvas.m
//  CollageMaker
//
//  Created by Alex on 2/5/21.
//  Copyright © 2021 Alex. All rights reserved.
//

#import "ExportCanvas.h"

@interface ExportCanvas()

@end

@implementation ExportCanvas

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _size = size;
        int bytesPerPixel = 4;
        unsigned char *rawData = (unsigned char *) calloc(size.width * size.height * bytesPerPixel, sizeof(unsigned char));
        _rawDataContainer = [[NSData alloc] initWithBytesNoCopy:rawData length:size.width * size.height * bytesPerPixel freeWhenDone:YES];
    }
    return self;
}

@end
