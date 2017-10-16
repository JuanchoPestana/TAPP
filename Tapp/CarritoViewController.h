//
//  CarritoViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Producto.h"
#import "Transaccion.h"
#import "Toast.h"

@interface CarritoViewController : UIViewController <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate, UIGestureRecognizerDelegate>


// OUTLET SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_left;



// ACCION SWIPE
- (IBAction)accion_swipe_right:(id)sender;
- (IBAction)accion_swipe_left:(id)sender;



// COLLECTION VIEW CARRITO
@property (weak, nonatomic) IBOutlet UICollectionView *collection_view_carrito;

// LABEL NOMBRE VENDEDOR
@property (weak, nonatomic) IBOutlet UILabel *label_nombre_vendedor;



@end
