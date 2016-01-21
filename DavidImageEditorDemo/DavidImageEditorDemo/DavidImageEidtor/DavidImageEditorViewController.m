//
//  DavidImageEditorViewController.m
//  DavidImageEditorDemo
//
//  Created by DavidLee on 16/1/20.
//  Copyright © 2016年 DavidLee. All rights reserved.
//

#import "DavidImageEditorViewController.h"
#import "DavidImageEidtorView.h"
#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f
#define ORIGINAL_MAX_WIDTH 640.0f


@interface DavidImageEditorViewController ()

@property(nonatomic,strong) UIButton *cancelButton;
@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) UIButton *rotateBtn;
@property(nonatomic,strong) DavidImageEidtorView *imageEditorView;

@end

@implementation DavidImageEditorViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame
{
   return  [self initWithImage:originalImage cropFrame:cropFrame finishCallBack:nil cancelBlock:nil];
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame finishCallBack:(DavidImageEditorBlock)finishBlock cancelBlock:(DavidImageEditorBlock)cancelBlock
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f];
        
        self.imageEditorView = [[DavidImageEidtorView alloc] initWithFrame:cropFrame withImage:originalImage];
        
        self.imageEditorView.layer.borderWidth = 1.0;
        self.imageEditorView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        [self.view addSubview:self.imageEditorView];
        
        [self setUpButtons];
        
        self.finishBlock = finishBlock;
        self.cancelBlock = cancelBlock;
        
    }
    return self;
}

-(void)setUpButtons
{
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height - 50.0f, self.view.frame.size.width, 50)];
    barView.backgroundColor = [UIColor colorWithRed:0.08f green:0.08f blue:0.08f alpha:1.00f];
    [self.view addSubview:barView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //cancelBtn.backgroundColor = [UIColor blackColor];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:cancelBtn];
    
    self.cancelButton = cancelBtn;
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 0, 50, 50)];
    //confirmBtn.backgroundColor = [UIColor blackColor];
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:confirmBtn];
    
    self.rotateBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
    
    [self.rotateBtn setImage:[UIImage imageNamed:@"imagePicker_edit_rotate"] forState:UIControlStateNormal];
    [ self.rotateBtn addTarget:self action:@selector(rotateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rotateBtn];
    
    self.confirmBtn = confirmBtn;
}


- (void)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]) {
        [self.delegate imageEditorDidCancel:self];
    }
    
    if (self.cancelBlock) {
        self.cancelBlock(nil,YES);
    }
}

- (void)confirm:(id)sender {
    [self.imageEditorView finishEditing];
    if ([self.delegate respondsToSelector:@selector(imageEditor:didFinished:)]) {
        [self.delegate imageEditor:self didFinished:self.imageEditorView.croppedImage];
    }
    
    if (self.finishBlock) {
        self.finishBlock(self.imageEditorView.croppedImage,NO);
    }
}

-(void)rotateBtnAction:(UIButton*)button
{
    [self.imageEditorView rotateImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
