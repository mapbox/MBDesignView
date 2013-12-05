//
//  MBDInputViewController.h
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MBDInputModeMapID = 0,
    MBDInputModeTileMill1 = 1,
    MBDInputModeTileMill2 = 2,
} MBDInputMode;

@interface MBDInputViewController : UIViewController

- (id)initWithInputMode:(MBDInputMode)mode;

@end
