//
//  RTImageCroppingViewController.m
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "RTImageCroppingViewController.h"
#import "RTCropView.h"
#import "UIImage+RTCropImage.h"

#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width


@interface RTImageCroppingViewController () <RTCropViewDelegate>
{
    CGSize imageSize;
    CGFloat minYposition;
    CGFloat maxYposition;
    CGFloat minXposition;
    CGFloat maxXposition;
    float aspectRatio;
    CGSize cropSize;
    
    __weak IBOutlet UIView *topBlurView;
    __weak IBOutlet UIView *rightBlurView;
    __weak IBOutlet UIView *leftBlurView;
    __weak IBOutlet UIView *bottomBlurView;
    
    __weak IBOutlet UIView *topView;
    
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *cropButton;
    __weak IBOutlet UIButton *saveButton;
    
    __weak IBOutlet UIImageView *imageView;
     RTCropView *cropView;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
    
}

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *rightBlurViewRightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *leftBlurViewLeftConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *bottomBlurViewBottomConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *topBlurViewTopConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *rightBlurViewWidthConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *leftBlurViewWidthConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *bottomBlurViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *topBlurViewHeightConstraint;

@end

@implementation RTImageCroppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [activityIndicatorView startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpCroppingView];
    [self.view bringSubviewToFront:cropView];
    [activityIndicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self receivedMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)receivedMemoryWarning
{
    CGFloat mul = [self multiplier];
    CGRect rect = CGRectMake(0,0,self.cropImage.size.width/mul,self.cropImage.size.height/mul);
    UIGraphicsBeginImageContext(rect.size);
    [self.cropImage drawInRect:rect];
   
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    self.cropImage =[UIImage imageWithData:imageData];
    [imageView setImage:self.cropImage];
}

- (void)setUpCroppingView
{
    
    imageView.image = self.cropImage;
    
    cropSize = [self imageCroppingSize];
    CGFloat imageWidth = cropSize.width;
    CGFloat imageHeight = cropSize.height;
    
    aspectRatio = imageWidth/imageHeight;
    
    minYposition = imageView.center.y - (self.cropImage.size.height / (2*[self multiplier]));
    maxYposition = imageView.center.y + (self.cropImage.size.height / (2*[self multiplier]));
    
    minXposition = imageView.center.x - (self.cropImage.size.width / (2*[self multiplier]));
    maxXposition = imageView.center.x + (self.cropImage.size.width / (2*[self multiplier]));
    
    if(self.cropImage.size.width < imageView.frame.size.width && self.cropImage.size.height < imageView.frame.size.height)
    {
        imageView.contentMode = UIViewContentModeCenter;
    }
    
    NSLog(@"%f %f",minYposition,imageView.center.y);
    
    cropView = [[RTCropView alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH/2 - imageWidth/2,CGRectGetMidY(imageView.frame) - imageHeight/2,imageWidth,imageHeight)];
    cropView.delegate = self;
    
    [self updateBlurViewFrames:cropView.frame];
    
    [self.view addSubview:cropView];
}

#pragma mark - Gesture recogniser methods

- (void)panGestureRecognised:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(recognizer.view.superview.frame.origin.y + translation.y > (minYposition - 20)  && CGRectGetMaxY(recognizer.view.superview.frame) + translation.y < (maxYposition + 20))
    {
        recognizer.view.superview.center = CGPointMake(recognizer.view.superview.center.x,recognizer.view.superview.center.y +translation.y);
    }

    if(recognizer.view.superview.frame.origin.x + translation.x > (minXposition - 20)  && CGRectGetMaxX(recognizer.view.superview.frame) + translation.x < (maxXposition + 20))
    {
        recognizer.view.superview.center = CGPointMake(recognizer.view.superview.center.x + translation.x,recognizer.view.superview.center.y);
    }
    
    [self updateBlurViewFrames:recognizer.view.superview.frame];
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)leftToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
   
    translation = (((translation.x>0) ? translation.x : -translation.x) >= (translation.y > 0?translation.y:-translation.y))? CGPointMake(translation.x,translation.x/aspectRatio):CGPointMake(translation.y * aspectRatio,translation.y) ;
    
    CGRect updateFrameTo = CGRectMake(recognizer.view.superview.frame.origin.x + translation.x,recognizer.view.superview.frame.origin.y + translation.y,recognizer.view.superview.frame.size.width - translation.x,recognizer.view.superview.frame.size.height - translation.y);
   
    [self changeCropViewPresentFrameToUpdatedFrame:updateFrameTo withPangestureRecognizer:recognizer];
    
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)rightToppanGestureRecognised:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.view];
    translation = (((translation.x>0) ? translation.x : -translation.x) >= (translation.y > 0 ? translation.y:-translation.y))? CGPointMake(translation.x,-translation.x/aspectRatio):CGPointMake(-translation.y  * aspectRatio ,translation.y) ;
    

    CGRect updateFrameTo = CGRectMake(recognizer.view.superview.frame.origin.x,recognizer.view.superview.frame.origin.y + translation.y,recognizer.view.superview.frame.size.width + translation.x,recognizer.view.superview.frame.size.height - translation.y);
    
    [self changeCropViewPresentFrameToUpdatedFrame:updateFrameTo withPangestureRecognizer:recognizer];
    
    [recognizer setTranslation:CGPointZero inView:self.view];

}

