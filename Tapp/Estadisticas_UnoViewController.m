//
//  Estadisticas_UnoViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 8/30/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Estadisticas_UnoViewController.h"

@interface Estadisticas_UnoViewController (){
    
    NSMutableArray *chartData;
    NSMutableArray *chartLabels;
    NSMutableArray *fecha_bonita;
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    
    
    // ARREGLO DONDE VOY A PONER LA INFO PARA EL COLLECTION PRODUCTOS
    NSMutableArray *arrayOfProducto;
    NSMutableArray *arrayOfProductoTemporal;
    
    // VARIABLES DE VENTA
    sqlite3 *ventas;
    NSString *dbPathString_venta;
    NSMutableArray *arrayOfVentas;
    NSMutableArray *arrayOfProductosTabla;
    
    
    
    
}


@property (nonatomic, strong) IBOutlet FSLineChart *char_estadisticas_uno;



@end

int numero_de_labels;
int numero_dias_estadisticas_uno;
NSString *fecha_inferior_estadisticas_uno;
NSString *fecha_superior_estadisticas_uno;


NSString *total_ventas;
NSString *cuenta_todos;
NSString *cuenta_efectivo;
NSString *cuenta_tarjeta;
NSString *producto_mas_vendido;
NSString *palabra_clave_mas_vendido;
NSString *hora_mas_vendida;
NSString *dia_mas_vendido;
NSString *vendedor_mas_vendio;
NSString *fecha_excel;
NSString *direccion_archivo;
NSString *nombre_archivo_borrar;

@implementation Estadisticas_UnoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0. CONFIGURAR SWIPES
    [self configurarSwipe];
    
    // . CONFIGURAR SCROLLVIEW
    [self configurarScrollView];
    
    // 1. TRAER FECHAS
    [self traerFechas];
    
    // 1. INICIALIZAR ARREGLOS
    [self inicializarArrays];
    
    // 4. SELECCIONAR TIPO DE GRAFICO
    [self seleccionarTipoDeGrafica];
    
    // 5. TRAER DATOS VENTAS
    [self traerVentas];
    
    // 6. TRAER PRODUCTOS
    [self traerProductos];
    
    // 7. RESUMEN
    [self resumen];
    

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
    
}// END CONFIGURAR SWIPE


- (IBAction)accion_swipe_right:(id)sender {

    [self performSegueWithIdentifier: @"regresar" sender: self];

}// END ACCION SWIPE

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// CONFIGURAR SCROLLVIEW
- (void)configurarScrollView{
    
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    // 1. ACTIVAR SCROLLVIEW
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:(CGSizeMake(screenWidth, 4150))];
    
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER FECHAS

- (void)traerFechas{
    
    fecha_inferior_estadisticas_uno = [[NSUserDefaults standardUserDefaults] objectForKey:@"fecha_inferior"];
    fecha_superior_estadisticas_uno = [[NSUserDefaults standardUserDefaults] objectForKey:@"fecha_superior"];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date_inferior = [dateFormat dateFromString:fecha_inferior_estadisticas_uno];
    NSDate *date_superior = [dateFormat dateFromString:fecha_superior_estadisticas_uno];
    
    NSTimeInterval secondsBetween = [date_superior timeIntervalSinceDate:date_inferior];
    numero_dias_estadisticas_uno = secondsBetween / 86400;

    NSLog(@"NUM DIAS: %d", numero_dias_estadisticas_uno);

}// END TRAER FECHAS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// INICIALIZAR ARREGLOS

- (void)inicializarArrays{
    
    chartData = [[NSMutableArray alloc] init];
    chartLabels = [[NSMutableArray alloc] init];
    arrayOfVentas = [[NSMutableArray alloc]init];
    arrayOfProductosTabla = [[NSMutableArray alloc]init];
    fecha_bonita = [[NSMutableArray alloc]init];
    
    // TABLEVIEW VENTAS
    [_tableView_ventas setDelegate:self];
    _tableView_ventas.backgroundColor = [UIColor clearColor];
    _tableView_ventas.opaque = NO;
    _tableView_ventas.backgroundView = nil;
    
    [_tableView_ventas setShowsHorizontalScrollIndicator:NO];
    [_tableView_ventas setShowsVerticalScrollIndicator:NO];
    _tableView_ventas.allowsSelection = YES;
    
    // TABLEVIEW PRODUCTOS
    [_tableView_productos setDelegate:self];
    _tableView_productos.backgroundColor = [UIColor clearColor];
    _tableView_productos.opaque = NO;
    _tableView_productos.backgroundView = nil;
    
    [_tableView_productos setShowsHorizontalScrollIndicator:NO];
    [_tableView_productos setShowsVerticalScrollIndicator:NO];
    _tableView_productos.allowsSelection = YES;
    
    _label_arriba_chart.text = @"";
    _label_abajo_chart.text = @"";
    
}// END TRAER DATOS


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SELECCIONAR TIPO DE GRAFICO

