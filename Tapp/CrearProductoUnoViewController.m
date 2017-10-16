//
//  CrearProductoUnoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 3/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "CrearProductoUnoViewController.h"

@interface CrearProductoUnoViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString;
    NSString *dbPathString_Productos;
    NSMutableArray *arrayOfCategorias;
    
    // VARIABLES DE SQLITE
    sqlite3 *categorias;
    NSString *dbPathString_categorias;
    NSString *catgoria_seleccionada;
    
    NSString *resul;


    
}// END INTERFACE

@end

// VARIABLES GLOBALES
UIImagePickerController *imagePickerController_producto;
int contador_crear_producto;
int cero_crear_producto;
int uno_crear_producto;
int dos_crear_producto;
int tres_crear_producto;
int cuatro_crear_producto;
int cinco_crear_producto;
int seis_crear_producto;
int siete_crear_producto;
int ocho_crear_producto;

bool selecciono_categoria;
bool nombre_disponible;


@implementation CrearProductoUnoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. INICIALIZACIONES
    [self inicializaciones];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];
    
    // 2. CONFIGURAR TEXTFIELDS
    [self configurarTextfield];
    
    // 3. TRAER CATEGORIAS
    [self traerCategorias];
    
    
}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INICIALIZACIONES

- (void)inicializaciones{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
     arrayOfCategorias = [[NSMutableArray alloc]init];
    
    [_table_view setDelegate:self];
    _table_view.backgroundColor = [UIColor clearColor];
    _table_view.opaque = NO;
    _table_view.backgroundView = nil;
    
    [_table_view setShowsHorizontalScrollIndicator:NO];
    [_table_view setShowsVerticalScrollIndicator:NO];
    _table_view.allowsSelection = YES;
    
    catgoria_seleccionada = @"Todas";
    
    contador_crear_producto = 0;
    
    _label_precio.hidden = true;
    //_label_precio.text = @"Precio";
    //_textfield_precio.backgroundColor = [UIColor clearColor];
    //_textfield_precio.textColor = [UIColor clearColor];
    
    selecciono_categoria = false;
    nombre_disponible = true;
    
}// END INICIALIZACIONES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BLOQUAR COPY PASTE ASSIST
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER CATEGORIAS

- (void)traerCategorias{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"categorias.db"];
    dbPathString_categorias = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_categorias UTF8String], &categorias)==SQLITE_OK) {
        
        [arrayOfCategorias removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CATEGORIAS"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(categorias, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_id_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_nombre_categoria = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                // PONER DATOS EN OBJETO
                Categoria *categoria = [[Categoria alloc]init];
                [categoria set_id_categoria:columna_id_categoria];
                [categoria set_nombre_categoria:columna_nombre_categoria];
                
                [arrayOfCategorias addObject:categoria];
            }
        }
        
        [[self table_view]reloadData];
        
    }// END IF SQLITE OPEN
    

    
}// END TRAER CATEGORIAS

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

    [self performSegueWithIdentifier: @"right" sender: self];

}// END ACCION SWIPE

// METODO QUE GUARDA DATOS EN BASE Y SI TODO SALE BIEN, ENVIA A SIGUIENTE PANTALLA
- (IBAction)accion_swipe_left:(id)sender {
    
    nombre_disponible = true;
    
    if ([_textfield_nombre.text isEqualToString:@"" ] || [_textfield_palabra_clave.text isEqualToString:@"" ] || [_textview_descripcion_input.text isEqualToString:@"" ] || [_textfield_precio.text isEqualToString:@"" ] || selecciono_categoria == false) {
        [self crearAlertError];
        
    }else{
        
        [self verificarNombreRepetidoDeProducto];
        
    }// END ELSE
    
    
}// END ACCION SWIPE LEFT

// HAY QUE PONER UN TIMER PORQUE EL BOOL SE CONFUNDE A VECES
- (void)insertarConTimer{
    
    if (nombre_disponible) {
        [self insertarProducto];
    }else{
        [self crearAlertProductoYaExiste];
    }
    
}// END INSERTAR CON TIMER

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE INSERTA PRODUCTO EN BASE DE DATOS

