![](https://github.com/Liqiankun/DavidImageEditor/raw/master/davidimageeditor.png)<br>
Help you edit image after you picked it from ImageAlbum. It's like Apple origin framework.<br>
在你从图选到照片后编辑照片。使用起来像苹果原生的类库一样的体验。<br>
![](https://github.com/Liqiankun/DavidImageEditor/raw/master/davidimageeitor.gif)
#Features
- [x] Easy to use
- [x] Customise eidted size and frame
- [x] Customise appearance
- [x] 使用简单
- [x] 定制编辑尺寸和位置
- [x] 定制外观

#How to use
Drag `DavidImageEidtor` folder to your project. Then `#import "DavidImageEditorViewController.h"`.
```oc
#pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{       UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height - 50;
        CGFloat viewWidth =  self.view.frame.size.width;
        CGFloat VPY = (viewHeight -  viewWidth * 0.7) / 2;
        DavidImageEditorViewController *imgCropperVC = [[DavidImageEditorViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0,VPY, self.view.frame.size.width, self.view.frame.size.width * 0.7) finishCallBack:^(UIImage *image, BOOL canceled) {
            //编辑完成点击确定Block
            self.imageView.image =  image;
            [picker dismissViewControllerAnimated:YES completion:nil];
        } cancelBlock:^(UIImage *image, BOOL canceled) {
            //点击取消的Block
            [picker dismissViewControllerAnimated:YES completion:nil];
        }];
        [picker pushViewController:imgCropperVC animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
```
