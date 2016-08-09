//
//  ViewController.m
//  RTImageCroping
//
//  Created by Santhosh on 08/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "ViewController.h"
#import "ImageCroppingViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ImageCroppingViewController *croppingVc = [[ImageCroppingViewController alloc] init];
    croppingVc.cropImage = [UIImage imageNamed:@"FacebookSCOREshareDING.jpg"];
    [self.navigationController pushViewController:croppingVc animated:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
