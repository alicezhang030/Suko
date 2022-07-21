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
@dynamic eventDescription;
@dynamic location;
@dynamic startTime;
@dynamic endTime;
@dynamic postedBy;
@dynamic attendees;

+ (nonnull NSString *)parseClassName {
    return @"SUKEvent";
}

+ (void)postEventWithName:(NSString *)eventName eventDescription:(NSString *)eventDescription eventLocation:(CLLocation *)eventLocation startTime:(NSDate *)startTime endTime:(NSDate *)endTime postedBy:(PFUser *)user withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    SUKEvent *newEvent = [SUKEvent new];
    
    newEvent.name = eventName;
    newEvent.eventDescription = eventDescription;
    newEvent.location = [PFGeoPoint geoPointWithLocation:eventLocation];
    newEvent.startTime = startTime;
    newEvent.endTime = endTime;
    newEvent.postedBy = user;
    newEvent.attendees = [NSArray new];
    
    [newEvent saveInBackgroundWithBlock: completion];
}


@end
