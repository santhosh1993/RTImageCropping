//
//  CropImage.h
//  PicSaw
//
//  Created by Santhosh on 01/09/15.
//  Copyright (c) 2015 Santhosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CropImage : NSObject

+ (UIImage *)cropImageWithUIImage:(UIImage *)cropImage WithCropRect:(CGRect)cropRect;
+ (UIImage *)rotateImage:(UIImage *)image;

@end
