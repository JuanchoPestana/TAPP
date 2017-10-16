//
//  MainProductosViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 3/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MainProductosViewController.h"

@interface MainProductosViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    
    sqlite3 *categorias;
    NSString *dbPathString_categorias;
    
    // ARREGLO DONDE VOY A PONER LA INFO PARA EL COLLECTION PRODUCTOS
    NSMutableArray *arrayOfProducto;
    NSMutableArray *arrayOfProductoTemporal;
    NSMutableArray *arrayOfProductoGroupBy;
    
    // ARREGLO DONDE VOY A PONER LA INFO PARA EL COLLECTION CATEGORIAS
    NSMutableArray *arrayOfCategoria;
    NSMutableArray *arrayOfCategoriaTemporal;

    
    // VARIABLE QUE GUARDA INDEXPATH DE SWIPE
    NSIndexPath *indexPath_cell_flipped;
    
    NSIndexPath *index_origen;
    NSIndexPath *index_fin;
    
    // NOMBRE CATEGORIA SELECCIONADA
    NSString *nombre_categoria_seleccionado;


}// END INTERFACE

@end

BOOL cell_flipped_for_transition;
int contador;
BOOL cell_is_flipped;
BOOL left_or_right = true; // true left, right false

UITextView *textview_descripcion;

@implementation MainProductosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPES
    [self configurarSwipe];
    
    // 2. INICIALIZAR ARREGLO
    [self inicializaciones];
    
    // 3. ACTUALIZAR ARREGLO COLEECTION PRODUCTOS
    [self actualizarArregloCollectionView];
    
    // 4. ACTUALIZAR ARREGLO COLLECTION CATEGORIAS
    [self actualizarArregloCollectionViewCategorias];
    
    // 4. AGREGAR GESTURES A COLLECTIONVIEW
    [self addGesturesCollection];


}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INICIALIZAR ARREGLO Y COLLECTION

- (void)inicializaciones{
    
    // ARREGLO PARA SQLITE PRODUCTOS
    arrayOfProducto = [[NSMutableArray alloc]init];
    arrayOfProductoTemporal = [[NSMutableArray alloc]init];
    arrayOfProductoGroupBy = [[NSMutableArray alloc]init];


    // ARREGLO PARA SQLITE CATEGORIAS
    arrayOfCategoria = [[NSMutableArray alloc]init];
    arrayOfCategoriaTemporal = [[NSMutableArray alloc]init];
    
    // COLLECTION VIEW PRODUCTOS
    self.collection_view.dataSource = self;
    self.collection_view.delegate = self;
    _collection_view.showsVerticalScrollIndicator = false;
    _collection_view.backgroundColor = [UIColor clearColor];
    
    // COLLECTION VIEW CATEGORIAS
    self.collection_view_categorias.dataSource = self;
    self.collection_view_categorias.delegate = self;
    _collection_view_categorias.showsHorizontalScrollIndicator = false;
    _collection_view_categorias.backgroundColor = [UIColor clearColor];

    // BOOLS
    cell_is_flipped = false;
    cell_flipped_for_transition = false;
    
    // ARRANCAR STRING DE CATEGORIA EN GENERAL
        nombre_categoria_seleccionado = @"Todos";
    
}// END INICIALIZAR ARREGLO Y COLLECTION

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE

// METODO QUE CONFIGURAR SWIPE
- (void)configurarSwipe{
    
    _swipe_right.numberOfTouchesRequired = 2;
    
}// END CONFIGURAR SWIPE