- (void)seleccionarTipoDeGrafica{

    if (numero_dias_estadisticas_uno == 0) {
        
        [self graficoUnDia];
        
    }else if(numero_dias_estadisticas_uno >= 1 && numero_dias_estadisticas_uno <= 31){
        
        [self graficoUnMes];
        
    }else{
        
        [self graficoUnAno];
        
    }// END IF ELSE
    
    
}// END SELECCIONAR TIPO DE GRAFICA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GRAFICO DE UN DIA (POR HORAS)

- (void)graficoUnDia{
    
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
 
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT HORA, SUM(PRECIO) as Total FROM VENTAS WHERE fecha BETWEEN '%@' AND '%@' GROUP BY hora", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        
        int contador = 0;

        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
           
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                
                NSString *columna_hora = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_total = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                int total = [columna_total intValue];
                float total_float = [[NSNumber numberWithInt: total] floatValue];
                chartData[contador] = [NSNumber numberWithFloat:total_float];
                chartLabels[contador] = [NSString stringWithFormat:@"%@", columna_hora];

                NSLog(@"FECHA: %@ || SUMA: %@ | LABEL: %@ ", columna_hora, chartData[contador], chartLabels[contador]);
                
                contador++;
            }// END IF SQLITE ROW
            
            
            numero_de_labels = contador;
        }// END IF SQLITE OK
        
    }// END IF SQLITE OPEN

    [self plotearGrafica];
    
    NSString *dia = [fecha_inferior_estadisticas_uno substringWithRange:NSMakeRange(8, 2)];
    NSString *mes = [fecha_inferior_estadisticas_uno substringWithRange:NSMakeRange(5, 2)];
    NSString *ano = [fecha_inferior_estadisticas_uno substringWithRange:NSMakeRange(0, 4)];
    
    int int_mes = [mes intValue];
     
    switch (int_mes) {
        case 1:
            mes = @"ENERO";
            break;
        case 2:
            mes = @"FEBRERO";
            break;
        case 3:
            mes = @"MARZO";
            break;
        case 4:
            mes = @"ABRIL";
            break;
        case 5:
            mes = @"MAYO";
            break;
        case 6:
            mes = @"JUNIO";
            break;
        case 7:
            mes = @"JULIO";
            break;
        case 8:
            mes = @"AGOSTO";
            break;
        case 9:
            mes = @"SEPTIEMBRE";
            break;
        case 10:
            mes = @"OCTUBRE";
            break;
        case 11:
            mes = @"NOVIEMBRE";
            break;
        case 12:
            mes = @"DICIEMBRE";
            break;
        default:
            break;
    }

    _label_arriba_chart.text = @"VISTO POR HORAS";
    
    NSString *labl = [NSString stringWithFormat:@"%@ DE %@ DE %@", dia, mes, ano];
    _label_abajo_chart.text = labl;
    
}// END GRAFICO UN DIA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GRAFICO DE UN DIA (POR HORAS)