- (void)leftBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    
    translation = (((translation.x>0) ? translation.x : -translation.x) >= (translation.y > 0?translation.y:-translation.y))? CGPointMake(translation.x,-translation.x/aspectRatio):CGPointMake(-translation.y * aspectRatio,translation.y) ;

     CGRect updateFrameTo = CGRectMake(recognizer.view.superview.frame.origin.x + translation.x,recognizer.view.superview.frame.origin.y,recognizer.view.superview.frame.size.width - translation.x,recognizer.view.superview.frame.size.height + translation.y);
    
    [self changeCropViewPresentFrameToUpdatedFrame:updateFrameTo withPangestureRecognizer:recognizer];
    
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)rightBottompanGestureRecognised:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    translation = (((translation.x>0) ? translation.x : -translation.x) >= (translation.y > 0?translation.y:-translation.y))? CGPointMake(translation.x,translation.x/aspectRatio):CGPointMake(translation.y * aspectRatio,translation.y) ;

     CGRect updateFrameTo = CGRectMake(recognizer.view.superview.frame.origin.x,recognizer.view.superview.frame.origin.y,recognizer.view.superview.frame.size.width + translation.x,recognizer.view.superview.frame.size.height + translation.y);
    
    [self changeCropViewPresentFrameToUpdatedFrame:updateFrameTo withPangestureRecognizer:recognizer];
    
    [recognizer setTranslation:CGPointZero inView:self.view];
}


#pragma mark - Button action methods

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)imageCropBtnClicked:(id)sender {
    
    CGRect cropFrameRect = cropView.frame;
    CGFloat multiplier = [self multiplier];
    
    CGRect finalCropRect = CGRectMake((cropFrameRect.origin.x - minXposition + 20) *multiplier , (cropFrameRect.origin.y - minYposition + 20)* multiplier, (cropFrameRect.size.width - 40) * multiplier,(cropFrameRect.size.height - 40) * multiplier);
    
    if(imageView.contentMode == UIViewContentModeCenter)
    {
        finalCropRect = CGRectMake(cropFrameRect.origin.x - (imageView.frame.size.width/2 - self.cropImage.size.width/2) , cropFrameRect.origin.y - (imageView.frame.size.height/2 - self.cropImage.size.height/2) - imageView.frame.origin.y,cropFrameRect.size.width,cropFrameRect.size.height);
    }
    UIImage *image = [UIImage cropImageWithUIImage:self.cropImage WithCropRect:finalCropRect];

    
    imageView.image = image;
    self.cropImage = image;
    
    [(UIButton *)sender setHidden:YES];
    [self hideTheCrropingView];
    saveButton.hidden = NO;

}

- (IBAction)saveBtnClicked:(id)sender {

    [self.delegate croppedImage:self.cropImage];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - DEVELOPER METHODS

- (CGFloat)multiplier
{
    CGRect imageRect = imageView.frame;

    CGFloat multiplier = ((self.cropImage.size.height / imageRect.size.height)  > (self.cropImage.size.width / imageRect.size.width))?((self.cropImage.size.height > imageRect.size.height)? self.cropImage.size.height / imageRect.size.height : 1 ):((self.cropImage.size.width > imageRect.size.width)? self.cropImage.size.width / imageRect.size.width  : 1);
    
    return multiplier;
}

- (void)changeCropViewPresentFrameToUpdatedFrame:(CGRect)updatedFrame withPangestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    if(updatedFrame.size.width > cropSize.width && updatedFrame.size.height > cropSize.height)
    {
        if(updatedFrame.origin.x >= minXposition - 20 && updatedFrame.origin.y > minYposition - 20)
        {
            if(CGRectGetMaxX(updatedFrame) <= maxXposition + 20 && CGRectGetMaxY(updatedFrame) <= maxYposition + 20)
            {
                recognizer.view.superview.frame = updatedFrame;
                [self updateBlurViewFrames:updatedFrame];
            }
        }
    }
}

- (void)updateBlurViewFrames:(CGRect)frame
{
    self.topBlurViewTopConstraint.constant = minYposition - topView.frame.size.height ;
    self.topBlurViewHeightConstraint.constant = frame.origin.y - minYposition + 18;

    self.leftBlurViewLeftConstraint.constant = minXposition;
    self.leftBlurViewWidthConstraint.constant = frame.origin.x - minXposition + 18;
    
    self.rightBlurViewRightConstraint.constant = maxXposition - [imageView frame].size.width;
    self.rightBlurViewWidthConstraint.constant = maxXposition - frame.origin.x - frame.size.width + 18;
    
    self.bottomBlurViewBottomConstraint.constant = maxYposition - imageView.frame.size.height - imageView.frame.origin.y;
    self.bottomBlurViewHeightConstraint.constant =  maxYposition - frame.origin.y - frame.size.height + 18;
}

- (void)hideTheCrropingView
{
    topBlurView.hidden = YES;
    leftBlurView.hidden = YES;
    rightBlurView.hidden = YES;
    bottomBlurView.hidden = YES;
    
    cropView.hidden = YES;
}

-(void)dealloc
{
    NSLog(@" de alloc ");
}

#pragma mark - DATA SOURCE

- (void)setDataSource:(id<RTImageCroppingViewControllerDataSource>)dataSource
{
    _dataSource = dataSource;
}

- (CGSize)imageCroppingSize
{
    if ([self.dataSource respondsToSelector:@selector(imageCroppingSize)]) {
        return [self.dataSource imageCroppingSize];
    }
    return CGSizeMake(100,100);
}

@end