- (IBAction)accion_swipe_right:(id)sender {

    [self performSegueWithIdentifier: @"right" sender: self];
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION NUEVO PRODUCTO

- (IBAction)accion_crear_producto:(id)sender {
    
    [self performSegueWithIdentifier: @"left" sender: self];

}
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GESTURES DE COLLECTION VIEW

- (void)addGesturesCollection{
    
    ////////////////////////////////////////////////// COLLECTION PRODUCTOS
    // SWIPE LEFT
    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToFlipGestureLeft:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collection_view addGestureRecognizer:swipeGestureRecognizer];
    
    // SWIPE RIGHT
    UISwipeGestureRecognizer* swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToFlipGestureRight:)];
    swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collection_view addGestureRecognizer:swipeGestureRecognizerRight];
    
    // SINGLE TAP PARA REGRESAR CELDA
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
    
    // LONG PRESS
    UILongPressGestureRecognizer *lpgr= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collection_view addGestureRecognizer:lpgr];
    
    // DOUBLE TAPP
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    [self.collection_view addGestureRecognizer:doubleTapFolderGesture];

    ////////////////////////////////////////////////// COLLECTION PRODUCTOS

    // SINGLE TAPP
    UITapGestureRecognizer *tap_categoria = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapCategoria:)];
    [self.collection_view_categorias addGestureRecognizer:tap_categoria];
    
    
    
    
}// END ADD GESTURES COLLECTION

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE TO FLIP

// SWIPE LEFT
- (void)swipeToFlipGestureLeft:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        left_or_right = true;
        
        CGPoint point = [sender locationInView:_collection_view];
        
        if (!cell_is_flipped) {
            
            indexPath_cell_flipped = [self.collection_view indexPathForItemAtPoint:point];
            cell_is_flipped = true;
            
            if (!cell_flipped_for_transition) {
                UICollectionViewCell* cell = [self.collection_view cellForItemAtIndexPath:indexPath_cell_flipped];
                
                [UIView animateWithDuration:0.8
                                      delay:0
                                    options:(UIViewAnimationOptionAllowUserInteraction)
                                 animations:^
                 {
                     
                     [UIView transitionFromView:cell.contentView
                                         toView:cell.backgroundView
                                       duration:1.0
                                        options:UIViewAnimationOptionTransitionFlipFromRight
                                     completion:nil];
                 }
                                 completion:^(BOOL finished)
                 {
                     // CUANDO TERMINA ANIMACION PRESENTAR BACK PART
                     cell_flipped_for_transition = true;
                     _collection_view.scrollEnabled = false;
                     cell.backgroundView.hidden = false;
                 }
                 ];
            }
            
        }// end cell_is_flipped
    }
    
}// END SWIPE TO FLIP

// SWIPE RIGHT
- (void)swipeToFlipGestureRight:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        left_or_right = false;
        
        CGPoint point = [sender locationInView:_collection_view];
        
        if (!cell_is_flipped) {
            
            indexPath_cell_flipped = [self.collection_view indexPathForItemAtPoint:point];
            cell_is_flipped = true;
            
            if (!cell_flipped_for_transition) {
                UICollectionViewCell* cell = [self.collection_view cellForItemAtIndexPath:indexPath_cell_flipped];
                
                [UIView animateWithDuration:0.8
                                      delay:0
                                    options:(UIViewAnimationOptionAllowUserInteraction)
                                 animations:^
                 {
                     
                     [UIView transitionFromView:cell.contentView
                                         toView:cell.backgroundView
                                       duration:1.0
                                        options:UIViewAnimationOptionTransitionFlipFromLeft
                                     completion:nil];
                 }
                                 completion:^(BOOL finished)
                 {
                     // CUANDO TERMINA ANIMACION PRESENTAR BACK PART
                     cell_flipped_for_transition = true;
                     _collection_view.scrollEnabled = false;
                     cell.backgroundView.hidden = false;
                 }
                 ];
            }
            
        }// end cell_is_flipped
    }
    
}// END SWIPE TO FLIPRIGHT

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TAP ANYWHERE PARA REGRESAR CELDA

