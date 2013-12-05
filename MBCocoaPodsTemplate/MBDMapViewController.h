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

- (id)initWithTileSource:(id <RMTileSource>)tileSource;

@end
