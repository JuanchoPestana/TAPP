//
//  SuccessLogoViewController.m
//  Tapp
//
//  Created by Juan Pestana on 9/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SuccessLogoViewController.h"

@interface SuccessLogoViewController ()

@end

@implementation SuccessLogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"regresar" sender: self];
}







@end
