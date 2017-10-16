//
//  Producto.m
//  Tapp
//
//  Created by Juancho Pestana on 3/11/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Producto.h"

@implementation Producto


// SETTERS

-(void) set_id_producto:(NSString *)the_id_producto{
    
    id_producto = the_id_producto;
}

-(void) set_nombre_producto:(NSString *)the_nombre_producto{
    
    nombre_producto = the_nombre_producto;
}

-(void) set_palabraClave_producto:(NSString *)the_palabraClave_producto{
    
    palabraClave_producto = the_palabraClave_producto;
}

-(void) set_precio_producto:(NSString *)the_precio_producto{
    
    precio_producto = the_precio_producto;
}

-(void) set_descripcion_producto:(NSString *)the_descripcion_producto{
    
    descripcion_producto = the_descripcion_producto;
}

-(void) set_nombreImagen_producto:(NSString *)the_nombreImagen_producto{
    
    nombreImagen_producto = the_nombreImagen_producto;
}

-(void) set_categoria_producto:(NSString *)the_categoria_producto{
    
   categoria_producto = the_categoria_producto;
}

-(void) set_cuenta_producto:(NSString *)the_cuenta_producto{
    
    cuenta_producto = the_cuenta_producto;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GETTERS

- (NSString *)get_id_producto{
    return id_producto;
}

- (NSString *)get_nombre_producto{
    return nombre_producto;
}

- (NSString *)get_palabraClave_producto{
    return palabraClave_producto;
}

- (NSString *)get_precio_producto{
    return precio_producto;
}

- (NSString *)get_descripcion_producto{
    return descripcion_producto;
}

- (NSString *)get_nombreImagen_producto{
    return nombreImagen_producto;
}

- (NSString *)get_categoria_producto{
    return categoria_producto;
}

- (NSString *)get_cuenta_producto{
    return cuenta_producto;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// REGISTRO GLOBAL

+ (id)productoGlobal {
    
    static Producto *producto_global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        producto_global = [[self alloc] init];
    });
    return producto_global;
}

@end
