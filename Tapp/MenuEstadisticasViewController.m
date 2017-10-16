//
//  MenuEstadisticasViewController.m
//  Tapp
//
//  Created by Juancho Pestana on 9/3/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "MenuEstadisticasViewController.h"

@interface MenuEstadisticasViewController ()

@end

NSString *fecha_inferior_verificacion;
NSString *fecha_superior_verificacion;

@implementation MenuEstadisticasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. CONFIGURAR SWIPE
    [self configurarSwipe];

    // 2. DATE PICKER
    [self datePicker];
    
}// END VIEWDIDLOAD

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// SWIPE
- (void)configurarSwipe{
    
    _swipe_right.numberOfTouchesRequired = 2;
    _swipe_left.numberOfTouchesRequired = 2;

    
}// END CONFIGURAR SWIPE

- (IBAction)accion_swipe_right:(id)sender {
   
    [self performSegueWithIdentifier: @"regresar" sender: self];
    
}// END ACCION SWIPE RIGHT

- (IBAction)accion_swipe_left:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date_inferior = [dateFormat dateFromString:fecha_inferior_verificacion];
    NSDate *date_superior = [dateFormat dateFromString:fecha_superior_verificacion];
    
    NSTimeInterval secondsBetween = [date_superior timeIntervalSinceDate:date_inferior];
    int numero_dias_verficicacion = secondsBetween / 86400;
    
    NSLog(@"NUM DIAS: %d", numero_dias_verficicacion);
    
    
    if (numero_dias_verficicacion >= 0) {
        [self performSegueWithIdentifier: @"estadisticas_uno" sender: self];
    }else{
        [self crearAlertFechaIncorrecta];
    }

}// END ACCION SWIPE LEFT

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// DATE PICKER

- (void)datePicker{
    
    // DATE PICKER 1
    _date_picker.datePickerMode = UIDatePickerModeDate;
    _date_picker.tintColor = [UIColor whiteColor];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    _date_picker.locale = locale;
    [_date_picker setValue:[UIColor darkGrayColor] forKey:@"textColor"];
    
    // DATE PICKER 2
    _date_picker_2.datePickerMode = UIDatePickerModeDate;
    _date_picker_2.tintColor = [UIColor whiteColor];
    NSLocale * locale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"es_MX"];
    _date_picker_2.locale = locale2;
    [_date_picker_2 setValue:[UIColor darkGrayColor] forKey:@"textColor"];
    
}// END VIEWDIDLOAD

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
// ACCION DATE PICKER
- (IBAction)accion_date_picker:(id)sender {

    // FORMATO PARA LA COMPU (SQLITE)
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fecha_inferior = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_date_picker.date]];
    fecha_inferior_verificacion = fecha_inferior;
    [[NSUserDefaults standardUserDefaults] setObject:fecha_inferior forKey:@"fecha_inferior"];

    // FORMATO PARA PRESENTAR EN PANTALLA (LEGIBLE)
    NSDateFormatter *formatter_legible = [[NSDateFormatter alloc]init];
    [formatter_legible setDateFormat:@"dd/MM/yyyy"];
    NSString *fecha_inferior_legible = [NSString stringWithFormat:@"%@",[formatter_legible stringFromDate:_date_picker.date]];
    _label_fecha_inferior.text = fecha_inferior_legible;

}// END ACCION DATE PICKER 1

- (IBAction)accion_date_picker_2:(id)sender {

    // FORMATO PARA LA COMPU (SQLITE)
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fecha_superior = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_date_picker_2.date]];
    fecha_superior_verificacion = fecha_superior;
    [[NSUserDefaults standardUserDefaults] setObject:fecha_superior forKey:@"fecha_superior"];
    
    // FORMATO PARA PRESENTAR EN PANTALLA (LEGIBLE)
    NSDateFormatter *formatter_legible = [[NSDateFormatter alloc]init];
    [formatter_legible setDateFormat:@"dd/MM/yyyy"];
    NSString *fecha_superior_legible = [NSString stringWithFormat:@"%@",[formatter_legible stringFromDate:_date_picker_2.date]];
    _label_fecha_superior.text = fecha_superior_legible;
    
}// END ACCION DATE PICKER 2

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
// ALERT FECHA INCORRECTA
- (void)crearAlertFechaIncorrecta{
    
    UIAlertController * alertTextfieldBlanco =   [UIAlertController
                                                  alertControllerWithTitle:@"Tapp"
                                                  message:@"La fecha final debe ser mayor a la inicial."
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
    
}// END CREAR ALERTA FECHA INCORRECTA



@end
