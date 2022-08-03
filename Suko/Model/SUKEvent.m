//
//  SUKEvent.m
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import "SUKEvent.h"
#import <MapKit/MapKit.h>

@interface SUKEvent ()
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *eventDescription;
@property (nonatomic, strong, readwrite) PFGeoPoint *location;
@property (nonatomic, strong, readwrite) NSDate *startTime;
@property (nonatomic, strong, readwrite) NSDate *endTime;
@property (nonatomic, strong, readwrite) PFUser *postedBy;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *attendees;
@end

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

+ (void)postEventWithName:(NSString *)eventName eventDescription:(NSString *)eventDescription eventLocation:(CLLocation *)eventLocation startTime:(NSDate *)startTime endTime:(NSDate *)endTime postedBy:(PFUser *)user withCompletion:(PFBooleanResultBlock _Nonnull)completion {
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

- (void)addOrRemoveAttendee:(PFUser *)attendee {
    NSMutableArray<NSString *> *attendeesMutable = [self.attendees mutableCopy];

    if([self.attendees containsObject:attendee.objectId]) {
        [attendeesMutable removeObject:attendee.objectId];
    } else {
        [attendeesMutable addObject:attendee.objectId];
    }
    
    self.attendees = [attendeesMutable copy];
    [self saveInBackground];
}

@end
