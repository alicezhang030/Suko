//
//  SUKEvent.h
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKEvent : PFObject<PFSubclassing>
/** The name of the event as submitted by the user posting the event */
@property (nonatomic, strong) NSString *name;
/** The description of the event as submitted by the user posting the event */
@property (nonatomic, strong) NSString *eventDescription;
/** The coordinates of the event as chosen by the user posting the event */
@property (nonatomic, strong) PFGeoPoint *location;
/** The start time of the event as submitted by the user posting the event */
@property (nonatomic, strong) NSDate *startTime;
/** The end time of the event as submitted by the user posting the event */
@property (nonatomic, strong) NSDate *endTime;
/** The user posting the event */
@property (nonatomic, strong) PFUser *postedBy;
@property (nonatomic, strong) NSString *organizerID;
/** The attendees of the event as represented by an array containing their user object IDs */
@property (nonatomic, strong) NSArray<NSString*> *attendees;

+ (void) postEventWithName:(NSString *) eventName eventDescription:(NSString *) eventDescription eventLocation:(CLLocation *) eventLocation startTime:(NSDate *) startTime endTime:(NSDate *) endTime postedBy:(PFUser *) user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
