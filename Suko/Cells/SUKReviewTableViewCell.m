//
//  SUKReviewTableViewCell.m
//  Suko
//
//  Created by Alice Zhang on 8/5/22.
//

#import "SUKReviewTableViewCell.h"
#import "SUKReview.h"
#import "Parse/PFImageView.h"
#import "SUKConstants.h"
#import "DateTools/DateTools.h"

@interface SUKReviewTableViewCell ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *starOne;
@property (weak, nonatomic) IBOutlet UIImageView *starTwo;
@property (weak, nonatomic) IBOutlet UIImageView *starThree;
@property (weak, nonatomic) IBOutlet UIImageView *starFour;
@property (weak, nonatomic) IBOutlet UIImageView *starFive;
@end

@implementation SUKReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithReview:(SUKReview *)review {
    self.usernameLabel.text = review.author.username;
    self.reviewLabel.text = review.reviewText;
    
    if ([review.rating doubleValue] <= [@4 doubleValue])
        self.starFive.hidden = YES;
    if ([review.rating doubleValue] <= [@3 doubleValue])
        self.starFour.hidden = YES;
    if ([review.rating doubleValue] <= [@2 doubleValue])
        self.starThree.hidden = YES;
    if ([review.rating doubleValue] <= [@1 doubleValue])
        self.starTwo.hidden = YES;
    
    // Date
    NSDate *originalDate = review.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    NSString *formattedDateStr = [formatter stringFromDate:originalDate];
    NSDate *date = [formatter dateFromString:formattedDateStr];
    
    NSString *dateSince = date.shortTimeAgoSinceNow;
    if ([dateSince containsString:@"d"] || [dateSince containsString:@"w"] || [dateSince containsString:@"M"] || [dateSince containsString:@"y"]) { //has been more than a day
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.dateLabel.text = [formatter stringFromDate:date];
    } else { //it has not been a day since the tweet
        self.dateLabel.text = dateSince;
    }
    
    self.profileImage.file = review.author[kPFUserProfileImageKey];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    [self.profileImage loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Failed to load the profile image: %@", error.localizedDescription);
        } else if (image == nil) {
            NSLog(@"This user doesn't have a custom profile image. Loading default user icon...");
            if([UIImage imageNamed:kDefaultUserIconFileName] != nil) {
                NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:kDefaultUserIconFileName]);
                PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
                review.author[kPFUserProfileImageKey] = imageFile;
                [review.author saveInBackground];
            } else {
                NSLog(@"Error: Could not find default user icon.");
            }
        }
    }];
}

@end
