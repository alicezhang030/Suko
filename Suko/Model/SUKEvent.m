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
    
    // Fetch the users within that radius and notify them about this invitation
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query includeKey:@"current_coordinates"];
    [query whereKey:@"current_coordinates" nearGeoPoint:[PFUser currentUser][@"current_coordinates"] withinMiles:[miles doubleValue]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray<PFUser *> *users, NSError *error) {
        for(PFUser *user in users) {
            if(![user.objectId isEqualToString:[PFUser currentUser].objectId]) {
                // Send them a notification about this invitation
            }
        }
    }];
}


@end
