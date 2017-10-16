//
//  MainCategoriasViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/4/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MainCategoriasViewController.h"


@interface MainCategoriasViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *censos;
    NSString *dbPathString;
    
    // ARREGLO DONDE VOY A PONER LA INFO PARA EL TABLEVIEW
    NSMutableArray *arrayOfCategoria;
    NSMutableArray *arrayOfCategoriaTemporal;
    
    
    // VARIABLE QUE GUARDA INDEXPATH DE SWIPE
    NSIndexPath *indexPath_cell_flipped;
    
    NSIndexPath *index_origen;
    NSIndexPath *index_fin;
    
}// END INTERFACE


@end

@implementation MainCategoriasViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1. CONFIGURAR SWIPES
    [self configurarSwipe];
    
    // 2. INICIALIZAR ARREGLO
    [self inicializaciones];
    
    // 3. ACTUALIZAR ARREGLO COLEECTION
    [self actualizarArregloCollectionView];
    
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
    
    // ARREGLO PARA SQLITE
    arrayOfCategoria = [[NSMutableArray alloc]init];
    arrayOfCategoriaTemporal = [[NSMutableArray alloc]init];
    
    
    // COLLECTION VIEW
    self.collection_view.dataSource = self;
    self.collection_view.delegate = self;
    _collection_view.showsHorizontalScrollIndicator = false;
    _collection_view.backgroundColor = [UIColor clearColor];
    

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
// PANTALLA CATEGORIA NUEVA

- (IBAction)accion_categoria_nueva:(id)sender {
    
    [self performSegueWithIdentifier: @"left" sender: self];

}// END PANTALLA CATEGORIA NUEVA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GESTURES DE COLLECTION VIEW

- (void)addGesturesCollection{
    
    // LONG PRESS
    UILongPressGestureRecognizer *lpgr= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collection_view addGestureRecognizer:lpgr];
    
    // SWIPE
//    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToDelete:)];
//    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.collection_view addGestureRecognizer:swipeGestureRecognizer];
    
    // DOUBLE TAPP
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    [self.collection_view addGestureRecognizer:doubleTapFolderGesture];
    
    
}// END ADD GESTURES COLLECTION

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// COLLECTION VIEW DATA SOURCE METHODS

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return arrayOfCategoria.count;
    
}// END NUMBER OF ITEMS IN SECTION


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    /////////////////////////////////////////////////////////// FRONT VIEW
    
    // AGARRAR INDEX PATH DE CADA CELDA
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // 0. CREAR OBJETO DE PRODUCTO
    Categoria *aCategoria = [arrayOfCategoria objectAtIndex:indexPath.row];
    
    // 1. PONER PALABRA CLAVE EN LABEL
    UILabel *label_nombre_producto = (UILabel *)[cell viewWithTag:25];
    NSString *label_nombre_producto_semifinal = [NSString stringWithFormat:@"%@", aCategoria.get_nombre_categoria];
    NSString *label_nombre_producto_final = [label_nombre_producto_semifinal uppercaseString];
    label_nombre_producto.text = label_nombre_producto_final;
    
    // 2. PONER IMAGENES
    UIImageView *imagen_producto = (UIImageView *)[cell viewWithTag:100];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", aCategoria.get_nombreImagen_categoria]];
    imagen_producto.image = [UIImage imageWithContentsOfFile:fullPath];
    
    // 4. PONER BORDES
    cell.backgroundColor = [UIColor clearColor];
    //cell.layer.cornerRadius = 8.0f;
    cell.contentView.layer.borderWidth = 0.5f;
    cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    return cell;
    
}// END CELL AT INDEX PATH
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//

