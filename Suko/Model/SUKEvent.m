//
//  SUKEvent.m
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import "SUKEvent.h"

@implementation SUKEvent

@dynamic eventName;
@dynamic locationName;
@dynamic dateOfEvent;
@dynamic milesAway;

+ (nonnull NSString *)parseClassName {
    return @"SUKEvent";
}

+ (void) postEvent:(NSString *) eventName eventLocation:(NSString *) eventLocation date:(NSDate *) date usersMilesAway:(NSNumber *) miles withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    SUKEvent *newEvent = [SUKEvent new];
    
    // Set up the columns
    newEvent.eventName = eventName;
    newEvent.locationName = eventLocation;
    newEvent.dateOfEvent = date;
    newEvent.milesAway = miles;
    
    [newEvent saveInBackgroundWithBlock: completion];
}


@end
