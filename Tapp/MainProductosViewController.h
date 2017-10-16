//
//  MainProductosViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 3/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Producto.h"
#import "Categoria.h"



@interface MainProductosViewController : UIViewController <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate, UIGestureRecognizerDelegate>

// SWIPE OUTLETS
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;

// SWIPE ACCIONES
- (IBAction)accion_swipe_right:(id)sender;

// ACCION CREAR NUEVO PRODUCTO
- (IBAction)accion_crear_producto:(id)sender;



// COLLECTION VIEW PRODUCTOS
@property (weak, nonatomic) IBOutlet UICollectionView *collection_view;

// COLLECTION VIEW CATEGORIAS
@property (weak, nonatomic) IBOutlet UICollectionView *collection_view_categorias;



@end
