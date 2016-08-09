//
//  ImageCroppingViewController.m
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "ImageCroppingViewController.h"
#import "CropView.h"
#import "CropImage.h"

#define TOP_VIEW 610
#define CANCEL_BTN 611
#define CROP_BTN 612
#define SAVE_BTN 613

#define IMAGE_VIEW 620
#define TOP_BLUR_VIEW 621
#define LEFT_BLUR_VIEW 622
#define RIGHT_BLUR_VIEW 623
#define BOTTOM_BLUR_VIEW 624

#define CROP_VIEW 630
#define ACTIVITY_INDICATOR 640

#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width


@interface ImageCroppingViewController () <CropViewDelegate>
{
    CGSize imageSize;
    CGFloat minYposition;
    CGFloat maxYposition;
    CGFloat minXposition;
    CGFloat maxXposition;
    float aspectRatio;
    CGSize cropSize;
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

@implementation ImageCroppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [(UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_INDICATOR] startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUpCroppingView];
    [self.view bringSubviewToFront:[self.view viewWithTag:CROP_VIEW]];
    [(UIActivityIndicatorView *)[self.view viewWithTag:ACTIVITY_INDICATOR] stopAnimating];
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
    [(UIImageView *)[self.view viewWithTag:IMAGE_VIEW] setImage:self.cropImage];
}

- (void)setUpCroppingView
{
    UIImageView *imageVw = (UIImageView *)[self.view viewWithTag:IMAGE_VIEW];
    imageVw.image = self.cropImage;
    
    cropSize = [self imageCroppingSize];
    CGFloat imageWidth = cropSize.width;
    CGFloat imageHeight = cropSize.height;
    
    aspectRatio = imageWidth/imageHeight;
    
    minYposition = imageVw.center.y - (self.cropImage.size.height / (2*[self multiplier]));
    maxYposition = imageVw.center.y + (self.cropImage.size.height / (2*[self multiplier]));
    
    minXposition = imageVw.center.x - (self.cropImage.size.width / (2*[self multiplier]));
    maxXposition = imageVw.center.x + (self.cropImage.size.width / (2*[self multiplier]));
    
    if(self.cropImage.size.width < imageVw.frame.size.width && self.cropImage.size.height < imageVw.frame.size.height)
    {
        imageVw.contentMode = UIViewContentModeCenter;
    }
    
    NSLog(@"%f %f",minYposition,imageVw.center.y);
    
    CropView *cropingView = [[CropView alloc] initWithFrame:CGRectMake(DEVICE_SCREEN_WIDTH/2 - imageWidth/2,CGRectGetMidY(imageVw.frame) - imageHeight/2,imageWidth,imageHeight)];
    cropingView.tag = CROP_VIEW;
    cropingView.delegate = self;
    
    [self updateBlurViewFrames:cropingView.frame];
    
    [self.view addSubview:cropingView];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageCropBtnClicked:(id)sender {
    
    CGRect cropFrameRect = [self.view viewWithTag:CROP_VIEW].frame;
    CGFloat multiplier = [self multiplier];
    
    CGRect finalCropRect = CGRectMake((cropFrameRect.origin.x - minXposition + 20) *multiplier , (cropFrameRect.origin.y - minYposition + 20)* multiplier, (cropFrameRect.size.width - 40) * multiplier,(cropFrameRect.size.height - 40) * multiplier);
    
    if([self.view viewWithTag:IMAGE_VIEW].contentMode == UIViewContentModeCenter)
    {
        UIImageView *croppingImageView = (UIImageView *)[self.view viewWithTag:IMAGE_VIEW];
        finalCropRect = CGRectMake(cropFrameRect.origin.x - (croppingImageView.frame.size.width/2 - self.cropImage.size.width/2) , cropFrameRect.origin.y - (croppingImageView.frame.size.height/2 - self.cropImage.size.height/2) - croppingImageView.frame.origin.y,cropFrameRect.size.width,cropFrameRect.size.height);
    }
    UIImage *image = [CropImage cropImageWithUIImage:self.cropImage WithCropRect:finalCropRect];
   
    UIImageView *imageVw = (UIImageView *)[self.view viewWithTag:IMAGE_VIEW];
    imageVw.image = image;
    
    self.cropImage = image;
    
    [(UIButton *)sender setHidden:YES];
    [self hideTheCrropingView];
    [self.view viewWithTag:SAVE_BTN].hidden = NO;

}

- (IBAction)saveBtnClicked:(id)sender {

    [self.delegate croppedImage:self.cropImage];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - DEVELOPER METHODS

- (CGFloat)multiplier
{
    CGRect imageRect = [self.view viewWithTag:IMAGE_VIEW].frame;

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
    self.topBlurViewTopConstraint.constant = minYposition - [self.view viewWithTag:TOP_VIEW].frame.size.height ;
    self.topBlurViewHeightConstraint.constant = frame.origin.y - minYposition + 18;

    self.leftBlurViewLeftConstraint.constant = minXposition;
    self.leftBlurViewWidthConstraint.constant = frame.origin.x - minXposition + 18;
    
    self.rightBlurViewRightConstraint.constant = maxXposition - [[self.view viewWithTag:IMAGE_VIEW] frame].size.width;
    self.rightBlurViewWidthConstraint.constant = maxXposition - frame.origin.x - frame.size.width + 18;
    
    self.bottomBlurViewBottomConstraint.constant = maxYposition - [self.view viewWithTag:IMAGE_VIEW].frame.size.height - [self.view viewWithTag:IMAGE_VIEW].frame.origin.y;
    self.bottomBlurViewHeightConstraint.constant =  maxYposition - frame.origin.y - frame.size.height + 18;
}

- (void)hideTheCrropingView
{
    [self.view viewWithTag:TOP_BLUR_VIEW].hidden = YES;
    [self.view viewWithTag:LEFT_BLUR_VIEW].hidden = YES;
    [self.view viewWithTag:RIGHT_BLUR_VIEW].hidden = YES;
    [self.view viewWithTag:BOTTOM_BLUR_VIEW].hidden = YES;
    
    [self.view viewWithTag:CROP_VIEW].hidden = YES;
}

-(void)dealloc
{
    NSLog(@" de alloc ");
}

#pragma mark - DATA SOURCE

- (void)setDataSource:(id<ImageCroppingViewControllerDataSource>)dataSource
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
