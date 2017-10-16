//
//  AppDelegate.m
//  Tapp
//
//  Created by Juancho Pestana on 2/24/17.
//  Copyright © 2017 DPSoftware. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    // 1. HACER QUE EL LAUNCH SCREEN SE QUEDE POR UN SEGUNDO
//    [NSThread sleepForTimeInterval:1];
    
    
    
    
    // 3. NSUSERDEFAULTS INICIALIZAR (DETECTAR PRIMERA VEZ)
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"primera"]) {
        NSLog(@"FIRST RUN");
        
        // 2. SELECCIONAR STORYBOARD PARA USAR
        UIStoryboard *storyboard = [self grabStoryboard];
        [self setIniticialScreenFirstRun:storyboard];

    }// END FIRST RUN
    else{
    
    // 2. SELECCIONAR STORYBOARD PARA USAR
    UIStoryboard *storyboard = [self grabStoryboard];
    [self setIniticialScreen:storyboard];

    }
    return YES;
    
}// END DID FINISH LAUNCHING

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// DECIDIR CUAL MAINSTORYBOARD SE VA A UTILIZAR


- (UIStoryboard *)grabStoryboard{
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    int suma = screenHeight + screenWidth;

    UIStoryboard *storyboard;
    
    switch (suma) {
        case 888:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
        case 1042:
            storyboard = [UIStoryboard storyboardWithName:@"Main-6" bundle:nil];
            break;
        case 1150:
            storyboard = [UIStoryboard storyboardWithName:@"Main-6" bundle:nil];
            break;
        case 1792:
            storyboard = [UIStoryboard storyboardWithName:@"Main-ipad-chico" bundle:nil];
            break;
        case 2390:
            storyboard = [UIStoryboard storyboardWithName:@"Main-ipad-grande" bundle:nil];
            break;
            
        default:
            storyboard = [UIStoryboard storyboardWithName:@"Main-6" bundle:nil];
            break;
    }
    
    return storyboard;
    
}// END GRAB STORYBOARD


- (void)setIniticialScreen:(UIStoryboard *)storyboard{
    UIViewController *initviewcontroller;
    initviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"MenuPrincipal"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initviewcontroller;
    [self.window makeKeyAndVisible];
    
}// END SET INITIAL SCREEN

- (void)setIniticialScreenFirstRun:(UIStoryboard *)storyboard{
    UIViewController *initviewcontroller;
    initviewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"RegistroEmail"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initviewcontroller;
    [self.window makeKeyAndVisible];
    
}// END SET INITIAL SCREEN

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// DEVICE ORIENTATION DEPENDIENDO SI ES IPAD O IPHONE

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (screenHeight) {
        case 568:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case 667:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case 736:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case 1024:
            return UIInterfaceOrientationMaskLandscape;
            break;
        case 1366:
            return UIInterfaceOrientationMaskLandscape;
            break;
            
        default:
            return UIInterfaceOrientationMaskAll;
            break;
    
    }

}// END DEVICE ORIENTATION

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// METODOS QUE NO USO

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
