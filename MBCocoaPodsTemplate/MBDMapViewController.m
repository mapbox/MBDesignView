//
//  MBDMapViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/4/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDMapViewController.h"

#import "MBDTM2TileSource.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <UIColor-HexString/UIColor+HexString.h>

@interface MBDMapViewController ()

@property (nonatomic) IBOutlet RMMapView *mapView;
@property (nonatomic) NSString *mapID;
@property (nonatomic) NSString *host;
@property (nonatomic) NSDictionary *projectInfo;
@property (nonatomic) NSString *projectPath;
@property (nonatomic) MBProgressHUD *tipHUD;
@property (nonatomic) UIBarButtonItem *reloadButton;

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

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleUI:)];
    tap.numberOfTouchesRequired = 3;
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.mapView removeAllCachedImages];

    self.mapView.hidden = NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (self.mapID)
    {
        RMMapBoxSource *tileSource = [[RMMapBoxSource alloc] initWithMapID:self.mapID];

        self.mapView.tileSource = tileSource;

        self.mapView.hideAttribution = NO;

        self.title = ([[defaults stringForKey:@"lastHostedTitle"] length] ? [defaults stringForKey:@"lastHostedTitle"] : [tileSource.infoDictionary valueForKey:@"name"]);

        if ([[defaults stringForKey:@"lastHostedColor"] length])
        {
            NSString *hexString = [[defaults stringForKey:@"lastHostedColor"] stringByReplacingOccurrencesOfString:@"#" withString:@""];

            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:hexString];

            if ([UIView instancesRespondToSelector:@selector(setTintColor:)])
                self.mapView.tintColor = [UIColor colorWithHexString:hexString];
        }

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

        self.title = ([[defaults stringForKey:@"lastTileMill1Title"] length] ? [defaults stringForKey:@"lastTileMill1Title"] : ([[self.projectInfo valueForKey:@"name"] length] ? [self.projectInfo valueForKey:@"name"] : [self.projectInfo valueForKey:@"id"]));

        if ([[defaults stringForKey:@"lastTileMill1Color"] length])
        {
            NSString *hexString = [[defaults stringForKey:@"lastTileMill1Color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];

            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:hexString];

            if ([UIView instancesRespondToSelector:@selector(setTintColor:)])
                self.mapView.tintColor = [UIColor colorWithHexString:hexString];
        }

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
        NSURL *projectInfoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3000/style.json?id=tmstyle://%@", self.host, self.projectPath]];

        NSDictionary *projectInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:projectInfoURL] options:0 error:nil];

        self.mapView.tileSource = [[MBDTM2TileSource alloc] initWithHost:self.host
                                                             projectPath:self.projectPath
                                                            tileCacheKey:[self.host stringByAppendingString:self.projectPath]
                                                                 minZoom:[projectInfo[@"minzoom"] floatValue]
                                                                 maxZoom:[projectInfo[@"maxzoom"] floatValue]];

        self.mapView.hideAttribution = YES;

        self.title = ([[defaults stringForKey:@"lastTileMill2Title"] length] ? [defaults stringForKey:@"lastTileMill2Title"] : ([[projectInfo valueForKey:@"name"] length] ? [projectInfo valueForKey:@"name"] : [self.projectPath lastPathComponent]));

        if ([[defaults stringForKey:@"lastTileMill2Color"] length])
        {
            NSString *hexString = [[defaults stringForKey:@"lastTileMill2Color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];

            self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:hexString];

            if ([UIView instancesRespondToSelector:@selector(setTintColor:)])
                self.mapView.tintColor = [UIColor colorWithHexString:hexString];
        }

        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake([projectInfo[@"center"][1] doubleValue], [projectInfo[@"center"][0] doubleValue]);

        CGFloat zoom = [projectInfo[@"center"][2] doubleValue];

        [self.mapView setZoom:zoom atCoordinate:centerCoordinate animated:NO];
    }

    if ( ! [[NSUserDefaults standardUserDefaults] boolForKey:@"showedGestureHint"])
    {
        self.tipHUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.tipHUD.mode = MBProgressHUDModeText;
        self.tipHUD.labelText = @"Gestures";
        self.tipHUD.detailsLabelText = @"Tap anywhere with three fingers to toggle the app user interface.";
        [self.view addSubview:self.tipHUD];
        [self.tipHUD show:YES];
        [self.tipHUD hide:YES afterDelay:5.0];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showedGestureHint"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.tintColor = ((UIViewController *)self.navigationController.viewControllers[0]).view.backgroundColor;
}

#pragma mark -

- (void)reload:(id)sender
{
    [self.mapView removeAllCachedImages];

    id tileSource = self.mapView.tileSource;

    [self.mapView removeTileSourceAtIndex:0];

    self.mapView.tileSource = tileSource;
}

#pragma mark -

- (void)toggleUI:(UITapGestureRecognizer *)tap
{
    if (self.navigationItem.hidesBackButton)
    {
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.rightBarButtonItem = self.reloadButton;
    }
    else
    {
        self.navigationItem.hidesBackButton = YES;
        self.reloadButton = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end
