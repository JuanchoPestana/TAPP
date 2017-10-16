//
//  MainTicketViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface MainTicketViewController : UIViewController

// IMAGEN FONDO TICKET

@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_ticket;


// OUTLETS BOTONES
@property (weak, nonatomic) IBOutlet UIButton *boton_no;
@property (weak, nonatomic) IBOutlet UIButton *boton_si;


// ACCIONES BOTONES
- (IBAction)accion_no:(id)sender;
- (IBAction)accion_si:(id)sender;



@end
