//
//  MBDTM2TileSource.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/5/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBDTM2TileSource.h"

@interface MBDTM2TileSource ()

@property (nonatomic) NSString *host;
@property (nonatomic) NSString *projectPath;

@end


@implementation MBDTM2TileSource

- (id)initWithHost:(NSString *)host projectPath:(NSString *)projectPath tileCacheKey:(NSString *)tileCacheKey minZoom:(float)minZoom maxZoom:(float)maxZoom
{
    self.host = host;
    self.projectPath = projectPath;

    return [super initWithHost:@"" tileCacheKey:tileCacheKey minZoom:minZoom maxZoom:maxZoom];
}

- (NSURL *)URLForTile:(RMTile)tile
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3000/style/%d/%d/%d.png?id=tmstyle://%@&mtime=%i", self.host, tile.zoom, tile.x, tile.y, self.projectPath, (int)[[NSDate date] timeIntervalSince1970]]];
}

@end