// LONG PRESS PARA RE ORDENAR
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    CGPoint location = [gestureRecognizer locationInView: self.collection_view];
    NSIndexPath *indexPath = [self.collection_view indexPathForItemAtPoint: location];
    
    if (indexPath.row != 0) {
        
    
    
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
    
    }
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
    
    Categoria *pOrigen = [[Categoria alloc]init];
    
    // COPIAR ARREGLOS
    for (int ic = 0; ic < arrayOfCategoria.count; ic++) {
        arrayOfCategoriaTemporal[ic] = arrayOfCategoria[ic];
    }
    
    int origen = (int)index_origen.row;
    int final = (int)index_fin.row;
    
    if (origen > final) {
        
        pOrigen = arrayOfCategoria[origen];
        arrayOfCategoriaTemporal[final] = pOrigen;
        
        for (int ia = final, ic = final+1; ic <= origen; ic++, ia++) {
            
            arrayOfCategoriaTemporal[ic] = arrayOfCategoria[ia];
        }
        
    }else{
        
        pOrigen = arrayOfCategoria[origen];
        arrayOfCategoriaTemporal[final] = pOrigen;
        
        for (int ia = origen, ic = origen+1; ic <= final; ic++, ia++) {
            
            arrayOfCategoriaTemporal[ia] = arrayOfCategoria[ic];
        }
        
    }// END IF ELSE
    
    
    [self deleteDataTodos:[NSString stringWithFormat:@"DELETE FROM CATEGORIAS"]];
    
    NSString *string_nombre;
    NSString *string_nombre_imagen;
    
    for (int ic = 0; ic < arrayOfCategoriaTemporal.count; ic++) {
        Categoria *p= [[Categoria alloc]init];
        p = arrayOfCategoriaTemporal[ic];
        string_nombre = p.get_nombre_categoria;
        string_nombre_imagen = p.get_nombreImagen_categoria;
        
        char *error;
        
        if (sqlite3_open([dbPathString UTF8String], &censos)==SQLITE_OK) {
            NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO CATEGORIAS (CATEGORIA, NOMBREIMAGEN) values ('%@','%@')", string_nombre, string_nombre_imagen];
            
            const char *insert_stmt = [insertStmt UTF8String];
            
            if (sqlite3_exec(censos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            }
        }
        
    }// END FOR
    [self actualizarArregloCollectionView];
    
}// END REESTABLECER

//// BORRAR TODO SQLITE
-(void)deleteDataTodos:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_exec(censos, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
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
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"categorias.db"];
    
    dbPathString = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString UTF8String], &censos)==SQLITE_OK) {
        
        [arrayOfCategoria removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CATEGORIAS"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(censos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
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
        
        [[self collection_view]reloadData];
        
    }// END IF SQLITE OPEN
    
    
}// END ACTUALIZAR COLLECTION VIEW

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// DELETE CELL EN COLLECTION VIEW

//// SWIPE UP
//- (void)swipeToDelete:(UISwipeGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        
//        CGPoint point = [sender locationInView:_collection_view];
//        indexPath_cell_flipped = [self.collection_view indexPathForItemAtPoint:point];
//
//        if (indexPath_cell_flipped.row != 0) {
//            
//        
//        [self removeItemAtIndex:indexPath_cell_flipped];
//        
//        }
//    }
//}// END SWIPE TO DELETE

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
        
        
        if (indexPath.row != 0) {
            [self removeItemAtIndex:indexPath];

        }
        
        
    }
    //    }// END IF CATEGORIA NO ES GENERAL
}





-(void)removeItemAtIndex:(NSIndexPath *)index {
    
    // BORRAR DE: ARREGLO, COLLECTION GRAFICO, SQLITE
    
    Categoria *p = [arrayOfCategoria objectAtIndex:indexPath_cell_flipped.row];
    NSString *imagen_borrar = [NSString stringWithFormat:@"%s", [p.get_nombreImagen_categoria UTF8String]];
    [self removeImage:imagen_borrar];
    
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM CATEGORIAS WHERE ID = '%s'", [p.get_id_categoria UTF8String]];
    char *error;

    if (sqlite3_exec(censos, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
        
        [arrayOfCategoria removeObjectAtIndex:indexPath_cell_flipped.row];
        [self.collection_view deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.item inSection:0]]]; // update the interface

    [_collection_view reloadData];
    }
    
}// END BORRAR ITEM

- (void)removeImage:(NSString*)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    
    [fileManager removeItemAtPath: fullPath error:NULL];
    
    
}


@end
