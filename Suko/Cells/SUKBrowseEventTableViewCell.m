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

- (void) setEvent:(SUKEvent*) event {
    _event = event;
    
    self.eventNameLabel.text = event.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy h:mm a";
    self.dateLabel.text = [[[formatter stringFromDate:event.startTime]
                            stringByAppendingString:@" - "]
                           stringByAppendingString:[formatter stringFromDate:event.endTime]];
    
    [event.postedBy fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(object != nil) {
            PFUser *eventPoster = (PFUser *) object;
            self.usernameLabel.text = eventPoster.username;
            self.profileImageView.file = eventPoster[@"profile_image"];
            [self.profileImageView loadInBackground];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
            self.profileImageView.layer.masksToBounds = YES;
            self.profileImageView.layer.borderWidth = 0;
            
            [self.delegate profileDoneLoading:self];
        }
    }];
}

@end
