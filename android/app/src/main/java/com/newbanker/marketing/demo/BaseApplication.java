package com.newbanker.marketing.demo;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application;
import android.content.ComponentName;
import android.content.Context;
import android.text.TextUtils;

import com.newbanker.marketing.Configuration;
import com.newbanker.marketing.IShare;
import com.newbanker.marketing.MarketingHelper;
import com.newbanker.marketing.ShareCallback;
import com.newbanker.marketing.ShareEnum;
import com.newbanker.marketing.demo.utils.WechatShareUtils;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.socialize.Config;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.common.ResContainer;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMWeb;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class BaseApplication extends Application implements IShare {

    private final int SUCCESS = 200;
    private final int ERROR = 0;
    private final int CANCEL = -1;

    @Override
    public void onCreate() {
        super.onCreate();

        /**
         * 营销SDK初始化
         * 示例：
         * https://yg-marketing-api.newtamp.cn 为移动端请求地址
         * https://yg-share.newtamp.cn 为h5请求地址
         */
        MarketingHelper.init(this, new Configuration().setBaseService("https://yg-marketing-api.newtamp.cn")
                .setBaseH5("https://yg-share.newtamp.cn"));

        // 营销SDK设置分享接口
        MarketingHelper.resetShareContext(this);

        RNUMConfigure.init(this, "5df0977c3fc1958fd2000717", "Umeng", UMConfigure.DEVICE_TYPE_PHONE,
                "");
    }

    /**
     * 分享微信、朋友圈
     * @param activity 当前页面
     * @param maps  分享携带的map
     * @param callback 分享回调
     */
    @Override
    public void share(Activity activity, Map<String, Object> maps, ShareCallback callback) {
        String text = (String)maps.get("text");
        String title = (String)maps.get("title");
        String link = (String)maps.get("link");
        String icon = (String)maps.get("icon");
        int platform = (int)maps.get("platform");


        if (!TextUtils.isEmpty(link)) {
            UMWeb web = new UMWeb(link);
            web.setTitle(title);
            web.setDescription(text);
            if (getImage(icon)!=null){
                web.setThumb(getImage(icon));
            }

            ActivityManager am = (ActivityManager)getSystemService(Context.ACTIVITY_SERVICE);
            ComponentName cn = am.getRunningTasks(1).get(0).topActivity;

            new ShareAction(activity).withText(text)
                    .withMedia(web)
                    .setPlatform(getShareMedia(platform))
                    .setCallback(getUMShareListener(callback))
                    .share();
            return;
        } else if (getImage(icon)!=null){
            if(icon.startsWith("http")){
                new ShareAction(activity).withText(text)
                        .withMedia(getImage(icon))
                        .setPlatform(getShareMedia(platform))
                        .setCallback(getUMShareListener(callback))
                        .share();
            }else if(icon.startsWith("file")){
                List<String> list = Arrays.asList(icon);
                if(ShareEnum.WEIXIN == platform){
                    shareImagesToFriends(title, list);
                }else{
                    shareImagesToWechatCircle(title, list);
                }
            }

        } else {
            new ShareAction(activity).withText(text)
                    .setPlatform(getShareMedia(platform))
                    .setCallback(getUMShareListener(callback))
                    .share();
        }

    }

    /**
     * 分享微信小程序
     * @param activity 当前页面
     * @param maps  分享携带的map
     * @param callback 分享回调
     */
    @Override
    public void shareMin(Activity activity, Map<String, Object> maps, ShareCallback callback) {
        String text = (String)maps.get("text");
        String title = (String)maps.get("title");
        String page = (String)maps.get("page");
        String img = (String)maps.get("img");
        String originalId = (String)maps.get("originalId");
        int platform = (int)maps.get("platform");

        UMMin umMin = new UMMin("http://mobile.umeng.com/social");
        //兼容低版本的网页链接
        if (getImage(img)!=null){
            umMin.setThumb(getImage(img));
        }
        // 小程序消息封面图片
        umMin.setTitle(title);
        // 小程序消息title
        umMin.setDescription(text);
        // 小程序消息描述
        umMin.setPath(page);
        //小程序页面路径
        umMin.setUserName("gh_f501ac1af8bb");
        // 小程序原始id,在微信平台查询
        Config.setMiniPreView();
        new ShareAction(activity)
                .withMedia(umMin)
                .setPlatform(getShareMedia(platform))
                .setCallback(getUMShareListener(callback)).share();
    }

    private UMImage getImage(String url){
        if (TextUtils.isEmpty(url)){
            return null;
        }else if(url.startsWith("http")){
            return new UMImage(this, url);
        }else if(url.startsWith("/")){
            return new UMImage(this, url);
        }else if(url.startsWith("res")){
            return new UMImage(this, ResContainer.getResourceId(this,"drawable",url.replace("res/","")));
        }else {
            return new UMImage(this, url);
        }
    }

    private SHARE_MEDIA getShareMedia(int num){
        switch (num){
            case ShareEnum.WEIXIN:
                return SHARE_MEDIA.WEIXIN;
            case ShareEnum.WEIXIN_CIRCLE:
                return SHARE_MEDIA.WEIXIN_CIRCLE;
            default:
                return SHARE_MEDIA.WEIXIN;
        }
    }

    private UMShareListener getUMShareListener(final ShareCallback callback){
        return new UMShareListener() {
            @Override
            public void onStart(SHARE_MEDIA share_media) {

            }

            @Override
            public void onResult(SHARE_MEDIA share_media) {
                callback.invoke(SUCCESS, "success");
            }

            @Override
            public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                callback.invoke(ERROR, throwable.getMessage());
            }

            @Override
            public void onCancel(SHARE_MEDIA share_media) {
                callback.invoke(CANCEL, "cancel");
            }
        };
    }

    public void shareImagesToWechatCircle(String title, List files) {
        WechatShareUtils.share(
                this,
                WechatShareUtils.NAME_ACTIVITY_WECHAT_CIRCLE_PUBLISH,
                title,
                files
        );
    }

    public void shareImagesToFriends(String title, List files) {
        WechatShareUtils.share(
                this,
                WechatShareUtils.NAME_ACTIVITY_WECHAT_FRIEND,
                title,
                files
        );
    }

    {

        PlatformConfig.setWeixin("wxd36e2a5336d63858", "6129d9745f2536df8f3a6de9956a28ac");

    }


}