- (void)graficoUnMes{

    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    [fecha_bonita removeAllObjects];

    
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT FECHA, SUM(PRECIO) AS TOTAL FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' GROUP BY FECHA", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        
        int contador = 0;
        
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {

                //NSString *columna_fecha = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                //NSString *columna_total = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];

                NSString *columna_fecha = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 0)];
                NSString *columna_total = [NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 1)];

                NSString *dia = [columna_fecha substringWithRange:NSMakeRange(8, 2)];
                NSString *mes = [columna_fecha substringWithRange:NSMakeRange(5, 2)];
                int int_mes = [mes intValue];
                
                switch (int_mes) {
                    case 1:
                        mes = @"ENERO";
                        break;
                    case 2:
                        mes = @"FEBRERO";
                        break;
                    case 3:
                        mes = @"MARZO";
                        break;
                    case 4:
                        mes = @"ABRIL";
                        break;
                    case 5:
                        mes = @"MAYO";
                        break;
                    case 6:
                        mes = @"JUNIO";
                        break;
                    case 7:
                        mes = @"JULIO";
                        break;
                    case 8:
                        mes = @"AGOSTO";
                        break;
                    case 9:
                        mes = @"SEPTIEMBRE";
                        break;
                    case 10:
                        mes = @"OCTUBRE";
                        break;
                    case 11:
                        mes = @"NOVIEMBRE";
                        break;
                    case 12:
                        mes = @"DICIEMBRE";
                        break;
                    default:
                        break;
                }
                NSString *fechabonita = [NSString stringWithFormat:@"%@ %@", dia, mes];
                fecha_bonita[contador] = fechabonita;
                
                char charOne = [columna_fecha characterAtIndex:8];
                char charTwo = [columna_fecha characterAtIndex:9];
                
                int total = [columna_total intValue];
                float total_float = [[NSNumber numberWithInt: total] floatValue];
                chartData[contador] = [NSNumber numberWithFloat:total_float];
                chartLabels[contador] = [NSString stringWithFormat:@"%c%c", charOne, charTwo];
                
                NSLog(@"FECHA: %@ || SUMA: %@ | LABEL: %@ ", columna_fecha, chartData[contador], chartLabels[contador]);
                
                contador++;
            }// END IF SQLITE ROW
            
            numero_de_labels = contador;
        }// END IF SQLITE OK
        
    }// END IF SQLITE OPEN
    
    [self plotearGrafica];
    _label_arriba_chart.text = @"VISTO POR DIAS";

    
    NSString *mes_inferior = [fecha_inferior_estadisticas_uno substringWithRange:NSMakeRange(5, 2)];
    NSString *mes_superior = [fecha_superior_estadisticas_uno substringWithRange:NSMakeRange(5, 2)];

    int int_mes_inferior = [mes_inferior intValue];
    int int_mes_superior = [mes_superior intValue];

    switch (int_mes_inferior) {
        case 1:
            mes_inferior = @"ENERO";
            break;
        case 2:
            mes_inferior = @"FEBRERO";
            break;
        case 3:
            mes_inferior = @"MARZO";
            break;
        case 4:
            mes_inferior = @"ABRIL";
            break;
        case 5:
            mes_inferior = @"MAYO";
            break;
        case 6:
            mes_inferior = @"JUNIO";
            break;
        case 7:
            mes_inferior = @"JULIO";
            break;
        case 8:
            mes_inferior = @"AGOSTO";
            break;
        case 9:
            mes_inferior = @"SEPTIEMBRE";
            break;
        case 10:
            mes_inferior = @"OCTUBRE";
            break;
        case 11:
            mes_inferior = @"NOVIEMBRE";
            break;
        case 12:
            mes_inferior = @"DICIEMBRE";
            break;
        default:
            break;
    }// END MES INFERIOR
    
    switch (int_mes_superior) {
        case 1:
            mes_superior = @"ENERO";
            break;
        case 2:
            mes_superior = @"FEBRERO";
            break;
        case 3:
            mes_superior = @"MARZO";
            break;
        case 4:
            mes_superior = @"ABRIL";
            break;
        case 5:
            mes_superior = @"MAYO";
            break;
        case 6:
            mes_superior = @"JUNIO";
            break;
        case 7:
            mes_superior = @"JULIO";
            break;
        case 8:
            mes_superior = @"AGOSTO";
            break;
        case 9:
            mes_superior = @"SEPTIEMBRE";
            break;
        case 10:
            mes_superior = @"OCTUBRE";
            break;
        case 11:
            mes_superior = @"NOVIEMBRE";
            break;
        case 12:
            mes_superior = @"DICIEMBRE";
            break;
        default:
            break;
    }// END SUPERIOR
    NSString *labl;
    if ([mes_inferior isEqualToString:mes_superior]) {
        labl = [NSString stringWithFormat:@"%@", mes_inferior];
    }else{
    labl = [NSString stringWithFormat:@"%@ - %@ ", mes_inferior, mes_superior];
    }
    _label_abajo_chart.text = labl;
    
}// END GRAFICO UN MES

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GRAFICO DE UN DIA (POR HORAS)

