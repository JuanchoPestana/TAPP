//
//  Registro.h
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Registro : NSObject{
    
    NSString *correo_objeto;
    NSString *nip_objeto;
}


-(void) setCorreo:(NSString *) the_correo;
-(void) setNip:(NSString *) the_nip;

-(NSString *)getCorreo;
-(NSString *)getNip;

+ (Registro *)registroGlobal;

@end
