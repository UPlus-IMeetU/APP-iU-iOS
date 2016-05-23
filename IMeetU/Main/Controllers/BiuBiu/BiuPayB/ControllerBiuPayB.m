//
//  ControllerBiuPayB.m
//  IMeetU
//
//  Created by zhanghao on 16/3/24.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ControllerBiuPayB.h"
#import <StoreKit/StoreKit.h>
#import "UIStoryboard+Plug.h"
#import "ViewBiuPayB.h"
#import "UINib+Plug.h"
#import "UIScreen+Plug.h"


#import "MBProgressHUD+plug.h"
#import "UserDefultAccount.h"
#import "AFHTTPSessionManager.h"
#import "XMUrlHttp.h"
#import <YYKit/YYKit.h>
#import "ModelResponse.h"
#import "MBProgressHUD+plug.h"

#define UMi60 @"cc.imeetu.iu.umi_60"
#define UMi120 @"cc.imeetu.iu.umi_120"
#define UMin500 @"cc.imeetu.iu.umi_500"
#define UMin980 @"cc.imeetu.app.iu.umi_980"

/**测试使用的账单地址*/;
#define Text_ITMS_SANDBOX_VERIFY_RECEIPT_URL @"https://sandbox.itunes.apple.com/verifyReceipt"
/**线上使用的账单地址*/
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL @"https://buy.itunes.apple.com/verifyReceipt"

@interface ControllerBiuPayB ()<ViewBiuPayBDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic, assign) NSInteger umiCountNow;
@property (nonatomic, strong) ViewBiuPayB *viewBiuPayB;
@property (nonatomic, assign) CGFloat scrollViewContentHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, copy) NSString *orderCode;

/**所有的产品*/
@property (nonatomic,strong) SKProduct *product;
@end

@implementation ControllerBiuPayB

+ (instancetype)controllerWithUmiCount:(NSInteger)count{
    ControllerBiuPayB *controller = [UIStoryboard xmControllerWithName:xmStoryboardNameBuiBui indentity:@"ControllerBiuPayB"];
    controller.umiCountNow = count;
    return controller;
}

- (void)viewDidLoad{
    self.scrollViewMain.showsVerticalScrollIndicator = NO;
    self.scrollViewMain.contentSize = CGSizeMake([UIScreen screenWidth], self.scrollViewContentHeight);
    self.viewBiuPayB.delegatePayUmi = self;
    [self.scrollViewMain addSubview:self.viewBiuPayB];
    
    MBProgressHUD *hud = [MBProgressHUD xmShowHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString]};
    [httpManager POST:[XMUrlHttp xmGetUMi] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            self.umiCountNow = [response.data[@"virtual_currency"] integerValue];
            [self.viewBiuPayB initialWithUmiCount:self.umiCountNow];
        }else{
            [hud xmSetCustomModeWithResult:NO label:@"加载失败"];
        }
        [hud hide:YES afterDelay:0.5];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud xmSetCustomModeWithResult:NO label:@"加载失败"];
        [hud hide:YES afterDelay:0.5];
    }];
}
/**
 *  请求可卖商品
 */
- (void)requestProducts:(NSString *)type
{
    // 1.根据商品的编号请求所有的商品
    NSSet *set = [[NSSet alloc] initWithObjects:type, nil];
    // 2.向苹果发送请求,请求可卖商品
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}