// SINGLE TAPP
- (void)tapOnView:(UITapGestureRecognizer *)sender
{
    
    if (cell_is_flipped) {
        if (cell_flipped_for_transition) {
            
            if (left_or_right) {
            
            UICollectionViewCell* cell = [self.collection_view cellForItemAtIndexPath:indexPath_cell_flipped];
            [UIView animateWithDuration:0.8
                                  delay:0
                                options:(UIViewAnimationOptionAllowUserInteraction)
                             animations:^
             {
                 [UIView transitionFromView:cell.backgroundView
                                     toView:cell.contentView
                                   duration:1.0
                                    options:UIViewAnimationOptionTransitionFlipFromLeft
                                 completion:nil];
             }
             
             
                             completion:^(BOOL finished)
             {
                 // CUANDO TERMINA ANIMACION REGRESAR A FRONT PART
                 Producto *aProducto = [arrayOfProducto objectAtIndex:indexPath_cell_flipped.row];
                 cell_flipped_for_transition = false;
                 cell_is_flipped = false;
                 _collection_view.scrollEnabled = true;
                 cell.backgroundView.hidden = true;
                 UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:200];
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *documentsDirectory = [paths objectAtIndex:0];
                 NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aProducto.get_nombreImagen_producto]];
                 imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
             }
             ];
            }else{
                
                UICollectionViewCell* cell = [self.collection_view cellForItemAtIndexPath:indexPath_cell_flipped];
                [UIView animateWithDuration:0.8
                                      delay:0
                                    options:(UIViewAnimationOptionAllowUserInteraction)
                                 animations:^
                 {
                     [UIView transitionFromView:cell.backgroundView
                                         toView:cell.contentView
                                       duration:1.0
                                        options:UIViewAnimationOptionTransitionFlipFromRight
                                     completion:nil];
                 }
                 
                 
                                 completion:^(BOOL finished)
                 {
                     // CUANDO TERMINA ANIMACION REGRESAR A FRONT PART
                     Producto *aProducto = [arrayOfProducto objectAtIndex:indexPath_cell_flipped.row];
                     cell_flipped_for_transition = false;
                     cell_is_flipped = false;
                     _collection_view.scrollEnabled = true;
                     cell.backgroundView.hidden = true;
                     UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:200];
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *documentsDirectory = [paths objectAtIndex:0];
                     NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aProducto.get_nombreImagen_producto]];
                     imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
                 }
                 ];
            }
        }
    }
