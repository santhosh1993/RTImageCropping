//
//  RTImageCroppingViewController.h
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTImageCroppingViewControllerDataSource <NSObject>

- (CGSize)imageCroppingSize;
- (float)imageCornerRadius;

@end

@protocol RTImageCroppingViewControllerDelegate <NSObject>

- (void)croppedImage:(UIImage *)image;

@end

@interface RTImageCroppingViewController : UIViewController

@property (nonatomic , weak) id<RTImageCroppingViewControllerDataSource> dataSource;
@property (nonatomic , weak) id<RTImageCroppingViewControllerDelegate> delegate;
@property (nonatomic , strong) UIImage *cropImage;

@end
