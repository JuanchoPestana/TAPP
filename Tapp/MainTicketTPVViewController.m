//
//  MainTicketTPVViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 8/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MainTicketTPVViewController.h"

@interface MainTicketTPVViewController ()

@end

@implementation MainTicketTPVViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}// END VIEWDIDLOAD


- (IBAction)accion_no:(id)sender {
    
    [self performSegueWithIdentifier: @"menu" sender: self];
    
}// END ACCION NO

- (IBAction)accion_si:(id)sender {
    
    [self performSegueWithIdentifier: @"ticketcorreo" sender: self];

}// END ACCION SI
@end
