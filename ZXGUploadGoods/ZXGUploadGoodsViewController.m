//
//  ZXGUploadGoodsViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/12/4.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGUploadGoodsViewController.h"
#import "ZXGUploadGoodsTableViewCell.h"

#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <AliyunOSSiOS/OSSService.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *goodsMessageID = @"goodsMessageID";
@interface ZXGUploadGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,ZXGUploadGoodsTableViewCellDelegate,CTAssetsPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *goodsMessageTableView;
@property (strong, nonatomic) ZXGUploadGoodsTableViewCell *cell;
// 判断是封面还是详情图（1封面 2详情）
@property (assign, nonatomic) NSInteger imgType;
// 存封面
@property (strong, nonatomic) NSString *imgString;
// 存内容图片
@property (strong, nonatomic) NSString *imgsContentsString;

// 等待上传⌛️
@property (weak, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *flower;

@property (strong, nonatomic) OSSClient *client;

@end

@implementation ZXGUploadGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSTS];

    [self.goodsMessageTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXGUploadGoodsTableViewCell class]) bundle:nil] forCellReuseIdentifier:goodsMessageID];
    self.goodsMessageTableView.delegate = self;
    self.goodsMessageTableView.dataSource = self;
    self.goodsMessageTableView.separatorStyle = 0;

    self.waitView.layer.cornerRadius = 7;
    self.waitView.clipsToBounds = YES;

    self.imgsContentsString = @"";
    
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加
- (IBAction)addGoods:(UIButton *)sender {
    self.imgsContentsString = [self.imgsContentsString substringToIndex:[self.imgsContentsString length] -1];
    NSString *followURL = @"/shop/create.php";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", localURL, followURL];
    NSDictionary *dic = @{
                          @"goods_name":self.cell.goodsName.text,
                          @"goods_img":self.imgString,
                          @"goods_imgs":self.imgsContentsString,
                          @"goods_price":self.cell.goodsPrice.text,
                          @"goods_content":self.cell.goodsContent.text,
                          // 暂时写死只用化妆品
                          @"type":@"1"
                          };
    [self.mgr POST:askingURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------++++++++%@",responseObject);
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"200"]) {
            // 刷新首页
            if ([self.delegate respondsToSelector:@selector(refreshHomePage)]) {
                [self.delegate refreshHomePage];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

// 添加封面
- (void)addGoodsImg:(NSInteger)imgType {
    if ([self.cell.goodsType.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品类型"];
    }else {
        self.imgType = imgType;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            if (status != PHAuthorizationStatusAuthorized) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                picker.delegate = self;
                // 显示选择的索引
                picker.showsSelectionIndex = YES;
                // 设置相册的类型：相机胶卷 + 自定义相册
                picker.assetCollectionSubtypes = @[
                                                   @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                                   @(PHAssetCollectionSubtypeAlbumRegular)];
                // 不需要显示空的相册
                picker.showsEmptyAlbums = NO;
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
    }
}

-(BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 0; // 最多选择照片数
    if (self.imgType == 1) {
        max = 1;
    }else if (self.imgType == 2) {
        max = 6;
    }
    if (picker.selectedAssets.count >= max) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最多选择%zd张图片", max] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
        [picker presentViewController:alert animated:YES completion:nil];
        // 这里不能使用self来modal别的控制器，因为此时self.view不在window上
        return NO;
    }
    return YES;
}

-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *documentPath = [documents stringByAppendingPathComponent:@"arrayXML.xml"];
    
    NSArray *dataArray = [NSArray arrayWithArray:assets];
    [dataArray writeToFile:documentPath atomically:YES];
    
    NSLog(@"%@", documentPath);
    
    // 关闭图片选择界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 遍历选择的所有图片
    for (NSInteger i = 0; i < assets.count; i++) {
        // 基本配置
        CGFloat scale = [UIScreen mainScreen].scale;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode   = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        PHAsset *asset = assets[i];
        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
        //        // 获取图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSData *imageData = UIImageJPEGRepresentation(result, 0.5);
            if (self.imgType == 1) {
                self.cell.goodsImg.image = [UIImage imageWithData:imageData];
            }else if (self.imgType == 2) {
                if (i == 0) {
                    self.cell.img1.image = [UIImage imageWithData:imageData];
                }else if (i == 1) {
                    self.cell.img2.image = [UIImage imageWithData:imageData];
                }else if (i == 2) {
                    self.cell.img3.image = [UIImage imageWithData:imageData];
                }else if (i == 3) {
                    self.cell.img4.image = [UIImage imageWithData:imageData];
                }else if (i == 4) {
                    self.cell.img5.image = [UIImage imageWithData:imageData];
                }else if (i == 5) {
                    self.cell.img6.image = [UIImage imageWithData:imageData];
                }
            }
            [self.view bringSubviewToFront:self.waitView];
            [self.flower startAnimating];
            self.waitView.hidden = NO;
//
            dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
            dispatch_async(queue, ^{
                [self ossUpload:imageData];
            });
            
        }];
    }
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// 上传图片
- (void)ossUpload:(NSData *)photoData{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"zhenxingou";
    
    NSString *md5Path = [[self md5:[NSString stringWithFormat:@"%@",photoData]] stringByAppendingString:@".jpg"];
    
    // 暂时写死化妆品
    put.objectKey = [NSString stringWithFormat:@"%@/%@",@"huazhuangpin",md5Path];
//    put.objectKey = [NSString stringWithFormat:@"%@/%@",self.cell.goodsType.text,md5Path];
    put.uploadingData = photoData; // 直接上传NSData
//    NSLog(@"%@  %@   %@",self.fid,self.fid,[SingleManager sharedManager].userID);
//    NSString *a = [NSString stringWithFormat:@"?fid=%@&uid=%@",@"10002",@"10002"];
//    NSString *followURL = [@"/album/addphoto" stringByAppendingString:a];
//    NSString *askingURL = [NSString stringWithFormat:@"%@%@", localURL, followURL];
////     设置回调参数
//    put.callbackParam = @{
//                          @"callbackUrl": askingURL,
//                          @"callbackBody":@"object=${object}"
//                          };
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"22upload object success!");
            if (self.imgType == 1) {
                self.imgString = [NSString stringWithFormat:@"http://zhenxingou.oss-cn-qingdao.aliyuncs.com/%@",put.objectKey];
                NSLog(@"===============%@",self.imgString);
            }else if (self.imgType == 2) {
                self.imgsContentsString = [self.imgsContentsString stringByAppendingString:[NSString stringWithFormat:@"http://zhenxingou.oss-cn-qingdao.aliyuncs.com/%@,",put.objectKey]];
                NSLog(@"--------------%@",self.imgsContentsString);
            }
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            [SVProgressHUD showErrorWithStatus:@"上传失败，请重新上传"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.flower stopAnimating];
            self.waitView.hidden = YES;
        });
        return nil;
    }];
    // 可以等待任务完成
    [putTask waitUntilFinished];
}

