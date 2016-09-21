//
//  ViewController.m
//  RTImageCroping
//
//  Created by Santhosh on 09/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "ViewController.h"
#import "RTImageCroppingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RTImageCroppingViewControllerDelegate,RTImageCroppingViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *croppedImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeOfImageSegmentControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)tapToUpdateImage:(UIButton *)sender {
    [self showActionSheet];
}
#pragma mark - ACTION SHEET METHODS

- (void)showActionSheet
{
    UIAlertController *imageSourceSlectionActionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Would you like to add a pic" preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Go To Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotToCamera];
    }];
    
    [imageSourceSlectionActionSheet addAction:cameraAction];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Go To Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self uploadFile];
    }];
    
    [imageSourceSlectionActionSheet addAction:galleryAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [imageSourceSlectionActionSheet addAction:cancelAction];
    
    [self presentViewController:imageSourceSlectionActionSheet animated:YES completion:nil];
}

- (void)uploadFile
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)gotToCamera
{
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(!granted)
                {
                    NSLog(@"please give the permissions to the app for using the camera");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *accessDeniedAlertView = [UIAlertController alertControllerWithTitle:@"This app doesn't have access to your Camera. You can turn on it in iOS Settings" message:@"Go to Settings->RTImageCropping" preferredStyle:UIAlertControllerStyleAlert];

                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        
                        [accessDeniedAlertView addAction:cancelAction];
                        
                        [self presentViewController:accessDeniedAlertView animated:YES completion:nil];
                    });
                }
                else{
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.delegate = self;
                    [self presentViewController:picker animated:YES completion:nil];
                }
            });
            
        }];
    }
}

#pragma mark - Image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    RTImageCroppingViewController *croppingVc = [[RTImageCroppingViewController alloc] init];
    croppingVc.cropImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    croppingVc.delegate = self;
    croppingVc.dataSource = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:croppingVc animated:YES completion:^{
            
        }];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - RTImageCroppingViewControllerDelegate

- (void)croppedImage:(UIImage *)image
{
    self.croppedImageView.image = image;
    NSLog(@"%@",image);
}

#pragma mark - RTImageCroppingViewControllerDataSource

- (CGSize)imageCroppingSize
{
    switch (_typeOfImageSegmentControl.selectedSegmentIndex) {
        case 0:
            return CGSizeMake(200,100);
            break;
        case 1:
            return CGSizeMake(100,100);
            break;
        case 2:
            return CGSizeMake(200,100);
            break;
        default:
            return CGSizeMake(100,100);
            break;
    }
}

- (float)imageCornerRadius
{
    switch (_typeOfImageSegmentControl.selectedSegmentIndex) {
        case 0:
            return 0.0;
            break;
        case 1:
            return 50.0;
            break;
        case 2:
            return 20.0;
            break;
        default:
            return 0.0;
            break;
    }
}

#pragma mark - SECGMENT CONTROL

- (IBAction)selectedSegmentBtnChanged:(UISegmentedControl *)sender
{
    [self showActionSheet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
