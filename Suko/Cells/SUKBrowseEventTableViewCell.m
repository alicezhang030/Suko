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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy h:mm a";
    self.dateLabel.text = [[[formatter stringFromDate:event.startTime]
                            stringByAppendingString:@" - "]
                           stringByAppendingString:[formatter stringFromDate:event.endTime]];
    
    __weak __typeof(self) weakSelf = self;
    [event.postedBy fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        __strong __typeof(self) strongSelf = weakSelf;
        if(object != nil) {
            PFUser *eventPoster = (PFUser *) object;
            strongSelf.usernameLabel.text = eventPoster.username;
            strongSelf.profileImageView.file = eventPoster[@"profile_image"];
            [strongSelf.profileImageView loadInBackground];
            strongSelf.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
            strongSelf.profileImageView.layer.masksToBounds = YES;
            strongSelf.profileImageView.layer.borderWidth = 0;
            
            [strongSelf.delegate profileDoneLoading:self];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
