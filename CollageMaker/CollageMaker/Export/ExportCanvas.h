//
//  ExportCanvas.h
//  CollageMaker
//
//  Created by Alex on 2/5/21.
//  Copyright © 2021 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ExportCanvas : NSObject

@property CGSize size;
@property NSData * _Nonnull rawDataContainer;
- (nonnull instancetype)initWithSize:(CGSize)size;

@end


