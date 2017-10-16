//
//  TicketEnviadoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "TicketEnviadoViewController.h"

@interface TicketEnviadoViewController ()

@end

@implementation TicketEnviadoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cambiarPantalla) userInfo:nil repeats:NO];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
        [self performSegueWithIdentifier: @"menu" sender: self];
    
}// END CAMBIAR PANTALLA




@end
