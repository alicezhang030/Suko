//
//  SUKEventTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKEventTableViewCell.h"
#import <Parse/Parse.h>

@implementation SUKEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setEvent:(SUKEvent*) event {
    _event = event;
    
    self.eventNameLabel.text = event.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy h:mm a";
    self.dateLabel.text = [formatter stringFromDate:event.date];
    
    PFUser *eventPoster = event.postedBy;
    [eventPoster fetchIfNeeded];
    self.usernameLabel.text = eventPoster.username;
    
    self.userProfileImage.file = eventPoster[@"profile_image"];
    [self.userProfileImage loadInBackground];
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height /2;
    self.userProfileImage.layer.masksToBounds = YES;
    self.userProfileImage.layer.borderWidth = 0;
}

@end