- (void)insertarProducto{
    
    NSString *string_nombre = _textfield_nombre.text;
    NSString *string_palabra_clave = _textfield_palabra_clave.text;
    NSString *string_descripcion = _textview_descripcion_input.text;
    NSString *string_precio = _textfield_precio.text;
    NSString *string_nombre_imagen = [NSString stringWithFormat:@"%@%@%@.png", string_nombre, string_palabra_clave, string_precio];
    
    // GUARDAR IMAGEN EN DOCUMENTS FOLDER
    [self saveImage: _imagen_producto.image nombre: string_nombre_imagen];
    
    // RUTA SQLITE
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"productos.db"];

    
    char *error;
    
    if (sqlite3_open([dbPathString UTF8String], &productos)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO PRODUCTOS (NOMBRE, PALABRACLAVE, PRECIO, DESCRIPCION, NOMBREIMAGEN, CATEGORIA) values ('%@','%@','%@','%@','%@', '%@')", string_nombre, string_palabra_clave, string_precio, string_descripcion, string_nombre_imagen, catgoria_seleccionada];
        
        const char *insert_stmt = [insertStmt UTF8String];
        
        if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            
            [self performSegueWithIdentifier: @"left" sender: self];

        }
        sqlite3_close(productos);
    }
    
}// END INSERTAR CORREO TEMPORAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CREA OBJETO PRODUCTOS
// ESTE NO LO ESTOY USANDO PORQUE PENSE QUE IBA A TENER QUE CAMBIAR ENTRE MUCHAS PANTALLAS PARA EL TEMA
// DE LA IMAGEN ENTONCES TENIA QUE HACER UN PRODUCTO GLOBAL, PERO A LA MERA HORA, EN UNA SOLA PANTALLA,
// GUARDE TODO DIRECTO EN SQLITE
- (void)guardarObjetoProducot{
    
    NSString *string_nombre = _textfield_nombre.text;
    NSString *string_palabra_clave = _textfield_palabra_clave.text;
    NSString *string_descripcion = _textview_descripcion_input.text;
    NSString *string_precio = _textfield_precio.text;
    NSString *string_nombre_imagen = [NSString stringWithFormat:@"%@%@%@", string_nombre, string_palabra_clave, string_precio];
    
    Producto *objeto_producto = [Producto productoGlobal];
    [objeto_producto set_nombre_producto:string_nombre];
    [objeto_producto set_palabraClave_producto:string_palabra_clave];
    [objeto_producto set_descripcion_producto:string_descripcion];
    [objeto_producto set_precio_producto:string_precio];
    [objeto_producto set_nombreImagen_producto:string_nombre_imagen];
    
}// END CREAR OBJETO PRODUCTOS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CONFIGURA TEXTVIEW PLACEHOLDER


