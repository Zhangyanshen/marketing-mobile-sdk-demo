# marketing mobile sdk demo

营销解决方案

## 移动端Demo

### Android Demo使用说明

##### 1. 运行
demo地址: https://github.com/NewBanker/marketing-mobile-sdk-demo/

AndroidStudio导入工程的android目录

##### 2. 更新aar
###### 1. 下载newbanker-marketing.aar包，[aar包下载地址](https://sunpack.newbanker.work)
***（注意：上面放置的是以时间戳结尾的aar文件，下载最新的aar文件后手动改成newbanker-marketing.aar再集成到工程）***
###### 2. 将下载好的newbanker-marketing.aar文件替换android/app/libs目录下的原aar文件
###### 3. 清空之前的aar缓存，参考Andrid常见问题。

### iOS Demo使用说明

##### 1.下载demo工程

下载本demo工程到本地。

> demo中含有2个项目，`NBFrameworkDemo`是OC版本的，`NBFrameworkDemo-Swift`是Swift版本的，使用的是Swift 5开发的。另外Swift版本的Demo没有引入分享的SDK，如果需要查看分享功能，需要参照OC版本的demo先添加分享SDK。

##### 2.下载iOS SDK

从 [SDK地址](https://log.newbanker.work/sunis-andriod-aar/)  下载iOS SDK并解压。

<img src="./ios_images/1.png">

##### 3.替换Demo工程中的SDK

将第2步解压出来的文件拷贝到`ios/NBFrameworkDemo/NBFrameworkDemo`目录下进行替换。

<img src="./ios_images/2.png" width="507" height="151">

##### 4.运行demo工程

打开iOS项目运行。

## 常见问题

### iOS常见问题

##### 1.如果集成SDK后报Undefine symbols __isPlatformVersionAtLeast，请将Xcode升级到11

### Android常见问题

##### 1.aar缓存问题
如果之前集成过一遍aar包，需要清空之前的aar缓存。
在工程根目录下执行以下命令：
```
rm -rf android/.idea/cache/
rm -rf android/.idea/libraries/
```
然后重新Sync Android工程
##### 2.AndroidStudio版本兼容问题
***注意demo工程是在AndroidStudio 3.5.3创建的，如果demo工程无法正常打开，考虑升级AS***
