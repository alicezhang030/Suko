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

- (void)setEvent:(SUKEvent *)event {
    _event = event;
    
    self.eventNameLabel.text = event.name;
    self.usernameLabel.text = event.postedBy.username;
    
    self.profileImageView.file = event.postedBy[@"profile_image"];
    [self.profileImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Failed to load the profile image: %@", error.localizedDescription);
        } else if (image == nil) {
            NSLog(@"This user doesn't have a custom profile image. Loading default user icon...");
            if([UIImage imageNamed:@"user-icon"] != nil) {
                NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"user-icon"]);
                PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
                event.postedBy[@"profile_image"] = imageFile;
                [event.postedBy saveInBackground];
            } else {
                NSLog(@"Error: Could not find default user icon.");
            }
        }
    }];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM/dd/yyyy h:mm a";
    self.dateLabel.text = [[[formatter stringFromDate:event.startTime]
                            stringByAppendingString:@" - "]
                           stringByAppendingString:[formatter stringFromDate:event.endTime]];
}

@end
