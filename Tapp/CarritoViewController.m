//
//  CarritoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CarritoViewController.h"

@interface CarritoViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    
   
    // ARREGLO DONDE VOY A PONER LA INFO PARA EL COLLECTION PRODUCTOS
    NSMutableArray *arrayOfProducto;
    NSMutableArray *arrayOfProductoTemporal;


 
    // VARIABLE QUE GUARDA INDEXPATH DE SWIPE
    NSIndexPath *indexPath_cell_flipped;


    
}// END INTERFACE

@end

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// VARIABLES GLOBALES

BOOL cell_flipped_for_transition_carrito;
int contador_carrito;
BOOL cell_is_flipped_carrito;
BOOL left_or_right_carrito = true; // true left, right false

UITextView *textview_descripcion_carrito;


@implementation CarritoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. INICIALIZAR ARREGLO
    [self inicializaciones];
    
    // 3. ACTUALIZAR ARREGLO COLEECTION PRODUCTOS
    [self actualizarArregloCollectionView];
    
    // 5. AGREGAR GESTURES A COLLECTIONVIEW
    [self addGesturesCollection];
    
    // 6. PONER VENDEDOR ACTUAL EN LABEL
    [self ponerActualLabel];


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
    _swipe_left.numberOfTouchesRequired = 2;
    
    
}// END CONFIGURAR SWIPE


- (IBAction)accion_swipe_right:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];
}

- (IBAction)accion_swipe_left:(id)sender {
    
    [self performSegueWithIdentifier: @"left" sender: self];
    
}


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

 
    // COLLECTION VIEW PRODUCTOS
    self.collection_view_carrito.dataSource = self;
    self.collection_view_carrito.delegate = self;
    _collection_view_carrito.showsVerticalScrollIndicator = false;
    _collection_view_carrito.backgroundColor = [UIColor clearColor];
    
    // BOOLS
    cell_is_flipped_carrito= false;
    cell_flipped_for_transition_carrito = false;
    
    
}// END INICIALIZAR ARREGLO Y COLLECTION

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
    [self.collection_view_carrito addGestureRecognizer:swipeGestureRecognizer];
    
    // SWIPE RIGHT
    UISwipeGestureRecognizer* swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToFlipGestureRight:)];
    swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collection_view_carrito addGestureRecognizer:swipeGestureRecognizerRight];
    
    // SINGLE TAP PARA REGRESAR CELDA
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
    
    
    // DOUBLE TAPP
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    [self.collection_view_carrito addGestureRecognizer:doubleTapFolderGesture];
    
  
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
        left_or_right_carrito = true;
        
        CGPoint point = [sender locationInView:_collection_view_carrito];
        
        if (!cell_is_flipped_carrito) {
            
            indexPath_cell_flipped = [self.collection_view_carrito indexPathForItemAtPoint:point];
            cell_is_flipped_carrito = true;
            
            if (!cell_flipped_for_transition_carrito) {
                UICollectionViewCell* cell = [self.collection_view_carrito cellForItemAtIndexPath:indexPath_cell_flipped];
                
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
                     cell_flipped_for_transition_carrito = true;
                     _collection_view_carrito.scrollEnabled = false;
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
        
        left_or_right_carrito = false;
        
        CGPoint point = [sender locationInView:_collection_view_carrito];
        
        if (!cell_is_flipped_carrito) {
            
            indexPath_cell_flipped = [self.collection_view_carrito indexPathForItemAtPoint:point];
            cell_is_flipped_carrito = true;
            
            if (!cell_flipped_for_transition_carrito) {
                UICollectionViewCell* cell = [self.collection_view_carrito cellForItemAtIndexPath:indexPath_cell_flipped];
                
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
                     cell_flipped_for_transition_carrito = true;
                     _collection_view_carrito.scrollEnabled = false;
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
    
    if (cell_is_flipped_carrito) {
        if (cell_flipped_for_transition_carrito) {
            
            if (left_or_right_carrito) {
                
                UICollectionViewCell* cell = [self.collection_view_carrito cellForItemAtIndexPath:indexPath_cell_flipped];
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
                     cell_flipped_for_transition_carrito = false;
                     cell_is_flipped_carrito = false;
                     _collection_view_carrito.scrollEnabled = true;
                     cell.backgroundView.hidden = true;
                     UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:200];
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                     NSString *documentsDirectory = [paths objectAtIndex:0];
                     NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aProducto.get_nombreImagen_producto]];
                     imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
                 }
                 ];
            }else{
                
                UICollectionViewCell* cell = [self.collection_view_carrito cellForItemAtIndexPath:indexPath_cell_flipped];
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
                     cell_flipped_for_transition_carrito = false;
                     cell_is_flipped_carrito = false;
                     _collection_view_carrito.scrollEnabled = true;
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
    
    return arrayOfProducto.count;
   
}// END NUMBER OF ITEMS IN SECTION


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
   
        /////////////////////////////////////////////////////////// FRONT VIEW
        
        // AGARRAR INDEX PATH DE CADA CELDA
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        // 0. CREAR OBJETO DE PRODUCTO
        Producto *aProducto = [arrayOfProducto objectAtIndex:indexPath.row];
        
        // 1. PONER PALABRA CLAVE EN LABEL
        UILabel *label_nombre_producto = (UILabel *)[cell viewWithTag:25];
        NSString *nombreSemifinal = [NSString stringWithFormat:@"%@", aProducto.get_nombre_producto];
        NSString *nombre_final = [nombreSemifinal uppercaseString];
        label_nombre_producto.text = nombre_final;
    
        
        // 2. PONER PALABRA CLAVE EN LABEL
        UILabel *label_palabra_clave = (UILabel *)[cell viewWithTag:50];
        NSString *palabra_clave_semifinal = [NSString stringWithFormat:@"%@", aProducto.get_palabraClave_producto];
        NSString *palabra_clave_final = [palabra_clave_semifinal uppercaseString];
        label_palabra_clave.text = palabra_clave_final;

        // 3. PONER IMAGENES
        UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:200];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aProducto.get_nombreImagen_producto]];
        imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
        
        // 4. PONER BORDES
