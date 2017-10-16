//
//  MainCobrarViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 3/10/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MainCobrarViewController.h"


@interface MainCobrarViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    NSString *dbPathString_carrito;
    
    
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

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// VARIABLES GLOBALES

BOOL cell_flipped_for_transition_cobrar;
int contador_cobrar;
BOOL cell_is_flipped_cobrar;
BOOL left_or_right_cobrar = true; // true left, right false

UITextView *textview_descripcion_cobrar;


@implementation MainCobrarViewController

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// VIEWDIDLOAD

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
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
// SWIPE

// METODO QUE CONFIGURAR SWIPE
- (void)configurarSwipe{
    
    _swipe_regresar.numberOfTouchesRequired = 2;
    _swipe_continuar.numberOfTouchesRequired = 2;
    
    
}// END CONFIGURAR SWIPE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCIONES SWIPE

- (IBAction)accion_regresar:(id)sender {
    
    [self performSegueWithIdentifier: @"regresar" sender: self];
    
}

- (IBAction)accion_continuar:(id)sender {
    
    [self performSegueWithIdentifier: @"carrito" sender: self];
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
    arrayOfProductoGroupBy = [[NSMutableArray alloc]init];
    
    
    // ARREGLO PARA SQLITE CATEGORIAS
    arrayOfCategoria = [[NSMutableArray alloc]init];
    arrayOfCategoriaTemporal = [[NSMutableArray alloc]init];
    
    // COLLECTION VIEW PRODUCTOS
    self.collection_view.dataSource = self;
    self.collection_view.delegate = self;
    _collection_view.showsVerticalScrollIndicator = false;
    _collection_view.backgroundColor = [UIColor clearColor];
    
    // COLLECTION VIEW PRODUCTOS
    self.collection_view_categorias.dataSource = self;
    self.collection_view_categorias.delegate = self;
    _collection_view_categorias.showsHorizontalScrollIndicator = false;
    _collection_view_categorias.backgroundColor = [UIColor clearColor];
    
    // BOOLS
    cell_is_flipped_cobrar = false;
    cell_flipped_for_transition_cobrar = false;
    
    // ARRANCAR STRING DE CATEGORIA EN GENERAL
    nombre_categoria_seleccionado = @"Todos";
    
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
    [self.collection_view addGestureRecognizer:swipeGestureRecognizer];
    
    // SWIPE RIGHT
    UISwipeGestureRecognizer* swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToFlipGestureRight:)];
    swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collection_view addGestureRecognizer:swipeGestureRecognizerRight];
    
    // SINGLE TAP PARA REGRESAR CELDA
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    [self.view addGestureRecognizer:tap];
    
    
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
        left_or_right_cobrar = true;
        
        CGPoint point = [sender locationInView:_collection_view];
        
        if (!cell_is_flipped_cobrar) {
            
            indexPath_cell_flipped = [self.collection_view indexPathForItemAtPoint:point];
            cell_is_flipped_cobrar = true;
            
            if (!cell_flipped_for_transition_cobrar) {
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
                     cell_flipped_for_transition_cobrar = true;
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
        
        left_or_right_cobrar = false;
        
        CGPoint point = [sender locationInView:_collection_view];
        
        if (!cell_is_flipped_cobrar) {
            
            indexPath_cell_flipped = [self.collection_view indexPathForItemAtPoint:point];
            cell_is_flipped_cobrar = true;
            
            if (!cell_flipped_for_transition_cobrar) {
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
                     cell_flipped_for_transition_cobrar = true;
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
    
    if (cell_is_flipped_cobrar) {
        if (cell_flipped_for_transition_cobrar) {
            
            if (left_or_right_cobrar) {
                
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
                     cell_flipped_for_transition_cobrar = false;
                     cell_is_flipped_cobrar = false;
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
                     cell_flipped_for_transition_cobrar = false;
                     cell_is_flipped_cobrar = false;
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
        
        // 1. PONER NOMBRE PRODUCOT EN LABEL
        UILabel *label_nombre_producto = (UILabel *)[cell viewWithTag:25];
        NSString *nombre_semifinal = [NSString stringWithFormat:@"%@", aProducto.get_nombre_producto];
        NSString *nombre_final = [nombre_semifinal uppercaseString];
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
        cell.backgroundColor = [UIColor whiteColor];
        //cell.layer.cornerRadius = 8.0f;
//        cell.contentView.layer.borderWidth = 0.5f;
//        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        /////////////////////////////////////////////////////////// BACK VIEW
        // 0. PONER TEXTVIEW DESCRIPCION
        UIView *backView = [UIView new];
        
        CGFloat anchos = cell.bounds.size.width - 20.0;
        CGFloat altos = cell.bounds.size.height - 40.0;
        
        textview_descripcion_cobrar = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, anchos, altos)];
        [textview_descripcion_cobrar setTag:125];
        [textview_descripcion_cobrar setTextColor:[UIColor blackColor]];
        [textview_descripcion_cobrar setBackgroundColor:[UIColor whiteColor]];
        [textview_descripcion_cobrar setText:aProducto.get_descripcion_producto];
        [textview_descripcion_cobrar setScrollEnabled:YES];
        [textview_descripcion_cobrar setEditable:NO];
        [textview_descripcion_cobrar setFont:[UIFont fontWithName: @"SFUIDisplay-Ultralight" size: 25.0f]];
        
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.borderWidth = 0.5f;
        backView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [backView addSubview:textview_descripcion_cobrar];
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
        
    }else{
        // COLLECTION VIEW CATEGORIAS
        /////////////////////////////////////////////////////////// FRONT VIEW
        
        // AGARRAR INDEX PATH DE CADA CELDA
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        // 0. CREAR OBJETO DE PRODUCTO
        Categoria *aCategoria = [arrayOfCategoria objectAtIndex:indexPath.row];
        
        // 1. PONER PALABRA CLAVE EN LABEL
        UILabel *label_nombre_categoria = (UILabel *)[cell viewWithTag:25];
        NSString *nombre_categoria_semifinal = [NSString stringWithFormat:@"%@", aCategoria.get_nombre_categoria];
        NSString *nombre_categoria_final = [nombre_categoria_semifinal uppercaseString];
        label_nombre_categoria.text = nombre_categoria_final;
        
        // 2. PONER IMAGENES
        UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:100];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aCategoria.get_nombreImagen_categoria]];
        imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
        
        // 4. PONER BORDES
        cell.backgroundColor = [UIColor colorWithRed:(84/255.0) green:(90/255.0) blue:(102/255.0) alpha:1];//#545A66 84, 90, 102
        //cell.layer.cornerRadius = 8.0f;
//        cell.contentView.layer.borderWidth = 0.5f;
//        cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        
        return cell;
        
    }
    
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
// PONER INFORMACION DE SQLITE EN ARREGLO PARA EL COLLECTION VIEW CATEGORIAS

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
// SINGLE TAPP PARA FILTRAR PRODUCTOS

- (void) singleTapCategoria:(UITapGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        
        if (!cell_is_flipped_cobrar) {
            
        
        
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

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// DOUBLE TAPP PARA AGREGAR A CARRITO

- (void) processDoubleTap:(UITapGestureRecognizer *)sender{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
    
    dbPathString_carrito = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint point = [sender locationInView:_collection_view];
        indexPath_cell_flipped = [_collection_view indexPathForItemAtPoint:point];
        NSIndexPath *indexPath = [_collection_view indexPathForItemAtPoint:point];
        
        NSString *string_nombre;
        NSString *string_palabra_clave;
        NSString *string_descripcion;
        NSString *string_precio;
        NSString *string_nombre_imagen;
        NSString *string_pending = @"PENDING";
        
        Producto *p= [[Producto alloc]init];
        p = arrayOfProducto[indexPath.row];
        string_nombre = p.get_nombre_producto;
        string_palabra_clave = p.get_palabraClave_producto;
        string_descripcion = p.get_descripcion_producto;
        string_precio = p.get_precio_producto;
        string_nombre_imagen = p.get_nombreImagen_producto;
        
        char *error;
        
        if (sqlite3_open([dbPathString_carrito UTF8String], &productos)==SQLITE_OK) {
            NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO CARRITO (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, STATE) values ('%@','%@','%@','%@','%@', '%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, string_pending];
            
            const char *insert_stmt = [insertStmt UTF8String];
            
            if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
                
                // HACER EL POP DE + 1
                NSString *strin_pop = [NSString stringWithFormat:@"+ 1 \r %@", string_nombre];
                NSString *strin_pop_final = [strin_pop uppercaseString];
                [self.view addSubview: [[Toast alloc] initWithText:strin_pop_final]];
                
            }
        }
    }
    
}// END DOUBLE TAPP AGREGAR A CARRITO

@end