/**
 *  当请求到可卖商品的结果会执行该方法
 *
 *  @param response response中存储了可卖商品的结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    //     for (SKProduct *product in response.products) {
    //     NSLog(@"价格:%@", product.price);
    //     NSLog(@"标题:%@", product.localizedTitle);
    //     NSLog(@"秒速:%@", product.localizedDescription);
    //     NSLog(@"productid:%@", product.productIdentifier);
    //     }
    //
    // 1.存储所有的数据
    self.product = [response.products firstObject];
    //判断是否审核成功
    if (self.product.productIdentifier) {
        [self buyProduct:self.product];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //进入交易页面，进行相关的监听
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //删除
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (ViewBiuPayB *)viewBiuPayB{
    if (!_viewBiuPayB) {
        _viewBiuPayB = [UINib xmViewWithName:@"ViewBiuPayB" class:[ViewBiuPayB class]];
        [_viewBiuPayB initWithViewHeight:self.scrollViewContentHeight];
    }
    return _viewBiuPayB;
}

- (CGFloat)scrollViewContentHeight{
    if ([UIScreen mainScreen].bounds.size.height < 600) {
        return 576;
    }
    return [UIScreen screenHeight]-64;
}

- (void)viewBiuPayB:(UIView *)view payRes:(BOOL)res umiCount:(NSInteger)count{
    if (self.delegatePayUmi) {
        if ([self.delegatePayUmi respondsToSelector:@selector(controllerBiuPayB:payRes:umiCount:)]) {
            [self.delegatePayUmi controllerBiuPayB:self payRes:res umiCount:count];
        }
    }
}

#pragma mark - 根据选择进行商品的购买
- (void)buyUMi:(NSInteger)money{
    NSString *type = nil;
    if (money == 60) {
        type = UMi60;
    }else if(money == 120){
        type = UMi120;
    }else if(money == 500){
        type = UMin500;
    }else if(money == 980){
        type = UMin980;
    }
    
    //生成订单
    NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"bill_type":@"1", @"channel":@"IAP", @"title":@"U米充值", @"totalfee":[NSNumber numberWithInteger:money * 10], @"totalnum":[NSNumber numberWithInteger:money]};
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //
    [httpManager POST:[XMUrlHttp xmPayCreateBiuOrder] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ModelResponse *response = [ModelResponse responselWithObject:responseObject];
        if (response.state == 200) {
            //获取订单号
            self.orderCode= response.data[@"bill_no"];
            _progressHUD = [MBProgressHUD xmShowIndeterminateHUDAddedTo:self.view
                                                                  label:@"获取信息..." animated:YES];
            [self requestProducts:type];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.progressHUD xmSetCustomModeWithResult:NO label:@"订单生成失败"];
        [self.progressHUD hide:YES afterDelay:1.5];
    }];
}

#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 实现观察者回调的方法
/**
 *  当交易队列中的交易状态发生改变的时候会执行该方法
 *
 *  @param transactions 数组中存放了所有的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买
     SKPaymentTransactionStatePurchased, 购买完成(销毁交易)
     SKPaymentTransactionStateFailed, 购买失败(销毁交易)
     SKPaymentTransactionStateRestored, 恢复购买(销毁交易)
     SKPaymentTransactionStateDeferred 最终状态未确定
     */
    // 调试
    for (SKPaymentTransaction *transaction in transactions) {
        // 如果小票状态是购买完成
        if (SKPaymentTransactionStatePurchased == transaction.transactionState) {
            NSLog(@"购买完成 %@", transaction.payment.productIdentifier);
            // 验证购买凭据
            BOOL isPruchase = [self verifyPruchase:ITMS_SANDBOX_VERIFY_RECEIPT_URL];
            if(!isPruchase){
                isPruchase = [self verifyPruchase:Text_ITMS_SANDBOX_VERIFY_RECEIPT_URL];
            }
            if (isPruchase) {
                AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
                httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
                httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
                NSDictionary *parameters = @{@"token":[UserDefultAccount token], @"device_code":[[UIDevice currentDevice].identifierForVendor UUIDString], @"bill_no":self.orderCode};
                [httpManager POST:[XMUrlHttp xmUpdateBill] parameters:@{@"data":[parameters modelToJSONString]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    ModelResponse *response = [ModelResponse responselWithObject:responseObject];
                    if(response.state == 200){
                        NSDictionary *res = response.data;
                        self.umiCountNow = [res[@"virtual_currency"] integerValue];
                        //进行更新
                        [self viewBiuPayB:self.viewBiuPayB payRes:YES umiCount:self.umiCountNow];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        } else if (SKPaymentTransactionStateRestored == transaction.transactionState) {
            NSLog(@"恢复成功 %@", transaction.payment.productIdentifier);
            // 将交易从交易队列中删除
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }else if (SKPaymentTransactionStateFailed == transaction.transactionState){
            NSLog(@"交易失败");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            //交易正在进行的话
        }else if (SKPaymentTransactionStatePurchasing == transaction.transactionState){
            dispatch_after(NSEC_PER_SEC*3, dispatch_get_main_queue(), ^{
                [self.progressHUD hide:YES];
            });
        }
    }
}


#pragma mark 验证购买凭据
- (BOOL)verifyPruchase:(NSString *)requestUrl
{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    // 发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:requestUrl];
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    request.HTTPMethod = @"POST";
    
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@", dict);
    //进行沙河测试环境的配置
    if ([dict[@"status"] integerValue] == 21007) {
        return NO;
    }
    
    if (dict != nil) {
        // bundle_id&application_version&product_id&transaction_id
        NSString *bundle_id = dict[@"receipt"][@"bundle_id"];
        if ([bundle_id isEqualToString:@"cc.imeetu.woxiangrenshini"]) {
            return YES;
        }
        
    }
    return NO;
}


// 恢复购买，对于永久性的东西
- (void)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
@end
