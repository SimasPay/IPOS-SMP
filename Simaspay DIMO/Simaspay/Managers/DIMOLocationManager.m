//
//  DIMOLocationManager.m
//  DIMOPayiOS
//
//  Created by Kendy Susantho on 6/21/16.
//  Copyright © 2016 DIMO. All rights reserved.
//

#import "DIMOLocationManager.h"
#import "DIMOUtility.h"
#import "DIMOAlertView.h"

@interface DIMOLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation DIMOLocationManager

+ (DIMOLocationManager *)sharedInstance {
    static DIMOLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DIMOLocationManager alloc] init];
        sharedInstance.locationManager = [[CLLocationManager alloc] init];
        [sharedInstance getCurrentLocation];
    });
    return sharedInstance;
}

- (void)getCurrentLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100;
    
    if (isiOS8OrLater) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog([NSString stringWithFormat:@"didFailWithError: %@", error]);
    
    // warning need to be shown once
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        [DIMOAlertView showAlertWithTitle:nil message:String(@"DIMOLocationNotFound") cancelButtonTitle:@"OK"];
    });
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    self.coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_UPDATE_LOCATION object:nil];
    DLog([NSString stringWithFormat:@"didUpdateToLocation: %@", currentLocation]);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //[self.locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    self.coordinate = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_UPDATE_LOCATION object:nil];
    DLog([NSString stringWithFormat:@"didUpdateToLocation: %@", currentLocation]);
    //    [self.delegate locationManagerDidLocateUserLocation:location.coordinate];
}

@end
