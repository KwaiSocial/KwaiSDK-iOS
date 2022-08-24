//
//  KSShareMessageViewController.m
//  KwaiSDK_Example
//
//  Created by huangzhenyuan on 2022/7/14.
//  Copyright © 2022年 kuaishou. All rights reserved.
//

#import "KSShareMessageViewController.h"
#import "KSOpenApiManager+Message.h"


@interface KSShareMessageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UITextView *linkTextView;
@property (strong, nonatomic) IBOutlet UILabel *imageLabel;

@property (nonatomic, strong) NSData *imageData;

@end

@implementation KSShareMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.view addGestureRecognizer:tgr];
}

- (void)endEditing {
    [self.titleTextView resignFirstResponder];
    [self.descTextView resignFirstResponder];
    [self.linkTextView resignFirstResponder];
}

- (IBAction)done:(id)sender {
    [[KSOpenApiManager shared] shareMesssageTo:self.receiverOpenId
                                          title: self.titleTextView.text
                                           desc:self.descTextView.text
                                           link:self.linkTextView.text
                                     thumbImage:self.imageData
                                      extraInfo:@{}];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)selectImage:(id)sender {
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerLibrary.delegate = self;
    [self presentViewController:pickerLibrary
                       animated:YES
                     completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageLabel.numberOfLines = 0;
    self.imageData = UIImageJPEGRepresentation(image, 1);
    self.imageLabel.text = [NSString stringWithFormat:@"select image (%@ x %@), data length %.1fk", @(image.size.width),@(image.size.height
                            ), self.imageData.length / 1024.0];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
