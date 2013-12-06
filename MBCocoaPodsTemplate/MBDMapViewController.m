//
//  MBDMapViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDMapViewController.h"

#import "MBDTM2TileSource.h"

@interface MBDMapViewController ()

@property (nonatomic) IBOutlet RMMapView *mapView;
@property (nonatomic) NSString *mapID;
@property (nonatomic) NSString *host;
@property (nonatomic) NSDictionary *projectInfo;
@property (nonatomic) NSString *projectPath;

@end

@implementation MBDMapViewController

- (id)initWithMapID:(NSString *)mapID
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
        _mapID = mapID;

    return self;
}

- (id)initWithHost:(NSString *)host projectInfo:(NSDictionary *)projectInfo
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        _host = host;
        _projectInfo = projectInfo;
    }

    return self;
}

- (id)initWithHost:(NSString *)host projectPath:(NSString *)projectPath
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        _host = host;
        _projectPath = projectPath;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([UIView instancesRespondToSelector:@selector(setTintColor:)])
        self.mapView.tintColor = self.navigationController.navigationBar.tintColor;

    self.mapView.hidden = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.mapView removeAllCachedImages];

    self.mapView.hidden = NO;

    if (self.mapID)
    {
        RMMapBoxSource *tileSource = [[RMMapBoxSource alloc] initWithMapID:self.mapID];

        self.mapView.tileSource = tileSource;

        self.mapView.hideAttribution = NO;

        self.title = [tileSource.infoDictionary valueForKey:@"name"];

        [self.mapView setZoom:tileSource.centerZoom atCoordinate:tileSource.centerCoordinate animated:NO];
    }
    else if (self.projectInfo)
    {
        self.mapView.tileSource = [[RMTileMillSource alloc] initWithHost:self.host
                                                                 mapName:[self.projectInfo valueForKey:@"id"]
                                                            tileCacheKey:[self.host stringByAppendingString:[self.projectInfo valueForKey:@"id"]]
                                                                 minZoom:[[self.projectInfo valueForKey:@"minzoom"] floatValue]
                                                                 maxZoom:[[self.projectInfo valueForKey:@"maxzoom"] floatValue]];

        self.mapView.hideAttribution = YES;

        self.title = ([[self.projectInfo valueForKey:@"name"] length] ? [self.projectInfo valueForKey:@"name"] : [self.projectInfo valueForKey:@"id"]);

        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(0, 0);

        if ([self.projectInfo objectForKey:@"center"])
        {
            centerCoordinate = CLLocationCoordinate2DMake([[[self.projectInfo objectForKey:@"center"] objectAtIndex:1] doubleValue],
                                                          [[[self.projectInfo objectForKey:@"center"] objectAtIndex:0] doubleValue]);
        }

        CGFloat zoom = 0;

        if ([self.projectInfo objectForKey:@"center"])
        {
            zoom = [[[self.projectInfo objectForKey:@"center"] objectAtIndex:2] floatValue];
        }

        [self.mapView setZoom:zoom atCoordinate:centerCoordinate animated:NO];
    }
    else if (self.projectPath)
    {
        self.mapView.tileSource = [[MBDTM2TileSource alloc] initWithHost:self.host
                                                             projectPath:self.projectPath
                                                            tileCacheKey:[self.host stringByAppendingString:self.projectPath]
                                                                 minZoom:0
                                                                 maxZoom:19];

        self.mapView.hideAttribution = YES;

        self.title = [self.projectPath lastPathComponent];

        [self.mapView setZoom:2 atCoordinate:CLLocationCoordinate2DMake(0, 0) animated:NO];
    }
}

#pragma mark -

- (void)reload:(id)sender
{
    [self.mapView removeAllCachedImages];

    id tileSource = self.mapView.tileSource;

    [self.mapView removeTileSourceAtIndex:0];

    self.mapView.tileSource = tileSource;
}

@end
