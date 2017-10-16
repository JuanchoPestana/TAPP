//
//  FailQRViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "FailQRViewController.h"

@interface FailQRViewController ()

@end

@implementation FailQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}// END VIEWDIDLOAD

- (void)cambiarPantalla{
    
    NSString *modo_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"modo"];
    
    if ([modo_traido isEqualToString:@"tpv"]) {
        [self performSegueWithIdentifier: @"tpv" sender: self];
    }else{
        [self performSegueWithIdentifier: @"pagos" sender: self];
    }
}

- (IBAction)accion_intentar:(id)sender {
    
    [self cambiarPantalla];
}
@end
