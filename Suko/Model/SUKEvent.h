//
//  SUKEvent.h
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKEvent : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) PFUser *postedBy;
@property (nonatomic, strong) NSArray<PFUser*> *attendees;

+ (void) postEventWithName:(NSString *) eventName eventDescription:(NSString *) eventDescription eventLocation:(CLLocation *) eventLocation eventDate:(NSDate *) eventDate postedBy:(PFUser *) user withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
