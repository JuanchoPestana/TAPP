//
//  Producto.h
//  Tapp
//
//  Created by Juancho Pestana on 3/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Producto : NSObject{
    
    NSString *id_producto;
    NSString *nombre_producto;
    NSString *palabraClave_producto;
    NSString *precio_producto;
    NSString *descripcion_producto;
    NSString *nombreImagen_producto;
    NSString *categoria_producto;
    NSString *cuenta_producto;
   
}

-(void) set_id_producto:(NSString *) the_id_producto;
-(void) set_nombre_producto:(NSString *) the_nombre_producto;
-(void) set_palabraClave_producto:(NSString *) the_palabraClave_producto;
-(void) set_precio_producto:(NSString *) the_precio_producto;
-(void) set_descripcion_producto:(NSString *) the_descripcion_producto;
-(void) set_nombreImagen_producto:(NSString *) the_nombreImagen_producto;
-(void) set_categoria_producto:(NSString *) the_categoria_producto;
-(void) set_cuenta_producto:(NSString *) the_cuenta_producto;


-(NSString *)get_id_producto;
-(NSString *)get_nombre_producto;
-(NSString *)get_palabraClave_producto;
-(NSString *)get_precio_producto;
-(NSString *)get_descripcion_producto;
-(NSString *)get_nombreImagen_producto;
-(NSString *)get_categoria_producto;
-(NSString *)get_cuenta_producto;


+ (Producto *)productoGlobal;


@end