//        cell.backgroundColor = [UIColor clearColor];
        //cell.layer.cornerRadius = 8.0f;
        cell.contentView.layer.borderWidth = 0.5f;
        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    
        // 5. PONER CUENTA
        UILabel *label_cuenta = (UILabel *)[cell viewWithTag:75];
        NSString *cuenta_semifinal = [NSString stringWithFormat:@"x %@", aProducto.get_cuenta_producto];
        NSString *cuenta_final = [cuenta_semifinal uppercaseString];
        label_cuenta.text = cuenta_final;

    
        /////////////////////////////////////////////////////////// BACK VIEW
        // 0. PONER TEXTVIEW DESCRIPCION
        UIView *backView = [UIView new];
        
        CGFloat anchos = cell.bounds.size.width - 20.0;
        CGFloat altos = cell.bounds.size.height - 40.0;
        
        textview_descripcion_carrito = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, anchos, altos)];
        [textview_descripcion_carrito setTag:125];
        [textview_descripcion_carrito setTextColor:[UIColor blackColor]];
        [textview_descripcion_carrito setBackgroundColor:[UIColor clearColor]];
        [textview_descripcion_carrito setText:aProducto.get_descripcion_producto];
        [textview_descripcion_carrito setScrollEnabled:YES];
        [textview_descripcion_carrito setEditable:NO];
        [textview_descripcion_carrito setFont:[UIFont fontWithName: @"SFUIDisplay-Ultralight" size: 25.0f]];
        
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderWidth = 0.5f;
        backView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [backView addSubview:textview_descripcion_carrito];
        cell.backgroundView = backView;
        cell.backgroundView.hidden = true;
        
        // 1. PONER LABEL PRECIO
        CGFloat anchosLabel = cell.bounds.size.width;
        CGFloat altosLabel = cell.bounds.size.height - 55.0;
        
        UILabel *label_precio = [[UILabel alloc] initWithFrame:CGRectMake(0, altosLabel+22, anchosLabel, 33)];
        
        label_precio.backgroundColor = [UIColor clearColor];
        label_precio.textAlignment = NSTextAlignmentCenter;
        label_precio.textColor = [UIColor blackColor];
        [label_precio setFont:[UIFont fontWithName: @"SFUIDisplay-Ultralight" size: 25.0f]];
        label_precio.numberOfLines = 1;
        label_precio.text = aProducto.get_precio_producto;
        [backView addSubview:label_precio];
        
        
        return cell;
        
    
}// END CELL AT INDEX PATH

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
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        
        [arrayOfProducto removeAllObjects];
        
