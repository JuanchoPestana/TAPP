//
//  MainCategoriasViewController.h
//  Tapp
//
//  Created by Juancho Pestana on 4/4/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Categoria.h"

@interface MainCategoriasViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

// OUTLETS SWIPE
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe_right;

// ACCIONES SWIPE
- (IBAction)accion_swipe_right:(id)sender;

// ACCION CATEGORIA NUEVA
- (IBAction)accion_categoria_nueva:(id)sender;


// COLLECTION VIEW
@property (weak, nonatomic) IBOutlet UICollectionView *collection_view;


@end