//    [self.yourTextView setContentOffset:CGPointZero animated:NO];

    
}// END TAPP ANYWHERE


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// COLLECTION VIEW DATA SOURCE METHODS

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag == 0) {
        return arrayOfProducto.count;
    }else{
        return arrayOfCategoria.count;
    }
    
}// END NUMBER OF ITEMS IN SECTION


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    if (collectionView.tag == 0) {
        
    // COLLECTION VIEW PRODUCTOS
    /////////////////////////////////////////////////////////// FRONT VIEW
    
    // AGARRAR INDEX PATH DE CADA CELDA
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // 0. CREAR OBJETO DE PRODUCTO
    Producto *aProducto = [arrayOfProducto objectAtIndex:indexPath.row];
   
    // 1. PONER PALABRA CLAVE EN LABEL
    UILabel *label_nombre_producto = (UILabel *)[cell viewWithTag:25];
    NSString *label_semifinal = [NSString stringWithFormat:@"%@", aProducto.get_nombre_producto];
    NSString *label_final = [label_semifinal uppercaseString];
    label_nombre_producto.text = label_final;
    
    
    // 2. PONER PALABRA CLAVE EN LABEL
    UILabel *label_palabra_clave = (UILabel *)[cell viewWithTag:50];
    NSString *semifinal = [NSString stringWithFormat:@"%@", aProducto.get_palabraClave_producto];
    NSString *final = [semifinal uppercaseString];
    label_palabra_clave.text = final;
        
    
    // 3. PONER IMAGENES
    UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:200];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aProducto.get_nombreImagen_producto]];
    imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];

    // 4. PONER BORDES
    cell.backgroundColor = [UIColor whiteColor];
    //cell.layer.cornerRadius = 8.0f;
    cell.contentView.layer.borderWidth = 0.5f;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    /////////////////////////////////////////////////////////// BACK VIEW
    // 0. PONER TEXTVIEW DESCRIPCION
    UIView *backView = [UIView new];
    
    CGFloat anchos = cell.bounds.size.width - 20.0;
    CGFloat altos = cell.bounds.size.height - 40.0;
    
    textview_descripcion = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, anchos, altos)];
    [textview_descripcion setTag:125];
    [textview_descripcion setTextColor:[UIColor darkGrayColor]];
    [textview_descripcion setBackgroundColor:[UIColor whiteColor]];
    [textview_descripcion setText:aProducto.get_descripcion_producto];
    [textview_descripcion setScrollEnabled:YES];
    [textview_descripcion setEditable:NO];
    [textview_descripcion setFont:[UIFont fontWithName: @"SFUIDisplay-Ultralight" size: 25.0f]];
    
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 0.5f;
    backView.layer.borderColor = [UIColor whiteColor].CGColor;

    [backView addSubview:textview_descripcion];
    cell.backgroundView = backView;
    cell.backgroundView.hidden = true;
    
    // 1. PONER LABEL PRECIO
    CGFloat anchosLabel = cell.bounds.size.width;
    CGFloat altosLabel = cell.bounds.size.height - 55.0;
    
    UILabel *label_precio = [[UILabel alloc] initWithFrame:CGRectMake(0, altosLabel+22, anchosLabel, 33)];
    
    label_precio.backgroundColor = [UIColor whiteColor];
    label_precio.textAlignment = NSTextAlignmentCenter;
    label_precio.textColor = [UIColor darkGrayColor];
    [label_precio setFont:[UIFont fontWithName: @"SFUIDisplay-Ultralight" size: 25.0f]];
    label_precio.numberOfLines = 1;
    label_precio.text = aProducto.get_precio_producto;
    [backView addSubview:label_precio];
    
    
    return cell;
        
    }else{
        // COLLECTION VIEW CATEGORIAS
        /////////////////////////////////////////////////////////// FRONT VIEW
        
        // AGARRAR INDEX PATH DE CADA CELDA
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        // 0. CREAR OBJETO DE PRODUCTO
        Categoria *aCategoria = [arrayOfCategoria objectAtIndex:indexPath.row];
        
        // 1. PONER PALABRA CLAVE EN LABEL
        UILabel *label_nombre_categoria = (UILabel *)[cell viewWithTag:25];
        NSString *label_nombre_categoria_semifinal = [NSString stringWithFormat:@"%@", aCategoria.get_nombre_categoria];
        NSString *label_nombre_categoria_final = [label_nombre_categoria_semifinal uppercaseString];
        label_nombre_categoria.text = label_nombre_categoria_final;
        
        // 2. PONER IMAGENES
        UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:100];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aCategoria.get_nombreImagen_categoria]];
        imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
        
        // 4. PONER BORDES
        cell.backgroundColor = [UIColor whiteColor];
        //cell.layer.cornerRadius = 8.0f;
        cell.contentView.layer.borderWidth = 0.5f;
        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        
        return cell;

    }

}// END CELL AT INDEX PATH

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// COLLECTION VIEW RE ORGANIZABLE


// LONG PRESS PARA RE ORDENAR
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if (![nombre_categoria_seleccionado isEqualToString:@"Todos"]) {
        
    
    
    CGPoint location = [gestureRecognizer locationInView: self.collection_view];
    NSIndexPath *indexPath = [self.collection_view indexPathForItemAtPoint: location];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.collection_view beginInteractiveMovementForItemAtIndexPath: indexPath];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.collection_view updateInteractiveMovementTargetPosition: [gestureRecognizer locationInView: gestureRecognizer.view]];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.collection_view endInteractiveMovement];
            break;
            
        default:
            [self.collection_view cancelInteractiveMovement];
            break;
    }
   
    }// END CATEGORIA NO ES GENERAL

}// END LONG PRESS PARA RE ORDENAR


// MOVER CELDAS
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}// END CAN MOVE ITEM

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{

    index_origen = sourceIndexPath;
    index_fin = destinationIndexPath;

    [self reestablecerCollectionview];
    
   
    
}// END MOVE ITEM AT INDEXPATH

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//GUARDAR DATOS EN NUEVO ORDEN

