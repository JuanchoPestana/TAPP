//
//  Categoria.h
//  Tapp
//
//  Created by Juancho Pestana on 4/5/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categoria : NSObject{
    
    NSString *id_categoria;
    NSString *nombre_categoria;
    NSString *nombreImagen_categoria;
    
}

-(void) set_id_categoria:(NSString *) the_id_categoria;

-(void) set_nombre_categoria:(NSString *) the_nombre_categoria;

-(void) set_nombreImagen_categoria:(NSString *) the_nombreImagen_categoria;



-(NSString *)get_id_categoria;

-(NSString *)get_nombre_categoria;

-(NSString *)get_nombreImagen_categoria;



@end
