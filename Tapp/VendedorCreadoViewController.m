//
//  VendedorCreadoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 6/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "VendedorCreadoViewController.h"

@interface VendedorCreadoViewController ()

@end

@implementation VendedorCreadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"menu" sender: self];
}

@end