// METODO QUE PONE EL SQLITE EN ORDEN
- (void)reestablecerCollectionview{
    
    if ([nombre_categoria_seleccionado isEqualToString:@"Todos"]) {
      
    // SI ESTAS EDITANDO EN GENERAL CAMBIAS TODO, SINO SOLO CAMBIAS LODE TU CATEGORIA
    if (arrayOfProducto.count != 0) {
        
    
    Producto *pOrigen = [[Producto alloc]init];
    
    // COPIAR ARREGLOS
    for (int ic = 0; ic < arrayOfProducto.count; ic++) {
        arrayOfProductoTemporal[ic] = arrayOfProducto[ic];

    }

    int origen = (int)index_origen.row;
    int final = (int)index_fin.row;

    if (origen > final) {

        pOrigen = arrayOfProducto[origen];
        arrayOfProductoTemporal[final] = pOrigen;
        
        for (int ia = final, ic = final+1; ic <= origen; ic++, ia++) {

            arrayOfProductoTemporal[ic] = arrayOfProducto[ia];
        }
        
    }else{

        pOrigen = arrayOfProducto[origen];
        arrayOfProductoTemporal[final] = pOrigen;
        
        for (int ia = origen, ic = origen+1; ic <= final; ic++, ia++) {
            
            arrayOfProductoTemporal[ia] = arrayOfProducto[ic];
        }

    }// END IF ELSE
    
    
    [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM PRODUCTOS"]];
    
    NSString *string_nombre;
    NSString *string_palabra_clave;
    NSString *string_descripcion;
    NSString *string_precio;
    NSString *string_nombre_imagen;
    NSString *string_categoria;
    
    for (int ic = 0; ic < arrayOfProductoTemporal.count; ic++) {
        
       Producto *p= [[Producto alloc]init];
        p = arrayOfProductoTemporal[ic];
        string_nombre = p.get_nombre_producto;
        string_palabra_clave = p.get_palabraClave_producto;
        string_descripcion = p.get_descripcion_producto;
        string_precio = p.get_precio_producto;
        string_nombre_imagen = p.get_nombreImagen_producto;
        string_categoria = p.get_categoria_producto;
        char *error;
        
        if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
            NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PRODUCTOS (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, CATEGORIA) values ('%@','%@','%@','%@','%@', '%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, string_categoria];
            
            const char *insert_stmt = [insertStmt UTF8String];
            
            if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            }
        }
        
    }// END FOR
    [self actualizarArregloCollectionView];
    }else{
        [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM PRODUCTOS"]];
        [arrayOfProductoTemporal removeAllObjects];
        [arrayOfProducto removeAllObjects];
    }
    
    
    }// END CATEGORIA GENERAL
    // EMPIEZA CATEGORIA DIFERENTE
    else{
        if (arrayOfProducto.count != 0) {
            
            
            Producto *pOrigen = [[Producto alloc]init];
            
            // COPIAR ARREGLOS
            for (int ic = 0; ic < arrayOfProducto.count; ic++) {
                arrayOfProductoTemporal[ic] = arrayOfProducto[ic];
                
            }
            
            int origen = (int)index_origen.row;
            int final = (int)index_fin.row;
            
            if (origen > final) {
                
                pOrigen = arrayOfProducto[origen];
                arrayOfProductoTemporal[final] = pOrigen;
                
                for (int ia = final, ic = final+1; ic <= origen; ic++, ia++) {
                    
                    arrayOfProductoTemporal[ic] = arrayOfProducto[ia];
                }
                
            }else{
                
                pOrigen = arrayOfProducto[origen];
                arrayOfProductoTemporal[final] = pOrigen;
                
                for (int ia = origen, ic = origen+1; ic <= final; ic++, ia++) {
                    
                    arrayOfProductoTemporal[ia] = arrayOfProducto[ic];
                }
                
            }// END IF ELSE
            
            
            [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM PRODUCTOS WHERE CATEGORIA = '%@'", nombre_categoria_seleccionado]];
            
            NSString *string_nombre;
            NSString *string_palabra_clave;
            NSString *string_descripcion;
            NSString *string_precio;
            NSString *string_nombre_imagen;
            NSString *string_categoria;
            
            for (int ic = 0; ic < arrayOfProductoTemporal.count; ic++) {
                
                Producto *p= [[Producto alloc]init];
                p = arrayOfProductoTemporal[ic];
                string_nombre = p.get_nombre_producto;
                string_palabra_clave = p.get_palabraClave_producto;
                string_descripcion = p.get_descripcion_producto;
                string_precio = p.get_precio_producto;
                string_nombre_imagen = p.get_nombreImagen_producto;
                string_categoria = p.get_categoria_producto;
                char *error;
                
                if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
                    NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PRODUCTOS (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, CATEGORIA) values ('%@','%@','%@','%@','%@', '%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, string_categoria];
                    
                    const char *insert_stmt = [insertStmt UTF8String];
                    
                    if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
                    }
                }
                
            }// END FOR
            [self actualizarDirectoCategoria];
        }else{
            [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM PRODUCTOS WHERE CATEGORIA = '%@'", nombre_categoria_seleccionado]];
            [arrayOfProductoTemporal removeAllObjects];
            [arrayOfProducto removeAllObjects];
        }

        
        
    }// END CATEGORIA DIFERENTE
    
    
    
}// END REESTABLECER

//// BORRAR TODO SQLITE
-(void)deleteDataTodosProductos:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_exec(productos, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
    }
    
//    [[self collection_view]reloadData];
}


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PONER INFORMACION DE SQLITE EN ARREGLO PARA EL COLLECTION VIEW

// METODO QUE ACTUALIZA EL ARREGLO PARA EL COLLECTION VIEW CON VALORES DE SQLITE
-(void)actualizarArregloCollectionView{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"productos.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        
        [arrayOfProducto removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PRODUCTOS"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_nombre_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_palabra_clave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *columna_precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *columna_descripcion = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *columna_nombre_imagen = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *columna_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];


                // PONER DATOS EN OBJETO
                Producto *producto = [[Producto alloc]init];
                [producto set_nombre_producto:columna_nombre_producto];
                [producto set_palabraClave_producto:columna_palabra_clave];
                [producto set_precio_producto:columna_precio];
                [producto set_descripcion_producto:columna_descripcion];
                [producto set_nombreImagen_producto:columna_nombre_imagen];
                [producto set_categoria_producto:columna_categoria];
                
                [arrayOfProducto addObject:producto];
            }
        }
        
        [[self collection_view]reloadData];
        
    }// END IF SQLITE OPEN
    
    
}// END ACTUALIZAR COLLECTION VIEW

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACTUALIZAR ARREGLO CATEGORIAS

