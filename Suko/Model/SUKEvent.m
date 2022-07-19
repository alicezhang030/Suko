//
//  SUKEvent.m
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import "SUKEvent.h"
#import <MapKit/MapKit.h>

@implementation SUKEvent

@dynamic name;
@dynamic description;
@dynamic location;
@dynamic date;

+ (nonnull NSString *)parseClassName {
    return @"SUKEvent";
}

+ (void) postEventWithName:(NSString *) eventName eventDescription:(NSString *) eventDescription eventLocation:(CLLocation *) eventLocation eventDate:(NSDate *) eventDate withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    SUKEvent *newEvent = [SUKEvent new];
    
    newEvent.name = eventName;
    newEvent.description = eventDescription;
    newEvent.location = [PFGeoPoint geoPointWithLocation:eventLocation];
    newEvent.date = eventDate;
    
    [newEvent saveInBackgroundWithBlock: completion];
}


@end
