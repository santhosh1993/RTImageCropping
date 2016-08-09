//
//  RTCropView.h
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTCropViewDelegate <NSObject>

- (void)panGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)leftToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)rightToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)leftBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer;
- (void)rightBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer;

@end

@interface RTCropView : UIView

@property (nonatomic , weak) id <RTCropViewDelegate> delegate;

@end
