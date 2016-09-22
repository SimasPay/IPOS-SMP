//
//  DIMOLocationManager.h
//  DIMOPayiOS
//
//  Created by Kendy Susantho on 6/21/16.
//  Copyright © 2016 DIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#define kNotif_UPDATE_LOCATION                  @"kNotif_SIMASPAY_UPDATE_LOCATION"

@interface DIMOLocationManager : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
+ (DIMOLocationManager *)sharedInstance;
- (void)getCurrentLocation;
@end
