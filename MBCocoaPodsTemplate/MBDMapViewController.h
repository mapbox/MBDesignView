//
//  MBDMapViewController.h
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapBox/MapBox.h>

@interface MBDMapViewController : UIViewController

- (id)initWithMapID:(NSString *)mapID;
- (id)initWithHost:(NSString *)host projectInfo:(NSDictionary *)projectInfo;

@end