// METODO QUE ACTUALIZA EL ARREGLO PARA EL COLLECTION VIEW CON VALORES DE SQLITE
-(void)actualizarArregloCollectionViewCategorias{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"categorias.db"];
    
    dbPathString_categorias = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_categorias UTF8String], &categorias)==SQLITE_OK) {
        
        [arrayOfCategoria removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CATEGORIAS"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(categorias, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_id_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_nombre_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_nombre_imagen = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                // PONER DATOS EN OBJETO
                Categoria *categoria = [[Categoria alloc]init];
                [categoria set_id_categoria:columna_id_categoria];
                [categoria set_nombre_categoria:columna_nombre_categoria];
                [categoria set_nombreImagen_categoria:columna_nombre_imagen];
                
                [arrayOfCategoria addObject:categoria];
            }
        }
        
        [[self collection_view_categorias]reloadData];
        
    }// END IF SQLITE OPEN
    
    
}// END ACTUALIZAR COLLECTION VIEW

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// REESTABLECER DESPUES DE HABER BORRADO
- (void)reestablecerDespuesDeBorrado{
    
    
    if ([nombre_categoria_seleccionado isEqualToString:@"Todos"]) {
        
    [arrayOfProductoTemporal removeAllObjects];
    
    // COPIAR ARREGLOS
    for (int ic = 0; ic < arrayOfProducto.count; ic++) {
        arrayOfProductoTemporal[ic] = arrayOfProducto[ic];
        
    }
    
    [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM PRODUCTOS"]];
    
    NSString *string_nombre;
    NSString *string_palabra_clave;
    NSString *string_descripcion;
    NSString *string_precio;
    NSString *string_nombre_imagen;
    NSString *string_categoria;
    
    for (int ic = 0; ic < arrayOfProductoTemporal.count; ic++) {
        
        Producto *p= [[Producto alloc]init];
        p = arrayOfProductoTemporal[ic];
        string_nombre = p.get_nombre_producto;
        string_palabra_clave = p.get_palabraClave_producto;
        string_descripcion = p.get_descripcion_producto;
        string_precio = p.get_precio_producto;
        string_nombre_imagen = p.get_nombreImagen_producto;
        string_categoria = p.get_categoria_producto;
        char *error;
        
        if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
            NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PRODUCTOS (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, CATEGORIA) values ('%@','%@','%@','%@','%@', '%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, string_categoria];
            
            const char *insert_stmt = [insertStmt UTF8String];
            
            if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            }
        }
    }
    [self actualizarArregloCollectionView];
    }// END CATEGORIA GENERAL
    // EMPIEZA CATEGORIA DIFERENTE
    else{
        
        [arrayOfProductoTemporal removeAllObjects];
        
        // COPIAR ARREGLOS
        for (int ic = 0; ic < arrayOfProducto.count; ic++) {
            arrayOfProductoTemporal[ic] = arrayOfProducto[ic];
            
        }
        
        [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM PRODUCTOS WHERE CATEGORIA = '%@'", nombre_categoria_seleccionado]];
        
        NSString *string_nombre;
        NSString *string_palabra_clave;
        NSString *string_descripcion;
        NSString *string_precio;
        NSString *string_nombre_imagen;
        NSString *string_categoria;
        
        for (int ic = 0; ic < arrayOfProductoTemporal.count; ic++) {
            
            Producto *p= [[Producto alloc]init];
            p = arrayOfProductoTemporal[ic];
            string_nombre = p.get_nombre_producto;
            string_palabra_clave = p.get_palabraClave_producto;
            string_descripcion = p.get_descripcion_producto;
            string_precio = p.get_precio_producto;
            string_nombre_imagen = p.get_nombreImagen_producto;
            string_categoria = p.get_categoria_producto;
            char *error;
            
            if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
                NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PRODUCTOS (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, CATEGORIA) values ('%@','%@','%@','%@','%@', '%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, string_categoria];
                
                const char *insert_stmt = [insertStmt UTF8String];
                
                if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
                }
            }
        }
        [self actualizarDirectoCategoria];
        
    }// END CATEGORIA DIFERENTE
    
    
}// END REESTABLECER DESPUES DE BORRADO


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// DOUBLE TAPP TO DELETE
- (void) processDoubleTap:(UITapGestureRecognizer *)sender{
    
//    if (![nombre_categoria_seleccionado isEqualToString:@"Todos"]) {

    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint point = [sender locationInView:_collection_view];
        indexPath_cell_flipped = [_collection_view indexPathForItemAtPoint:point];
        NSIndexPath *indexPath = [_collection_view indexPathForItemAtPoint:point];
    
        [self removeItemAtIndex:indexPath];

    }
