//
//  MainTicketTPVViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 8/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTicketTPVViewController : UIViewController

// IMAGEN FONDO
@property (weak, nonatomic) IBOutlet UIImageView *imagen_fondo_ticket;


// BOTONES
@property (weak, nonatomic) IBOutlet UIButton *boton_no;
@property (weak, nonatomic) IBOutlet UIButton *boton_si;



// ACCIONES
- (IBAction)accion_no:(id)sender;
- (IBAction)accion_si:(id)sender;



@end
