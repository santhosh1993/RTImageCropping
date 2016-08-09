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

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RTImageCroppingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *croppedImageView;

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
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This app doesn't have access to your Camera. You can turn on it in iOS Settings" message:@"Go to Settings->RTImageCropping" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
