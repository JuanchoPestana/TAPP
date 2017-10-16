//
//  MainCobrarViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Producto.h"
#import "Categoria.h"
#import "Toast.h"


@interface MainCobrarViewController : UIViewController <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate, UIGestureRecognizerDelegate>


// SWIPE OUTLET
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_regresar;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_continuar;

// ACCION REGRESAR
- (IBAction)accion_regresar:(id)sender;
- (IBAction)accion_continuar:(id)sender;


// COLLECTION VIEW PRODUCTOS
@property (weak, nonatomic) IBOutlet UICollectionView *collection_view;


// COLLECTION VIEW CATEGORIAS
@property (weak, nonatomic) IBOutlet UICollectionView *collection_view_categorias;


@end
