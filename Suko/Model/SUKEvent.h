//
//  SUKEvent.h
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Model used to represent an event.
 */
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

/** The attendees of the event as represented by an array containing their user object IDs */
@property (nonatomic, strong) NSArray<NSString *> *attendees;

/**
 * Creates a SUKEvent object using the information provided by the parameters and posts the event to the app's Parse server.
 *
 * @param eventName The String representing the event's name.
 * @param eventDescription The String representing the event's description
 * @param eventLocation CLLocation (geographical location) representing the exact location of the event
 * @param startTime The time at which the event will start
 * @param endTime The time at which the event will end
 * @param user The user that posted this event on the app
 * @param completion Completion block
 */
+ (void)postEventWithName:(NSString *)eventName eventDescription:(NSString *)eventDescription eventLocation:(CLLocation *)eventLocation startTime:(NSDate *)startTime endTime:(NSDate *)endTime postedBy:(PFUser *)user withCompletion:(PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
