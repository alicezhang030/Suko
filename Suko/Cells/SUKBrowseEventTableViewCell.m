//
//  SUKBrowseEventTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 7/19/22.
//

#import "SUKBrowseEventTableViewCell.h"
#import <Parse/Parse.h>
#import "Parse/PFImageView.h"
#import "SUKConstants.h"

@interface SUKBrowseEventTableViewCell ()
/** The profile image of the user who posted this event */
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

/** Label displaying the username of the user who posted this event */
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

/** Label displaying the name of the event */
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

/** Label displaying the date and time of the event */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation SUKBrowseEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithEvent:(SUKEvent *)event {
    self.eventNameLabel.text = event.name;
    self.usernameLabel.text = event.postedBy.username;
    
    self.profileImageView.file = event.postedBy[kPFUserProfileImageKey];
    [self.profileImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Failed to load the profile image: %@", error.localizedDescription);
        } else if (image == nil) {
            NSLog(@"This user doesn't have a custom profile image. Loading default user icon...");
            if([UIImage imageNamed:kDefaultUserIconFileName] != nil) {
                NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:kDefaultUserIconFileName]);
                PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
                event.postedBy[kPFUserProfileImageKey] = imageFile;
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
    self.dateLabel.text = [[[formatter stringFromDate:event.startTime] stringByAppendingString:@" - "] stringByAppendingString:[formatter stringFromDate:event.endTime]];
}

@end