- (void)graficoUnAno{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT substr(FECHA, 6, 2) || '-' || substr(FECHA, 1, 4) AS monthYear , Count(1) AS count FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' GROUP BY substr(FECHA, 6, 2), substr(FECHA, 1, 4)", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        
        int contador = 0;
        
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *columna_fecha = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_total = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
//                char charOne = [columna_fecha characterAtIndex:8];
//                char charTwo = [columna_fecha characterAtIndex:9];
                
                int total = [columna_total intValue];
                float total_float = [[NSNumber numberWithInt: total] floatValue];
                chartData[contador] = [NSNumber numberWithFloat:total_float];
                chartLabels[contador] = [NSString stringWithFormat:@"%@", columna_fecha];
                
                NSLog(@"FECHA: %@ || SUMA: %@ | LABEL: %@ ", columna_fecha, chartData[contador], chartLabels[contador]);
                
                contador++;
            }// END IF SQLITE ROW
            
            numero_de_labels = contador;
        }// END IF SQLITE OK
        
    }// END IF SQLITE OPEN
    
    [self plotearGrafica];
    _label_arriba_chart.text = @"VISTO POR MESES";

    NSString *ano_inferior = [fecha_inferior_estadisticas_uno substringWithRange:NSMakeRange(0, 4)];
    NSString *ano_superior = [fecha_superior_estadisticas_uno substringWithRange:NSMakeRange(0, 4)];

    NSString *labl;
    if ([ano_inferior isEqualToString:ano_superior]) {
        labl = [NSString stringWithFormat:@"%@", ano_inferior];
    }else{
        labl = [NSString stringWithFormat:@"%@ - %@ ", ano_inferior, ano_superior];
    }
    _label_abajo_chart.text = labl;
    
}// END GRAFICO UN ANO


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// MOSTRAR GRAFICA

- (void)plotearGrafica{
    
    NSMutableArray *chartDatas = [[NSMutableArray alloc]init];
    NSMutableArray *chartLables = [[NSMutableArray alloc]init];
    [chartDatas removeAllObjects];
    [chartLables removeAllObjects];
    
    chartDatas = chartData;
    chartLables = chartLabels;
    
    _char_estadisticas_uno.backgroundColor = [UIColor clearColor];
    _char_estadisticas_uno.fillColor = nil;
    _char_estadisticas_uno.displayDataPoint = YES;
    _char_estadisticas_uno.dataPointColor = [UIColor darkGrayColor];
    _char_estadisticas_uno.dataPointBackgroundColor = [UIColor darkGrayColor];
    _char_estadisticas_uno.dataPointRadius = 4;
    _char_estadisticas_uno.color = [_char_estadisticas_uno.dataPointColor colorWithAlphaComponent:0.5];
    _char_estadisticas_uno.valueLabelPosition = ValueLabelLeft;
    
    _char_estadisticas_uno.indexLabelTextColor = [UIColor darkGrayColor];
    _char_estadisticas_uno.valueLabelTextColor = [UIColor darkGrayColor];
    
    _char_estadisticas_uno.verticalGridStep = 10;
    _char_estadisticas_uno.horizontalGridStep = numero_de_labels;
    
    
    
    _char_estadisticas_uno.labelForIndex = ^(NSUInteger item) {
        return chartLables[item];
    };
    
    _char_estadisticas_uno.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.02f", value];
    };
    
    [_char_estadisticas_uno setChartData:chartDatas];
    
    
}// END PLOTEAR GRAFICA

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER VENTAS

- (void)traerVentas{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    dbPathString_venta = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_venta UTF8String], &ventas)==SQLITE_OK) {
        
        [arrayOfVentas removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@'", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(ventas, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_id_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_nombre_producto_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_palabra_clave_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *columna_precio_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *columna_fechahora_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                NSString *columna_tipopago_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                NSString *columna_vendedor_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];

                
                
                // PONER DATOS EN OBJETO
                Venta *venta = [[Venta alloc]init];
                [venta set_id_venta:columna_id_venta];
                [venta set_nombre_producto_venta:columna_nombre_producto_venta];
                [venta set_palabra_clave_venta:columna_palabra_clave_venta];
                [venta set_precio_venta:columna_precio_venta];
                [venta set_fechahora_venta:columna_fechahora_venta];
                [venta set_tipopago_venta:columna_tipopago_venta];
                [venta set_vendedor_venta:columna_vendedor_venta];
                
                [arrayOfVentas addObject:venta];
            }
        }
        
        [[self tableView_ventas]reloadData];
        
    }// END IF SQLITE OPEN
    
    
    
}// END TRAER VENTAS

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TRAER PRODUCTOS

