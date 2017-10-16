//
//  SuccessNombreViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/22/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "SuccessNombreViewController.h"

@interface SuccessNombreViewController ()

@end

@implementation SuccessNombreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"menu" sender: self];
}



@end
