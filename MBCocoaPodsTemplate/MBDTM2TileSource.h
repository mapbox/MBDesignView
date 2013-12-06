//
//  MBDTM2TileSource.h
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 12/5/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "RMTileMillSource.h"

@interface MBDTM2TileSource : RMTileMillSource

- (id)initWithHost:(NSString *)host projectPath:(NSString *)projectPath tileCacheKey:(NSString *)tileCacheKey minZoom:(float)minZoom maxZoom:(float)maxZoom;

@end
