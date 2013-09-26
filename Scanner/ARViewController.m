//
//  ARViewController.m
//  Scanner
//
//  Created by Stephen Keep on 25/09/2013.
//  Copyright (c) 2013 Red Ant Ltd. All rights reserved.
//

#import "ARViewController.h"
#import "ARScanViewController.h"

@interface ARViewController ()

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)scan {
    ARScanViewController *scan = [[ARScanViewController alloc] initWithNibName:@"ARScanViewController" bundle:nil];
    [self presentViewController:scan animated:NO completion:^(void) {
        
    }];
}

@end
