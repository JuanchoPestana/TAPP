//
//  TicketEnviadoTPVViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 8/25/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TicketEnviadoTPVViewController.h"

@interface TicketEnviadoTPVViewController ()

@end

@implementation TicketEnviadoTPVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    [self performSegueWithIdentifier: @"menu" sender: self];
    
}// END CAMBIAR PANTALLA




@end