//    }// END IF CATEGORIA NO ES GENERAL
}

-(void)removeItemAtIndex:(NSIndexPath *)index {
    
    // BORRAR DE: ARREGLO, COLLECTION GRAFICO, SQLITE, IMAGEN
    
    Producto *p = [arrayOfProducto objectAtIndex:indexPath_cell_flipped.row];
    
    NSString *imagen_borrar = [NSString stringWithFormat:@"%s", [p.get_nombreImagen_producto UTF8String]];
    [self removeImage:imagen_borrar];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM PRODUCTOS WHERE ID = '%s'", [p.get_id_producto UTF8String]];
    char *error;
    
    if (sqlite3_exec(productos, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
        [arrayOfProducto removeObjectAtIndex:index.row];


        [self.collection_view deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.item inSection:0]]]; // update the interface
        [_collection_view reloadData];
        [self reestablecerDespuesDeBorrado];
        
    }
    
    
}// END BORRAR ITEM

- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    
}// END BORRAR IMAGEN

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//ACTUALIZAR SI VIENES DE UN REAJUSTE DIRECTO EN CATEGORIA

- (void)actualizarDirectoCategoria{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"productos.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        
        [arrayOfProducto removeAllObjects];
        NSString *querySql;
        if ([nombre_categoria_seleccionado isEqualToString:@"Todos"]) {
            querySql = [NSString stringWithFormat:@"SELECT * FROM PRODUCTOS"];
        }else{
            querySql = [NSString stringWithFormat:@"SELECT * FROM PRODUCTOS WHERE CATEGORIA = '%@'", nombre_categoria_seleccionado];
        }
        
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_nombre_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_palabra_clave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *columna_precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *columna_descripcion = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *columna_nombre_imagen = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *columna_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                
                // PONER DATOS EN OBJETO
                Producto *producto = [[Producto alloc]init];
                [producto set_nombre_producto:columna_nombre_producto];
                [producto set_palabraClave_producto:columna_palabra_clave];
                [producto set_precio_producto:columna_precio];
                [producto set_descripcion_producto:columna_descripcion];
                [producto set_nombreImagen_producto:columna_nombre_imagen];
                [producto set_categoria_producto:columna_categoria];
                
                [arrayOfProducto addObject:producto];
            }
        }
        
        [[self collection_view]reloadData];
        
    }// END IF SQLITE OPEN

    
    
}// END ACTUALIZAR DIRECTO EN CATEGORIA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SINGLE TAPP PARA FILTRAR PRODUCTOS

