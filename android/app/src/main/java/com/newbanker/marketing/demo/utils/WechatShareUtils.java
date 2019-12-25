package com.newbanker.marketing.demo.utils;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.StrictMode;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by suetming on 2018/5/11.
 */
public class WechatShareUtils {

    public static final String PACKAGE_NAME = "com.tencent.mm";

    /**
     * 微信朋友圈发送界面
     */
    public static final String NAME_ACTIVITY_WECHAT_CIRCLE_PUBLISH = "com.tencent.mm.ui.tools.ShareToTimeLineUI";

    /**
     * 微信好友发送界面
     */
    public static final String NAME_ACTIVITY_WECHAT_FRIEND = "com.tencent.mm.ui.tools.ShareImgUI";


    /**
     * 分享
     * @param context
     * @param activityName 分享类别。
     *        NAME_ACTIVITY_WECHAT_CIRCLE_PUBLISH: 表示朋友圈发布界面；
     *        NAME_ACTIVITY_WECHAT_FRIEND: 表示发送给好友。
     * @param text      文字内容，只对朋友圈有效
     * @param files     本地图片全路径列表
     */
    public static void share(Context context, String activityName, String text, List files) {
        if (!isAvaliable(context)) {
            return;
        }
        StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
        StrictMode.setVmPolicy(builder.build());
        if (Build.VERSION.SDK_INT >= 23)
            builder.detectFileUriExposure();

        Intent intent = new Intent();
        ComponentName comp = new ComponentName(PACKAGE_NAME, activityName);
        intent.setComponent(comp);
        if (text == null || text.length() == 0) {

        } else {
            intent.putExtra("Kdescription", text); // 作用于发朋友圈，对好友不会有影响
            intent.putExtra(Intent.EXTRA_TEXT, text);
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        if (files.size() > 1) {
            intent.setAction(Intent.ACTION_SEND_MULTIPLE);
            intent.setType("image/*");
            ArrayList<Uri> imageUris = new ArrayList<>();
            for (Object f : files) {
                imageUris.add(Uri.parse((String)f));
            }
            intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, imageUris);
        } else {
            intent.setAction(Intent.ACTION_SEND);
            intent.setType("image/*");
            intent.putExtra(Intent.EXTRA_STREAM, Uri.parse((String)files.get(0)));
        }
        context.startActivity(intent);
    }

    /**
     * 判断手机内是否安装了微信APP
     *
     * @param context
     * @return
     */
    private static boolean isAvaliable(Context context) {
        PackageManager packageManager = context.getPackageManager();// 获取packagemanager
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);// 获取所有已安装程序的包信息
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals(PACKAGE_NAME)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void openWeChat(Context context){
        Intent intent = new Intent();
        ComponentName cmp =new ComponentName("com.tencent.mm","com.tencent.mm.ui.LauncherUI");

        intent.setAction(Intent.ACTION_MAIN);

        intent.addCategory(Intent.CATEGORY_LAUNCHER);

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        intent.setComponent(cmp);

        context.startActivity(intent);
    }
}
