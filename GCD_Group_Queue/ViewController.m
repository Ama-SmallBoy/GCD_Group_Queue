//
//  ViewController.m
//  GCD_Group_Queue
//
//  Created by a on 2019/8/26.
//  Copyright © 2019年 TeenageBeaconFireGroup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //TODO:线程组的学习：
   //[self learnGroup];
    //TODO:线程组配合barrier的使用：
    [self groupAndBarrier];
   

}
#pragma mark-------线程组group学习---------
-(void)learnGroup{
    //创建一个线程组：
    dispatch_group_t group = dispatch_group_create();
    //创建一个并发队列：
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.xiaomeng.jun",DISPATCH_QUEUE_CONCURRENT);
#warning mark-------注意：dispatch_group_enter(group)与dispatch_group_leave(group)应该成对存在。
    //进入线程组中
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据1");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据2");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据3");
        dispatch_group_leave(group);
    });
    
    //统一处理结果：比如：网络请求的数据，统一处理问题，此处队列，视情况而定
    dispatch_group_notify(group, concurrentQueue, ^{
        NSLog(@"====数据统一处理");
    });
}
#pragma mark-------barrier 以及 group的结合使用。

-(void)groupAndBarrier{
    
    //实现复杂的数据请求，具体的情况如下：
    //A-->B(串行)
    //C-->D(串行)
    //E
    //以上3个异步并发执行完成之后，在进行数据的统一处理
    //TODO: 声明：该事例仅仅是为了学习group与barrier的使用方法，实际还有更好的实现方式。
    
    //以下在学习的使用，请分别运行。
    //未使用barrier
    [self getDataFromMoreRequestUrlNotUseBarrier];
    //使用barrier，可以保证A-->B,C-->D的执行顺序。
    [self getDataFromMoreRequestUrlByBarrier];
  
}

-(void)getDataFromMoreRequestUrlByBarrier{
    
    //创建一个线程组：
    dispatch_group_t group = dispatch_group_create();
    //创建一个并发队列：
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.xiaomeng.jun",DISPATCH_QUEUE_CONCURRENT);
#warning mark-------注意：dispatch_group_enter(group)与dispatch_group_leave(group)应该成对存在。
    //进入线程组中
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据1开始");
        
        dispatch_async(concurrentQueue, ^{
            sleep(5);
            NSLog(@"=========任务A");
        });
        dispatch_barrier_async(concurrentQueue, ^{
            sleep(3);
            NSLog(@"=========任务B");
            dispatch_group_leave(group);
        });
        NSLog(@"====数据1结束");
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据2开始");
        dispatch_async(concurrentQueue, ^{
            sleep(5);
            NSLog(@"=========任务C");
        });
        dispatch_barrier_async(concurrentQueue, ^{
            sleep(3);
            NSLog(@"=========任务D");
            dispatch_group_leave(group);
        });
        NSLog(@"====数据2结束");
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据3开始");
        NSLog(@"=========任务E");
        NSLog(@"====数据3结束");
        dispatch_group_leave(group);
    });
    
    //统一处理结果：比如：网络请求的数据，统一处理问题，此处队列，视情况而定
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"====数据统一处理");
    });
}

-(void)getDataFromMoreRequestUrlNotUseBarrier{
    
    //创建一个线程组：
    dispatch_group_t group = dispatch_group_create();
    //创建一个并发队列：
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.xiaomeng.jun",DISPATCH_QUEUE_CONCURRENT);
#warning mark-------注意：dispatch_group_enter(group)与dispatch_group_leave(group)应该成对存在。
    //进入线程组中
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据1开始");
        
        dispatch_async(concurrentQueue, ^{
            sleep(5);
            NSLog(@"=========任务A");
            dispatch_group_leave(group);
        });
        
        dispatch_async(concurrentQueue, ^{
            sleep(5);
            NSLog(@"=========任务B");
        });
        NSLog(@"====数据1结束");
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据2开始");
        dispatch_async(concurrentQueue, ^{
            sleep(5);
            NSLog(@"=========任务C");
            dispatch_group_leave(group);
        });
        dispatch_async(concurrentQueue, ^{
            sleep(3);
            NSLog(@"=========任务D");
        });
        NSLog(@"====数据2结束");
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, concurrentQueue, ^{
        NSLog(@"====数据3开始");
        NSLog(@"=========任务E");
        NSLog(@"====数据3结束");
        dispatch_group_leave(group);
    });
    
    //统一处理结果：比如：网络请求的数据，统一处理问题，此处队列，视情况而定
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"====数据统一处理");
    });
}







@end
