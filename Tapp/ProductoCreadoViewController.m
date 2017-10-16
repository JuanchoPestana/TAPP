//
//  ProductoCreadoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 3/12/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "ProductoCreadoViewController.h"

@interface ProductoCreadoViewController ()

@end

@implementation ProductoCreadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];


}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"menu" sender: self];
}

@end