- (void)traerProductos{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    dbPathString_venta = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_venta UTF8String], &ventas)==SQLITE_OK) {
        
        [arrayOfProductosTabla removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT ID, NOMBREPRODUCTO, COUNT(NOMBREPRODUCTO) AS CUENTA FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' GROUP BY NOMBREPRODUCTO ORDER BY CUENTA DESC", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        
        // AGARRAR DATOS
        if (sqlite3_prepare(ventas, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                
                // AQUI SE AGARRAN LAS COLUMNAS DE LA TABLA DE PRODUCTOS
                NSString *columna_id_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *columna_nombre_producto_venta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_cuenta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                
                
                // PONER DATOS EN OBJETO
                Venta *venta_producto = [[Venta alloc]init];
                [venta_producto set_id_venta:columna_id_venta];
                [venta_producto set_nombre_producto_venta:columna_nombre_producto_venta];
                [venta_producto set_cuenta_venta:columna_cuenta];
             
                
                [arrayOfProductosTabla addObject:venta_producto];
            }
        }

        [[self tableView_productos]reloadData];

    }// END IF SQLITE OPEN
    
    
    
}// END TRAER PRODUCTOS


///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// TABLEVIEW CATEGORIAS

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:25.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"SFUIDisplay-Thin" size:21.0];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.backgroundColor = [UIColor clearColor];
    
}// END FORMAT CELL

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (tableView.tag) {
        case 1:
            return [arrayOfVentas count];
            break;
        case 2:
            return [arrayOfProductosTabla count];
            break;
        case 3:
            return [chartData count];
            break;
            
        default:
            return [arrayOfVentas count];
            break;
    }// END SWITCH
    
}// END NUMBER OF ROWS


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    Venta *venta;
    NSString *titulo_tableview;
    NSString *subtitulo_tableview;

    Venta *producto;
    NSString *titulo_tableview_productos;
    NSString *subtitulo_tableview_productos;
    
    NSString *titulo_tableview_estadisticas;
    NSString *subtitulo_tableview_estadisticas;
    NSNumber *num;

    
    
    switch (tableView.tag) {
        case 1:
            venta  = [arrayOfVentas objectAtIndex:indexPath.row];
            titulo_tableview = [[NSString alloc]initWithFormat:@"%@ - %@ - %@", venta.get_nombre_producto_venta, venta.get_palabra_clave_venta, venta.get_precio_venta];
            subtitulo_tableview = [[NSString alloc]initWithFormat:@"%@ - %@ - %@", venta.get_fechahora_venta, venta.get_tipopago_venta, venta.get_vendedor_venta];
            cell.textLabel.text = titulo_tableview;
            cell.detailTextLabel.text = subtitulo_tableview;
            return cell;

            break;
        case 2:
            producto = [arrayOfProductosTabla objectAtIndex:indexPath.row];
            titulo_tableview_productos = [[NSString alloc]initWithFormat:@"%@", producto.get_nombre_producto_venta];
            subtitulo_tableview_productos = [[NSString alloc]initWithFormat:@"%@", producto.get_cuenta_venta];
            cell.textLabel.text = titulo_tableview_productos;
            cell.detailTextLabel.text = subtitulo_tableview_productos;
            return cell;
            
            break;
        case 3:
            num = chartData[indexPath.row];
            titulo_tableview_estadisticas = [NSString stringWithFormat:@"$ %@ mxn", num];
            subtitulo_tableview_estadisticas = fecha_bonita[indexPath.row];
            cell.textLabel.text = titulo_tableview_estadisticas;
            cell.detailTextLabel.text = subtitulo_tableview_estadisticas;
            return cell;
            
            break;
            
        default:
            return cell;
            break;
    }
    
    
    cell.textLabel.highlightedTextColor = [UIColor blackColor];

}// END CELL FOR ROW

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// RESUMEN

