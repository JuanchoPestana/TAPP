//
//  Categoria.m
//  Tapp
//
//  Created by Juancho Pestana on 4/5/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "Categoria.h"

@implementation Categoria

// SETTERS

-(void) set_id_categoria:(NSString *)the_id_categoria{
    
    id_categoria = the_id_categoria;
}
-(void) set_nombre_categoria:(NSString *)the_nombre_categoria{
    
    nombre_categoria = the_nombre_categoria;
}


-(void) set_nombreImagen_categoria:(NSString *)the_nombreImagen_categoria{
    
    nombreImagen_categoria = the_nombreImagen_categoria;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// GETTERS
- (NSString *)get_id_categoria{
    return id_categoria;
}

- (NSString *)get_nombre_categoria{
    return nombre_categoria;
}

- (NSString *)get_nombreImagen_categoria{
    return nombreImagen_categoria;
}


@end
