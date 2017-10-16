//
//  CuentaCreadaVC.m
//  Tapp
//
//  Created by Juancho Pestana on 3/5/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CuentaCreadaVC.h"

@interface CuentaCreadaVC ()


@end

bool buttonFlashing;

@implementation CuentaCreadaVC

- (void)viewDidLoad {
    [super viewDidLoad];

        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(continuar) userInfo:nil repeats:NO];

    
    
}// END VIEWDIDLOAD

- (void)continuar{
    
    [self performSegueWithIdentifier: @"continuar" sender: self];

    
}// END CONTINUAR

@end