- (void)resumen{
    
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    dbPathString_venta = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    // ABRIR BASE DE DATOS
    if (sqlite3_open([dbPathString_venta UTF8String], &ventas)==SQLITE_OK) {
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT ID, SUM(PRECIO) AS TOTAL, COUNT(*) AS CUENTA FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@'", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        if (sqlite3_prepare(ventas, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                total_ventas = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                cuenta_todos = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            }
        }// END QUERY
        
        NSString *querySql2 = [NSString stringWithFormat:@"SELECT COUNT(*) AS EFECTIVO FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' AND TIPOPAGO = 'efectivo'", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql2 = [querySql2 UTF8String];
        if (sqlite3_prepare(ventas, query_sql2, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                cuenta_efectivo = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
        }// END QUERY2
        
        NSString *querySql3 = [NSString stringWithFormat:@"SELECT COUNT(*) AS TARJETA FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' AND TIPOPAGO = 'tarjeta'", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql3 = [querySql3 UTF8String];
        if (sqlite3_prepare(ventas, query_sql3, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                cuenta_tarjeta = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
        }// END QUERY3
        
        NSString *querySql4 = [NSString stringWithFormat:@"SELECT NOMBREPRODUCTO, PALABRACLAVE, COUNT(NOMBREPRODUCTO) AS CUENTA FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' GROUP BY NOMBREPRODUCTO ORDER BY CUENTA DESC LIMIT 1 ", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql4 = [querySql4 UTF8String];
        if (sqlite3_prepare(ventas, query_sql4, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                producto_mas_vendido = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                palabra_clave_mas_vendido = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];

            }
        }// END QUERY4
        
        NSString *querySql5 = [NSString stringWithFormat:@"SELECT VENDEDOR, COUNT(VENDEDOR) AS CUENTA FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' GROUP BY VENDEDOR ORDER BY CUENTA DESC LIMIT 1", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql5 = [querySql5 UTF8String];
        if (sqlite3_prepare(ventas, query_sql5, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                vendedor_mas_vendio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            }
        }// END QUERY5
        
        NSString *querySql6 = [NSString stringWithFormat:@"SELECT HORA, COUNT(HORA) AS CUENTA FROM VENTAS WHERE FECHA BETWEEN '%@' AND '%@' GROUP BY HORA ORDER BY CUENTA DESC LIMIT 1", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql6 = [querySql6 UTF8String];
        if (sqlite3_prepare(ventas, query_sql6, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                hora_mas_vendida = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            }
        }// END QUERY6
        
    }// END IF SQLITE OPEN

    
    // 1. EN ESTE PERIODO VENDISTE **
    NSLog(@"TOTAL VENTAS: %@", total_ventas);
    
    // 2. % EN EFECTIVO. % CON TARJETA
    NSLog(@"CUENTA TOTAL: %@", cuenta_todos);
    NSLog(@"CUENTA EFECTIVO: %@", cuenta_efectivo);
    NSLog(@"CUENTA TARJETA: %@", cuenta_tarjeta);
    
    // 3. producto que mas has vendido en el periodo
    NSLog(@"PRODUCTO MAS VENDIDO: %@ %@", producto_mas_vendido, palabra_clave_mas_vendido);

    // 5. hora del dia que mas vendiste en el periodo
    NSLog(@"HORA MAS VENDIDA: %@", hora_mas_vendida);
    
    // 6. vendedor que mas ha vendido en el periodo
    NSLog(@"VENDEDOR QUE MAS VENDIO: %@", vendedor_mas_vendio);
    
}// END RESUMEN

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// EXCEL

- (void)excel{
    
    [self traerFechaActual];
    
    NSMutableString *csv_string = [[NSMutableString alloc]init];
    [csv_string appendFormat: @"TAPP,,,,,,,\n"];
    [csv_string appendFormat: @"FECHA DE EXPORTACION,%@,,,,,,\n", fecha_excel];
    [csv_string appendFormat: @"FORMATO DE FECHAS EXPORTADOS:,,MES/DIA/ANO,,MES/DIA/ANO,,,\n"];
    [csv_string appendFormat: @"RANGO DE FECHAS EXPORTADOS:,DE,%@,A,%@,,,\n", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
    [csv_string appendFormat: @",,,,,,,\n"];
    [csv_string appendFormat: @"NOMBREPRODUCTO,PALABRACLAVE,PRECIO,DESCRIPCION,FECHAHORA,TIPOPAGO,NUMEROORDEN,VENDEDOR\n"];
    // PATH BASE DE DATOS
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"ventas.db"];
    
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM VENTAS WHERE fecha BETWEEN '%@' AND '%@'", fecha_inferior_estadisticas_uno, fecha_superior_estadisticas_uno];
        const char* query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(productos, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *columna_nombre_producto = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *columna_palabra_clave = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *columna_precio = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *columna_descripcion = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *columna_fechahora = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                NSString *columna_tipopago = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                NSString *columna_numero_orden = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                NSString *columna_vendedor = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                
                [csv_string appendFormat:@"%@,%@,%@,%@,%@,%@,%@,%@\n", columna_nombre_producto, columna_palabra_clave, columna_precio, columna_descripcion, columna_fechahora, columna_tipopago, columna_numero_orden, columna_vendedor];
                
            }// END IF SQLITE ROW
        }// END IF SQLITE OK
    }// END IF SQLITE OPEN

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *nombre_archivo = [NSString stringWithFormat:@"ventasExport%@.csv", fecha_excel];
    NSString *docFile = [docDir stringByAppendingPathComponent:nombre_archivo];
    
    
    [csv_string writeToFile:docFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    direccion_archivo = docFile;
    nombre_archivo_borrar = nombre_archivo;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(guardarExcelServidor) userInfo:nil repeats:NO];

   
    
}// END EXCEL



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//ACCION EXCEL

- (IBAction)accion_exportar_excel:(id)sender {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        // NO HAY
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(crearAlertError) userInfo:nil repeats:NO];
        
    }else{
        // SI HAY
        [self excel];
        
    }// END IF INTERNET

    
    

}// END EXCEL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// METODO QUE AGARRA FECHA ACTUAL
- (void)traerFechaActual{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
    NSString *fechaSemi = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    fecha_excel = fechaSemi;
    
}// END FECHA ACTUAL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GUARDAR IMAGEN EN SERVIDOR

- (void)guardarExcelServidor{
    
    NSString *urlString = @"http://tapp.dataprodb.com/tapp_final/excels/uploadExcel.php";

    NSData *excelData = [[NSFileManager defaultManager] contentsAtPath:direccion_archivo];

    
    if (excelData != nil)
    {
        NSString *filenames = [NSString stringWithFormat:@"excelUsuario"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ventasExport%@.csv\"\r\n",fecha_excel] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:excelData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
       NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSData *returnData = data;
             if (returnData) {

                 [self enviarMailConExcel];
                 [self deleteExcel:nombre_archivo_borrar];

             }
             
         }];// END NSURLCONNECTION
       
        
        
//        [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
//         {
//             NSData *returnData = data;
//             if (returnData) {
//                 NSLog(@"EXiTO");
//             
//             }
//         }];
    }
    
    
    
}// END GUARDAR IMAGEN SERVIDOR

- (void)deleteExcel:(NSString *)filename{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"ELIMINADO");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
}// END DELETE EXCEL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//
- (void)enviarMailConExcel{
    
    NSString *email_usuario = [[NSUserDefaults standardUserDefaults] objectForKey:@"correo_usuario"];
    NSLog(@"CORREO: %@ ++++ NOMBRE: %@", email_usuario, nombre_archivo_borrar);
    
    NSString *strURL = [NSString stringWithFormat:@"http://tapp.dataprodb.com/tapp_final/excels/enviarExcel.php?email=%@&nombreArchivo=%@", email_usuario, nombre_archivo_borrar];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    if ([strResult isEqualToString:@"success"]) {
        
    }else{
        
    }
    
    [self crearAlertExcelEnviado];


}// END ENVIAR MAIL CON EXCEL

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT NO HAY INTERNET

- (void)crearAlertError{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"No hay conexión a internet."
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
    
}// END CREAR NO HAY INTERNET

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT NO HAY INTERNET

- (void)crearAlertExcelEnviado{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"Arhivo enviado. Revisa tu correo."
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
    
}// END ALERT ARCHIVO ENVIADO


@end
