//
//  SUKEvent.h
//  Suko
//
//  Created by Alice Zhang on 7/15/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUKEvent : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSDate *dateOfEvent;
@property (nonatomic, strong) NSNumber *milesAway;

+ (void) postEvent:(NSString *) eventName eventLocation:(NSString *) eventLocation date:(NSDate *) date usersMilesAway:(NSNumber *) miles withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
