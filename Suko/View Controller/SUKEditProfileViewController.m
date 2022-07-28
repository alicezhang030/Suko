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
@property (weak, nonatomic) IBOutlet PFImageView *backdropImageView;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

UIImagePickerController *profilePictureImagePicker;
UIImagePickerController *backdropImagePicker;

@implementation SUKEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewContents];
}

- (void)loadViewContents {
    // Load username
    self.usernameTextField.text = [PFUser currentUser].username;
    
    // Load the user profile image and backdrop image
    self.profileImageView.file = [PFUser currentUser][@"profile_image"];
    [self.profileImageView loadInBackground];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderWidth = 0;
    
    self.backdropImageView.file = [PFUser currentUser][@"profile_backdrop"];
    UITapGestureRecognizer *backdropTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackdrop:)];
    [self.backdropImageView addGestureRecognizer:backdropTapRecognizer];
    [self.backdropImageView setUserInteractionEnabled:YES];
    
    [self.profileImageView loadInBackground];
    [self.backdropImageView loadInBackground];
}

- (IBAction)cancelEditProfile:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tapChangePhoto:(id)sender {
    profilePictureImagePicker = [UIImagePickerController new];
    profilePictureImagePicker.delegate = self;
    profilePictureImagePicker.allowsEditing = YES;
    profilePictureImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:profilePictureImagePicker animated:YES completion:nil];
}

- (void)tapBackdrop:(UITapGestureRecognizer *)sender {
    backdropImagePicker = [UIImagePickerController new];
    backdropImagePicker.delegate = self;
    backdropImagePicker.allowsEditing = YES;
    backdropImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:backdropImagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    if(picker == profilePictureImagePicker) {
        // Resize image
        CGRect bounds = UIScreen.mainScreen.bounds;      // Fetches device's screen
        CGFloat width = bounds.size.width;               // Extracts width of bounds
        CGSize imageSize = CGSizeMake(width, width);     // Creates square image
        
        self.profileImageView.image = [self resizeImage:originalImage withSize:imageSize];
        NSData *imageData = UIImagePNGRepresentation(self.profileImageView.image);
        PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"avatar.png" data:imageData];
        [PFUser currentUser][@"profile_image"] = imageFile;
    } else {
        self.backdropImageView.image = [self resizeImage:originalImage withSize:CGSizeMake(self.backdropImageView.frame.size.width, self.backdropImageView.frame.size.height)];
        NSData *imageData = UIImagePNGRepresentation(self.backdropImageView.image);
        PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"backdrop.png" data:imageData];
        [PFUser currentUser][@"profile_backdrop"] = imageFile;
    }
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveProfile:(id)sender {
    [PFUser currentUser][@"username"] = self.usernameTextField.text;
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            [self.delegate userFinishedEditingProfile];
        }
    }];
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