- (void)textViewDidBeginEditing:(UITextView *)textView{
  
    if ([textView.text isEqualToString:@"Descripcion del producto..."]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView becomeFirstResponder];
    
    
    UITextInputAssistantItem* item = [textView inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{

    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Descripcion del producto...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
    
    
    UITextInputAssistantItem* item = [textView inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE CONFIGURA TEXTFIELDS


// CONFIGURA TEXTFIELD
- (void)configurarTextfield{
    
    // NOMBRE
    [_textfield_nombre becomeFirstResponder];
    _textfield_nombre.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_textfield_nombre setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_nombre setBorderStyle:UITextBorderStyleNone]; //clear borders
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Nombre" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_nombre.attributedPlaceholder = str1;
    _textfield_nombre.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_nombre.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_nombre.tag = 1;
    _textfield_nombre.delegate = self;
    
    // PALABRA CLAVE
    _textfield_palabra_clave.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_textfield_palabra_clave setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_palabra_clave setBorderStyle:UITextBorderStyleNone]; //clear borders
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Palabra clave/SKU" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_palabra_clave.attributedPlaceholder = str2;
    _textfield_palabra_clave.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_palabra_clave.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_palabra_clave.tag = 2;
    _textfield_palabra_clave.delegate = self;
    
    // PRECIO
    _textfield_precio.keyboardAppearance = UIKeyboardAppearanceAlert;
    [_textfield_precio setBackgroundColor:[UIColor clearColor]]; //clear background
    [_textfield_precio setBorderStyle:UITextBorderStyleNone]; //clear borders
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Precio" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.textfield_precio.attributedPlaceholder = str3;

    _textfield_precio.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textfield_precio.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    _textfield_precio.tag = 3;
    _textfield_precio.delegate = self;
    
    // DESCRIPCION
    _textview_descripcion_input.keyboardAppearance = UIKeyboardAppearanceAlert;
    _textview_descripcion_input.autocorrectionType = UITextAutocorrectionTypeNo;// bloquear autocorrect
    _textview_descripcion_input.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _textview_descripcion_input.tag = 4;
    _textview_descripcion_input.text = @"Descripcion del producto...";
    _textview_descripcion_input.backgroundColor = [UIColor clearColor];
    _textview_descripcion_input.textColor = [UIColor darkGrayColor];
    _textview_descripcion_input.delegate = self;
    
}// END CONFIGURAR TEXTFIELD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO PARA PRESENTAR LA GALERIA DE FOTOS

- (IBAction)accion_seleccionar_imagen:(id)sender {
    
    imagePickerController_producto = [[UIImagePickerController alloc] init];
    imagePickerController_producto.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController_producto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController_producto.delegate = self;
    imagePickerController_producto.modalPresentationStyle = UIModalPresentationPopover;
    imagePickerController_producto.popoverPresentationController.sourceRect = self.boton_seleccionar_imagen.frame;
    imagePickerController_producto.popoverPresentationController.sourceView = self.view;
    UIPopoverPresentationController *presentationController = imagePickerController_producto.popoverPresentationController;
    
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:imagePickerController_producto animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [imagePickerController_producto dismissViewControllerAnimated:YES completion:nil];
    //        _imagen_seleccionada.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
#pragma mark - RSKImageCropViewControllerDelegate

//////////////////////////////////////////// DELEGATE

// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.imagen_producto.image = croppedImage;
    _imagen_fondo.image = [UIImage imageNamed:@"pantalla_crear_producto_1.png"];
    self.imagen_icono.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////// DATA SOURCE

// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize maskSize;
    if ([controller isPortraitInterfaceOrientation]) {
        maskSize = CGSizeMake(250, 250);
    } else {
        maskSize = CGSizeMake(220, 220);
    }
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:point1];
    [triangle addLineToPoint:point2];
    [triangle addLineToPoint:point3];
    [triangle closePath];
    
    return triangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GUARDAR IMAGEN EN DOCUMENTS FOLDER

- (void)saveImage:(UIImage *) image nombre: (NSString *) imageName {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    
    
}// END GUARDAR IMAGEN DOCUMENTS FOLDER

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TABLEVIEW CATEGORIAS
#pragma mark - TABLEVIEW CATEGORIAS


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"SFUIDisplay-Ultralight" size:25.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    
}// END FORMAT CELL

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfCategorias count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    Categoria *aCat = [arrayOfCategorias objectAtIndex:indexPath.row];
    NSString *titulo_tableview = [[NSString alloc]initWithFormat:@"%@", aCat.get_nombre_categoria];

    cell.textLabel.text = titulo_tableview;
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Categoria *p = [arrayOfCategorias objectAtIndex:indexPath.row];
    catgoria_seleccionada =  [NSString stringWithFormat:@"%s", [p.get_nombre_categoria UTF8String]];

    selecciono_categoria = true;
}// END SELECCIONAR FILA


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PRECIO COMO TERMINAL

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    
    if (textField.tag == 3) {
        
        if (range.length==1 && string.length==0){
            if (contador_crear_producto > 0) {
            [self borrarDigitos];
            }else{
                return false;
            }
        }
        
        if ([string isEqualToString:@"0"] || [string isEqualToString:@"1"] || [string isEqualToString:@"2"] || [string isEqualToString:@"3"]
            || [string isEqualToString:@"4"] || [string isEqualToString:@"5"] || [string isEqualToString:@"6"] || [string isEqualToString:@"7"] || [string isEqualToString:@"8"] || [string isEqualToString:@"9"]) {
            
            if (contador_crear_producto <= 8) {
                
            
            int valor_en_digito = string.intValue;
            
            [self inputDigitos:valor_en_digito];
            }else{
                return false;
            }
            
        }else{
            return false;
        }// END IF ELSE ES UN DIGITO
        
        }// IF ES TEXTFIELD PRECIOS
    
    
    return true;
}

