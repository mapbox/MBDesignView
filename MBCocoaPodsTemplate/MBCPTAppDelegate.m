//
//  MBCPTAppDelegate.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 11/1/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBCPTAppDelegate.h"

#import "MBCPTViewController.h"

@implementation MBCPTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MBCPTViewController *viewController = [MBCPTViewController new];

    UINavigationController *wrapper = [[UINavigationController alloc] initWithRootViewController:viewController];
    wrapper.navigationBar.tintColor = viewController.view.backgroundColor;
    self.window.rootViewController = wrapper;

    [self.window makeKeyAndVisible];

    return YES;
}
							
@end