- (void) singleTapCategoria:(UITapGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        if (!cell_is_flipped) {
            
        
        
        //////////////////////////////////////////////////////////// ESCOGER NOMBRE DE CATEGORIA
        CGPoint point = [sender locationInView:_collection_view_categorias];
        NSIndexPath *indexPath_categoria = [_collection_view_categorias indexPathForItemAtPoint:point];
        
        Categoria *c = [[Categoria alloc]init];
        c = [arrayOfCategoria objectAtIndex:indexPath_categoria.row];
        nombre_categoria_seleccionado = c.get_nombre_categoria;
        
        
        
        //////////////////////////////////////////////////////////// FILTRAR POR ESA CATEGORIA
        
        // PATH BASE DE DATOS
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [path objectAtIndex:0];
        
        NSString *path_con_nombre_variable = [NSString stringWithFormat:@"productos.db"];
        
        dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
        
        sqlite3_stmt *statement;
        
        // ABRIR BASE DE DATOS
        if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
            
            [arrayOfProducto removeAllObjects];
            NSString *querySql;
            if ([nombre_categoria_seleccionado isEqualToString:@"Todos"]) {
                querySql = [NSString stringWithFormat:@"SELECT * FROM PRODUCTOS"];
            }else{
            querySql = [NSString stringWithFormat:@"SELECT * FROM PRODUCTOS WHERE CATEGORIA = '%@'", nombre_categoria_seleccionado];
            }
                
                const char* query_sql = [querySql UTF8String];
            
            // AGARRAR DATOS
            if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                    NSString *columna_nombre_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *columna_palabra_clave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *columna_precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *columna_descripcion = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *columna_nombre_imagen = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    NSString *columna_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    
                    
                    // PONER DATOS EN OBJETO
                    Producto *producto = [[Producto alloc]init];
                    [producto set_nombre_producto:columna_nombre_producto];
                    [producto set_palabraClave_producto:columna_palabra_clave];
                    [producto set_precio_producto:columna_precio];
                    [producto set_descripcion_producto:columna_descripcion];
                    [producto set_nombreImagen_producto:columna_nombre_imagen];
                    [producto set_categoria_producto:columna_categoria];
                    
                    [arrayOfProducto addObject:producto];
                }
            }
            
            [[self collection_view]reloadData];
            
        }// END IF SQLITE OPEN

        
        
        }// END CELL IS FLIPPED
        
    }
}// END SINGLE TAP CATEGORIA


@end
