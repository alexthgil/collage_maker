//
//  PictureCompoundPerformer.h
//  CollageMaker
//
//  Created by Alex on 12/19/20.
//  Copyright © 2020 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ExportCanvas.h"

@interface PictureCompoundPerformer : NSObject

- (nonnull instancetype)initWithCanvas:(nonnull ExportCanvas *)canvas;
- (void)drawImage:(nonnull UIImage *)image atRect:(CGRect)rect;
- (nullable UIImage *)buildImage;

@end
