//
//  MainTicketViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 4/28/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MainTicketViewController.h"

@interface MainTicketViewController (){
    
    // VARIABLES DE SQLITE
    sqlite3 *productos;
    NSString *dbPathString_productos;
    
    
}// END INTERFACE

@end

@implementation MainTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}// END VIEWDIDLOAD



- (IBAction)accion_no:(id)sender {
    
    // 1
    [self deleteCarrito];
    // 2
    [self performSegueWithIdentifier: @"menu" sender: self];


}// END ACCION NO

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ACCION QUE ENVIA CORREO DE TICKET

- (IBAction)accion_si:(id)sender {
    
    [self performSegueWithIdentifier: @"ticketcorreo" sender: self];

}// END ACCION SI

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// BORRAR TODO DEL CARRITO

- (void)deleteCarrito{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *path_con_nombre_variable = [NSString stringWithFormat:@"carrito.db"];
    dbPathString_productos = [docPath stringByAppendingPathComponent:path_con_nombre_variable];
    
    
    char *error;
    if (sqlite3_open([dbPathString_productos UTF8String], &productos)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"DELETE FROM CARRITO"];
        const char *insert_stmt = [insertStmt UTF8String];
        if (sqlite3_exec(productos, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            
        }
        sqlite3_close(productos);
    }
    
}// END DELETE CARRITO

@end
