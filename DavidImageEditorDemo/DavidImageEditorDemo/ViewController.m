//
//  ViewController.m
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import "ViewController.h"
#import "DavidImageEditorViewController.h"
#import "CustomActionSheet.h"
@interface ViewController ()<DavidImageEditorViewControllerDelegate,CustomActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong) CustomActionSheet *sheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupImageView];

}

-(void)setupImageView
{
    CGFloat imageViewInset = 10;
    CGFloat imageViewWidth = self.view.frame.size.width - 2 * imageViewInset;
    CGFloat imagViewHeight = imageViewWidth * 0.7;
    CGFloat imageViewY = self.view.frame.size.height / 2 - imagViewHeight / 2;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewInset, imageViewY , imageViewWidth, imagViewHeight)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    
    self.imageView.image = [UIImage imageNamed:@"image_layer"];
    [self.view addSubview:self.imageView];
}


-(void)tapAction:(UIGestureRecognizer*)tap
{
    self.sheet = [[CustomActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" ButtonCount:2 OtherTitles:@"相机", @"相册", nil];
    [self.sheet show];
}

#pragma mark - CustionActionSheetDelegate
- (void)actionSheet:(CustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.sheet) {
        if (buttonIndex == 1) {
            if([self isCameraAvailable]) {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                sourceType = UIImagePickerControllerSourceTypeCamera;
                [self createImagePickerControllerWithSourceType:sourceType];
            }
        }else if (buttonIndex == 2) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self createImagePickerControllerWithSourceType:sourceType];
        }
    }
}

#pragma mark - camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)createImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    //controller.allowsEditing = YES;
    controller.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}


#pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - 50;
        CGFloat viewWidth =  self.view.frame.size.width;
        CGFloat VPY = (viewHeight -  viewWidth * 0.7) / 2;
        DavidImageEditorViewController *imgCropperVC = [[DavidImageEditorViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0,VPY, self.view.frame.size.width, self.view.frame.size.width * 0.7) finishCallBack:^(UIImage *image, BOOL canceled) {
            self.imageView.image =  image;
            [picker dismissViewControllerAnimated:YES completion:nil];
           
            
        } cancelBlock:^(UIImage *image, BOOL canceled) {
            [picker dismissViewControllerAnimated:YES completion:nil];
       
        }];
       // imgCropperVC.delegate = self;
        
        [picker pushViewController:imgCropperVC animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
//        [self presentViewController:imgCropperVC animated:YES completion:^{
//            // TO DO

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
