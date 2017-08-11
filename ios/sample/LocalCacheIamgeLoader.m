//
//  LocalCacheIamgeLoader.m
//  sample
//
//  Created by 罗贤明 on 2017/8/11.
//

#import "LocalCacheIamgeLoader.h"
#import <UIKit/UIKit.h>

static NSData *cachedData;

@implementation LocalCacheIamgeLoader


RCT_EXPORT_MODULE();

- (BOOL)canHandleRequest:(NSURLRequest *)request {
  NSURL* URL = request.URL;
  if ([URL.scheme isEqualToString:@"cache"]) {
    // 抓取 指定协议的请求。
    return YES;
  }
  return NO;
}


- (id)sendRequest:(NSURLRequest *)request
     withDelegate:(id<RCTURLRequestDelegate>)delegate {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                                             statusCode:200
                                                            HTTPVersion:@"HTTP/1.1"
                                                           headerFields:nil];
    [delegate URLRequest:request didReceiveResponse:response];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      cachedData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"react" ofType:@"png"]];
    });
    [delegate URLRequest:request didReceiveData:cachedData];
    [delegate URLRequest:request didCompleteWithError:nil];
//    NSLog(@"返回图片");
  });
  return request;
}


@end