- (void)getSTS {
    // OSS
    NSString *endpoint = @"http://oss-cn-qingdao.aliyuncs.com";
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIz9VL1IBZ85Vo" secretKey:@"UDRtgyDqyl2KPYGrI6aMJmUPAsq5KJ"];

//    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
//        NSString *followURL = @"/sts?service=oss";
//        NSString *askingURL = [NSString stringWithFormat:@"%@%@", localURL, followURL];
//        NSURL * url = [NSURL URLWithString:askingURL];
//
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//        request.HTTPMethod = @"POST";
//
//        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
//        NSURLSession * session = [NSURLSession sharedSession];
//        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
//                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                        if (error) {
//                                                            [tcs setError:error];
//
//                                                            return;
//                                                        }
//                                                        [tcs setResult:data];
//                                                    }];
//        [sessionTask resume];
//        [tcs.task waitUntilFinished];
//        if (tcs.task.error) {
//            NSLog(@"get token error: %@", tcs.task.error);
//
//            return nil;
//        }
//
//        else {
//            NSLog(@"11%@",[[NSString alloc]initWithData:tcs.task.result encoding:NSUTF8StringEncoding]);
//            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
//                                                                    options:kNilOptions
//                                                                      error:nil];
//            OSSFederationToken * token = [OSSFederationToken new];
//            object = [object objectForKey:@"credentials"];
//            token.tAccessKey = [object objectForKey:@"accessKeyId"];
//            token.tSecretKey = [object objectForKey:@"accessKeySecret"];
//            token.tToken = [object objectForKey:@"securityToken"];
//            token.expirationTimeInGMTFormat = [object objectForKey:@"expiration"];
//            NSLog(@"get token: %@", token);
//            return token;
//        }
//    }];
    
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    
    self.client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXGUploadGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsMessageID forIndexPath:indexPath];
    self.cell = cell;
    cell.delegate = self;
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 746;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
