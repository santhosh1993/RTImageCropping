//
//  ViewController.m
//  RTImageCroping
//
//  Created by Santhosh on 09/08/16.
//  Copyright © 2016 riktam. All rights reserved.
//

#import "ViewController.h"
#import "RTImageCroppingViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RTImageCroppingViewController *croppingVc = [[RTImageCroppingViewController alloc] init];
    croppingVc.cropImage = [UIImage imageNamed:@"FacebookSCOREshareDING.jpg"];
    [self presentViewController:croppingVc animated:YES completion:^{
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
