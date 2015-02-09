//
//  AppDelegate.m
//  RandomApp
//
//  Created by Andrew on 04.02.15.
//  Copyright (c) 2015 Andrew. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "CoreDataManager.h"
#import "RandomNumbersGenerator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TableViewController *tableViewController = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[CoreDataManager instance] saveContext];
}

@end
