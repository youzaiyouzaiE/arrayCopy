//
//  ViewController.m
//  ArrayCopyTest
//
//  Created by jiahui on 2017/8/11.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "ViewController.h"
@interface Book : NSObject <NSCopying,NSCoding>

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, copy) NSString *auther;

@end

@implementation Book

- (id)copyWithZone:(nullable NSZone *)zone {
    Book *bookCopy = [Book allocWithZone:zone];
    bookCopy.pages = self.pages;
    return bookCopy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.pages] forKey:NSStringFromSelector(@selector(pages))];
    [aCoder encodeObject:self.auther forKey:NSStringFromSelector(@selector(auther))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.pages = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(pages))] integerValue];
    self.auther = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(auther))];
    return self;
}


@end

@interface ViewController ()

@property (nonatomic, copy) NSArray *arrayBooks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self arrayCopyTest];
    [self removeArrayObjects:@1];
}

/////
- (void)arrayCopyTest {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSInteger i = 0; i< 10; i++) {
        Book *book = [Book new];
        book.pages = 200;
        [mutableArray addObject:book];
    }
    NSLog(@" 指针地址为：%p books: %@",mutableArray,mutableArray);
    
    self.arrayBooks = mutableArray;
    NSLog(@"self 指针地址为：%p \n self books: %@",self.arrayBooks,self.arrayBooks);
    
    Book *lastBook = mutableArray.lastObject;
    lastBook.pages = 300;
    NSLog(@" 指针地址为：%p books: %@",mutableArray,mutableArray);
    
    NSLog(@"self 指针地址为：%p \n self books: %@",self.arrayBooks,self.arrayBooks);
    Book *selfarrayLastBook = self.arrayBooks.lastObject;
    NSLog(@"self last Book 指针地址为：%p ",selfarrayLastBook);
    
    NSArray *copyArray = [mutableArray mutableCopy];
    NSLog(@"copyArray 指针地址为：%p copyArray: %@",copyArray,copyArray);
    
    NSMutableArray *booksArray = [mutableArray mutableCopy];
    Book *newBook = [[Book alloc] init];
    newBook.pages = 500;
    [mutableArray addObject:newBook];
    
    Book *copyBook = [newBook copy];///实现copyWithZone:
    [booksArray addObject:copyBook];
    
    newBook.pages = 600;
    Book *booksLast = booksArray.lastObject;
    NSLog(@"self last Book 指针地址为：%p ",booksLast);
    booksLast.auther = @"王朔";
    
    NSLog(@"booksArray 指针地址为：%p booksArray: %@",booksArray,booksArray);
    ///深copy!  ///要实现NSCoding 协议
    NSArray *trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:booksArray]];
    NSLog(@"trueDeepCopyArray 指针地址为：%p trueDeepCopyArray: %@",trueDeepCopyArray,trueDeepCopyArray);
    
    Book *autherBook = trueDeepCopyArray.lastObject;
    NSLog(@"self last Book 指针地址为：%p ",autherBook);
}

///数组里有移除多个相同元素
- (void)removeArrayObjects:(NSNumber *)object {
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@1,@1,@1,@3,@4,@5,@1,@6,@2,@1]];
    NSIndexSet *indexSet = [array indexesOfObjectsPassingTest:^BOOL(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj isEqualToNumber:object];
    }];
    [array removeObjectsAtIndexes:indexSet];
    NSLog(@"要删除的位置 %@", indexSet);
    NSLog(@"删除后的数据 %@", array);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
