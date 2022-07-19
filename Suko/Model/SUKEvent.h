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
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSDate *date;

+ (void) postEventWithName:(NSString *) eventName eventDescription:(NSString*) eventDescription eventLocation:(CLLocation *) eventLocation eventDate:(NSDate *) date withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
