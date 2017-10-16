//
//  SuccessModoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SuccessModoViewController.h"

@interface SuccessModoViewController ()

@end

@implementation SuccessModoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"menu" sender: self];
}


@end