// METODO QUE INPUTEA DIGITOS COMO TERMINAL
- (void)inputDigitos: (int)digito{
    
    
    switch (contador_crear_producto) {
        case 0:
            resul = [NSString stringWithFormat:@"00.0%d", digito];
            cero_crear_producto = digito;
            break;
        case 1:
            resul = [NSString stringWithFormat:@"00.%d%d", cero_crear_producto, digito];
            uno_crear_producto = digito;
            
            break;
        case 2:
            resul = [NSString stringWithFormat:@"0%d.%d%d", cero_crear_producto, uno_crear_producto, digito];
            dos_crear_producto = digito;
            break;
        case 3:
            resul = [NSString stringWithFormat:@"%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, digito];
            tres_crear_producto = digito;
            break;
        case 4:
            resul = [NSString stringWithFormat:@"%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, digito];
            cuatro_crear_producto = digito;
            break;
        case 5:
            resul = [NSString stringWithFormat:@"%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, digito];
            cinco_crear_producto = digito;
            break;
        case 6:
            resul = [NSString stringWithFormat:@"%d%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, cinco_crear_producto, digito];
            seis_crear_producto = digito;
            break;
        case 7:
            resul = [NSString stringWithFormat:@"%d%d%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, cinco_crear_producto, seis_crear_producto, digito];
            siete_crear_producto = digito;
            
            break;
        case 8:
            resul = [NSString stringWithFormat:@"%d,%d%d%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, cinco_crear_producto, seis_crear_producto, siete_crear_producto, digito];
            ocho_crear_producto = digito;
            break;
            
    }
    
    
    contador_crear_producto++;
    
        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(ponerResulTextfield) userInfo:nil repeats:NO];

    
}// END INPUT DIGITOS

- (void)ponerResulTextfield{
    
    _textfield_precio.text = @"";
    _textfield_precio.text = resul;
    
}// END PONER RESUL TEXTFIELD

// METODO PARA BORRAR LOS DIGITOS
- (void)borrarDigitos{
    
    
    switch (contador_crear_producto) {
        case 9:
            resul = [NSString stringWithFormat:@"%d%d%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, cinco_crear_producto, seis_crear_producto, siete_crear_producto];
            break;
        case 8:
            resul = [NSString stringWithFormat:@"%d%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, cinco_crear_producto, seis_crear_producto];
            break;
        case 7:
            resul = [NSString stringWithFormat:@"%d,%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto, cinco_crear_producto];
            break;
        case 6:
            resul = [NSString stringWithFormat:@"%d%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto, cuatro_crear_producto];
            break;
        case 5:
            resul = [NSString stringWithFormat:@"%d%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto, tres_crear_producto];
            break;
        case 4:
            resul = [NSString stringWithFormat:@"0%d.%d%d", cero_crear_producto, uno_crear_producto, dos_crear_producto];
            break;
        case 3:
            resul = [NSString stringWithFormat:@"00.%d%d", cero_crear_producto, uno_crear_producto];
            break;
        case 2:
            resul = [NSString stringWithFormat:@"00.0%d", cero_crear_producto];
            break;
        case 1:
            resul = [NSString stringWithFormat:@"00.00"];
            break;
    }
    
    contador_crear_producto--;
    
    [_textfield_precio setText:resul];
    
}// END TECLA BORRAR DIGITOS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT FALTA INFORMACION

- (void)crearAlertError{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Debes llenar todos los datos que se piden."
                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // BOTON CANCELAR
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertTextfieldBlanco addAction:cancelAction];
    
    [self presentViewController:alertTextfieldBlanco animated:YES completion:nil];
    
}// END CREAR ALERTA ERROR

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT PRODUCTO YA EXISTE

- (void)crearAlertProductoYaExiste{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Ese producto ya existe."
                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // BOTON CANCELAR
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    [alertTextfieldBlanco addAction:cancelAction];
    
    [self presentViewController:alertTextfieldBlanco animated:YES completion:nil];
    
}// END CREAR ALERTA PRODUCTO YA EXISTE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// PONER INFORMACION DE SQLITE EN ARREGLO PARA EL COLLECTION VIEW

// METODO QUE ACTUALIZA EL ARREGLO PARA EL COLLECTION VIEW CON VALORES DE SQLITE
-(void)verificarNombreRepetidoDeProducto{
    
    NSString *nombre_escrito = [NSString stringWithFormat:@"%@%@", _textfield_nombre.text, _textfield_palabra_clave.text];
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"productos.db"];
    
    dbPathString_Productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_Productos UTF8String], &productos)==SQLITE_OK) {
        
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM PRODUCTOS"];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_nombre_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_palabra_clave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                NSString *columna_juntos = [NSString stringWithFormat:@"%@%@", columna_nombre_producto, columna_palabra_clave];
                
                if ([columna_juntos isEqualToString:nombre_escrito]) {
                    nombre_disponible = false;
                }
            
                
            }// END WHILE
        }// END SQLITE OK
        
    }// END IF SQLITE OPEN
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(insertarConTimer) userInfo:nil repeats:NO];

    
    
}// END ACTUALIZAR COLLECTION VIEW

@end