//        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CARRITO ORDER BY NOMBRE"];
        NSString *querySql = [NSString stringWithFormat:@"SELECT ID, NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, STATE, COUNT(NOMBRE) AS CUENTA FROM CARRITO GROUP BY NOMBRE, PALABRACLAVE"];

        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_id_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_nombre_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_palabra_clave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *columna_precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *columna_descripcion = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *columna_nombre_imagen = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *columna_cuenta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];

                
                // PONER DATOS EN OBJETO
                Producto *producto = [[Producto alloc]init];
                [producto set_id_producto:columna_id_producto];
                [producto set_nombre_producto:columna_nombre_producto];
                [producto set_palabraClave_producto:columna_palabra_clave];
                [producto set_precio_producto:columna_precio];
                [producto set_descripcion_producto:columna_descripcion];
                [producto set_nombreImagen_producto:columna_nombre_imagen];
                [producto set_cuenta_producto:columna_cuenta];
                
                NSLog(@"ID: %@", columna_id_producto);
                NSLog(@"CUENTA %@", columna_cuenta);
                
                [arrayOfProducto addObject:producto];
            }
        }
        
        [[self collection_view_carrito]reloadData];
        
    }// END IF SQLITE OPEN
    
    
}// END ACTUALIZAR COLLECTION VIEW

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PARA BORRAR DE LA TABLA DE CARRITO

-(void)removeItemAtIndex:(NSIndexPath *)index {
    
    
    // PARA HACER EL DELETE, VOY A TENER QUE RE LLAMAR LA FUNCION DE SQLITE, Y ASEGURARME DE QUE SOLO BORRE DEL ARREGLO
    // PERO QUE VUELVA A LLAMAR PARA POPULAR EL ARREGLO OTRA VEZ, Y QUE EL ID = %S, SOLO BORRE UN RENGLON, NO TODOS...
    // O A LO MEJOR JUGAR CON DOS ARREGLOS... HAY QUE VER
    
    Producto *p = [arrayOfProducto objectAtIndex:index.row];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM CARRITO WHERE ID = '%s'", [p.get_id_producto UTF8String]];
    char *error;
    NSLog(@"ID BORRAR: %s", [p.get_id_producto UTF8String]);
    
    if (sqlite3_exec(productos, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
        
        NSLog(@"- 1");
        // AQUI VA TAMBIEN EL POP DE - 1
        
    }
    
}// END BORRAR ITEM

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// DOUBLE TAPP PARA ELIMINAR DE CARRITO

- (void) processDoubleTap:(UITapGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint point = [sender locationInView:_collection_view_carrito];
        NSIndexPath *indexPath = [_collection_view_carrito indexPathForItemAtPoint:point];
        
        [self removeItemAtIndex:indexPath];
        Producto *p = [arrayOfProducto objectAtIndex:indexPath.row];

        
        NSString *strin_pop = [NSString stringWithFormat:@"- 1 \r %@", p.get_nombre_producto];
        NSString *strin_pop_final = [strin_pop uppercaseString];
        [self.view addSubview: [[Toast alloc] initWithText:strin_pop_final]];

        [self actualizarArregloCollectionView];
//        [arrayOfProducto removeObjectAtIndex:indexPath.row];
//        [self.collection_view_carrito deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:0]]]; // update the interface
//        [_collection_view_carrito reloadData];
//        [self reestablecerDespuesDeBorrado];
      }
    
}// END DOUBLE TAPP AGREGAR A CARRITO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// REESTABLECER DESPUES DE HABER BORRADO
- (void)reestablecerDespuesDeBorrado{
    
    
    
        [arrayOfProductoTemporal removeAllObjects];
        
        // COPIAR ARREGLOS
        for (int ic = 0; ic < arrayOfProducto.count; ic++) {
            arrayOfProductoTemporal[ic] = arrayOfProducto[ic];
            
        }
        
        [self deleteDataTodosProductos:[NSString stringWithFormat:@"DELETE FROM CARRITO"]];
        
        NSString *string_nombre;
        NSString *string_palabra_clave;
        NSString *string_descripcion;
        NSString *string_precio;
        NSString *string_nombre_imagen;
        NSString *string_categoria;
        NSString *string_pending = @"PENDING";
    
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
                NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO CARRITO (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, STATE) values ('%@','%@','%@','%@','%@','%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, string_pending];
                
                const char *insert_stmt = [insertStmt UTF8String];
                
                if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
                }
            }
        }
        [self actualizarArregloCollectionView];

    
}// END REESTABLECER DESPUES DE BORRADO

//// BORRAR TODO SQLITE
-(void)deleteDataTodosProductos:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_exec(productos, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
        [self.view addSubview: [[Toast alloc] initWithText: @"- 1"]];

    }
    
}// END DELETE SQLITE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PONER VENDEDOR ACTUAL EN LABEL

- (void)ponerActualLabel{
    
    NSString *vendedor_traido = [[NSUserDefaults standardUserDefaults] objectForKey:@"vendedor"];
    _label_nombre_vendedor.text = vendedor_traido;
    
    
}// END PONER ACTUAL EN LABEL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

@end
