//
//  SuccessQRViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SuccessQRViewController.h"

@interface SuccessQRViewController ()

@end

@implementation SuccessQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"ticket" sender: self];
}

@end
