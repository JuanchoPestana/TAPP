//
//  HistorialViewController.m
//  Tapp
//
//  Created by Juan Pestana on 9/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "HistorialViewController.h"

@interface HistorialViewController ()

@end

@implementation HistorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];


}// END VIEWDIDLOAD


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE

// METODO QUE CONFIGURAR SWIPE
- (void)configurarSwipe{
    
    _swipe_right.numberOfTouchesRequired = 2;
    //_swipe_left.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE

- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];

}



@end
