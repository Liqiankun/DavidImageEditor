//
//  DavidImageEditorViewController.h
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DavidImageEditorViewController;

@protocol DavidImageEditorViewControllerDelegate <NSObject>

- (void)imageEditor:(DavidImageEditorViewController *)imageEditorViewController didFinished:(UIImage *)editedImage;
- (void)imageEditorDidCancel:(DavidImageEditorViewController *)imageEditorViewController;

@end

@interface DavidImageEditorViewController : UIViewController

@property(nonatomic,assign) id<DavidImageEditorViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame;

@end
