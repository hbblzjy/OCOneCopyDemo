//
//  ViewController.m
//  OneDemo
//
//  Created by healthmanage on 16/11/23.
//  Copyright © 2016年 healthmanager. All rights reserved.
//

#import "ViewController.h"


// -------------Model定义，copyWithZone第一种实现（浅copy）
@interface Model1 : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger a;
@end

@implementation Model1
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
@end

// -------------Model定义，copyWithZone第二种实现（深copy）
@interface Model2 : NSObject <NSCopying>
@property (nonatomic, assign) NSInteger a;
@end

@implementation Model2
- (id)copyWithZone:(NSZone *)zone {
    Model2 *model = [[Model2 allocWithZone:zone] init];
    model.a = self.a;
    return model;
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //这是一个关于OC中深浅Copy的Demo：http://blog.csdn.net/hbblzjy/article/details/53318294
    
    // -------------此处以NSString为例探究框架类深浅copy
    // 不可变对象
    NSString *str = @"1";
    NSString *str1 = [str copy];
    NSString *str2 = [str mutableCopy];
    
    // 可变对象
    NSMutableString *mutableStr = [NSMutableString stringWithString:@"1"];
    NSMutableString *mutableStr1 = [mutableStr copy];
    NSMutableString *mutableStr2 = [mutableStr mutableCopy];
    
    // 打印对象的指针来确认是否创建了一个新的对象
    // 不可变对象原始指针
    NSLog(@"NSString----------%p", str);
    // 不可变对象copy后指针
    NSLog(@"NSString----------%p", str1);
    // 不可变对象mutalbeCopy后指针
    NSLog(@"NSString----------%p", str2);
    
    // 可变对象原始指针
    NSLog(@"NSString----------%p", mutableStr);
    // 可变对象copy后指针
    NSLog(@"NSString----------%p", mutableStr1);
    // 可变对象mutalbeCopy后指针
    NSLog(@"NSString----------%p", mutableStr2);
    
    
    // -------------分别选择上述两种model进行指针打印。
    Model1 *model11 = [[Model1 alloc] init];
    Model1 *copyModel11 = [model11 copy];
    
    NSLog(@"model111浅-----%p", model11);
    NSLog(@"model111浅-----%p", copyModel11);
    
    Model2 *model22 = [[Model2 alloc] init];
    Model2 *copyModel22 = [model22 copy];
    
    NSLog(@"model222深-----%p", model22);
    NSLog(@"model222深-----%p", copyModel22);
    
    // -------------容器对象和NSString浅copy的验证步骤一样
    NSArray *arr = [NSArray arrayWithObjects:@"1", nil];
    NSArray *copyArr = [arr copy];
    
    NSLog(@"容器对象---------%p", arr);
    NSLog(@"容器对象---------%p", copyArr);
    
    //------单层深copy
    NSArray *arr1 = [NSArray arrayWithObjects:@"1", nil];
    NSArray *copyArr1 = [arr1 mutableCopy];
    
    NSLog(@"单层深copy---------%p", arr1);
    NSLog(@"单层深copy---------%p", copyArr1);
    
    // 打印arr、copyArr内部元素进行对比
    NSLog(@"单层深copy---------%p", arr1[0]);
    NSLog(@"单层深copy---------%p", copyArr1[0]);
    
    //------双层深copy
    // 随意创建一个NSMutableString对象
    NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
    // 随意创建一个包涵NSMutableString的NSMutableArray对象
    NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
    // 将mutableString和mutableArr放入一个新的NSArray中
    NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
    // 通过官方文档提供的方式创建copy
    NSArray *testArrCopy = [[NSArray alloc] initWithArray:testArr copyItems:YES];
    
    // testArr和testArrCopy指针对比
    NSLog(@"双层深copy--------%p", testArr);
    NSLog(@"双层深copy--------%p", testArrCopy);
    
    // testArr和testArrCopy中元素指针对比
    // mutableString对比
    NSLog(@"双层深copy--------%p", testArr[0]);
    NSLog(@"双层深copy--------%p", testArrCopy[0]);
    // mutableArr对比
    NSLog(@"双层深copy--------%p", testArr[1]);
    NSLog(@"双层深copy--------%p", testArrCopy[1]);
    
    // mutableArr中的元素对比，即mutalbeString1对比
    NSLog(@"双层深copy--------%p", testArr[1][0]);
    NSLog(@"双层深copy--------%p", testArrCopy[1][0]);
    
    //------完全深copy
    // 随意创建一个NSMutableString对象
    NSMutableString *mutableString00 = [NSMutableString stringWithString:@"1"];
    // 随意创建一个包涵NSMutableString的NSMutableArray对象
    NSMutableString *mutalbeString11 = [NSMutableString stringWithString:@"1"];
    NSMutableArray *mutableArr00 = [NSMutableArray arrayWithObjects:mutalbeString11, nil];
    // 将mutableString和mutableArr放入一个新的NSArray中
    NSArray *testArr00 = [NSArray arrayWithObjects:mutableString00, mutableArr00, nil];
    // 通过归档、解档方式创建copy
    NSArray *testArrCopy00 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:testArr00]];
    
    // testArr和testArrCopy指针对比
    NSLog(@"完全深copy------%p", testArr00);
    NSLog(@"完全深copy------%p", testArrCopy00);
    
    // testArr和testArrCopy中元素指针对比
    // mutableString对比
    NSLog(@"完全深copy------%p", testArr00[0]);
    NSLog(@"完全深copy------%p", testArrCopy00[0]);
    // mutableArr对比
    NSLog(@"完全深copy------%p", testArr00[1]);
    NSLog(@"完全深copy------%p", testArrCopy00[1]);
    
    // mutableArr中的元素对比，即mutalbeString1对比
    NSLog(@"完全深copy------%p", testArr00[1][0]);
    NSLog(@"完全深copy------%p", testArrCopy00[1][0]);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
