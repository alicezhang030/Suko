//
//  SUKEditProfileViewController.m
//  Suko
//
//  Created by Alice Zhang on 7/12/22.
//

#import "SUKEditProfileViewController.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"


@interface SUKEditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation SUKEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewContents];
}

- (void) loadViewContents {
    // Load username
    self.usernameTextField.text = self.userToDisplay.username;
    
    // Load the user profile image
    self.profileImageView.file = self.userToDisplay[@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
}

- (IBAction)cancelEditProfile:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tapChangePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    // Resize image
    CGRect bounds = UIScreen.mainScreen.bounds;      // Fetches device's screen
    CGFloat width = bounds.size.width;               // Extracts width of bounds
    CGSize imageSize = CGSizeMake(width, width);     // Creates square image
    
    self.profileImageView.image = [self resizeImage:originalImage withSize:imageSize];
    
    NSData *imageData = UIImagePNGRepresentation(self.profileImageView.image);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
    
    // Upload image to database
    self.userToDisplay[@"profile_image"] = imageFile;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveProfile:(id)sender {
    self.userToDisplay[@"username"] = self.usernameTextField.text;
    [self.userToDisplay saveInBackground];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
