//
//  SUKBrowseEventTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKBrowseEventTableViewCell.h"
#import <Parse/Parse.h>

@implementation SUKBrowseEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setEvent:(SUKEvent*) event {
    _event = event;
    
    self.eventNameLabel.text = event.name;
    self.usernameLabel.text = event.postedBy.username;
    self.profileImageView.file = event.postedBy[@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy h:mm a";
    self.dateLabel.text = [[[formatter stringFromDate:event.startTime]
                            stringByAppendingString:@" - "]
                           stringByAppendingString:[formatter stringFromDate:event.endTime]];
}

@end
