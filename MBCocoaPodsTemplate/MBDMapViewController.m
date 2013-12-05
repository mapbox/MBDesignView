//
//  MBDMapViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDMapViewController.h"

@interface MBDMapViewController ()

@property (nonatomic) id <RMTileSource>tileSource;
@property (nonatomic) IBOutlet RMMapView *mapView;

@end

@implementation MBDMapViewController

- (id)initWithTileSource:(id <RMTileSource>)tileSource;
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
        _tileSource = tileSource;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.tileSource = self.tileSource;
}

@end
