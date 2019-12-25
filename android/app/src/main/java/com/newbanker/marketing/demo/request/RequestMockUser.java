package com.newbanker.marketing.demo.request;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.text.TextUtils;
import android.widget.Toast;

import com.google.gson.Gson;
import com.newbanker.marketing.MarketingHelper;

import java.util.List;


public class RequestMockUser extends AsyncTask<MockCallback, Void, String> {

    private ProgressDialog dialog;
    private Context mContext;
    private AlertDialog selectDialog;
    private static final String url = "https://yg-marketing-api.newtamp.cn/api/v1/user/list";

    private MockCallback mMockCallback;
    public RequestMockUser(Context context) {
        this.mContext = context;
    }

    protected void onPreExecute() {
        dialog = new ProgressDialog(mContext);
        dialog.setMessage("请求中");
        dialog.show();
    }

    @Override
    protected void onPostExecute(String result) {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
        if (!TextUtils.isEmpty(result)) {
            MockUser mockUser = new Gson().fromJson(result, MockUser.class);
            if(mockUser.success){
                showSingleAlertDialog(mockUser.param);
            }else {
                mMockCallback.onFailed();
                Toast.makeText(mContext, TextUtils.isEmpty(mockUser.msg)?mockUser.msg:"获取失败", Toast.LENGTH_SHORT).show();
            }
        }
    }
    private void showSingleAlertDialog(final List<MockUser.User> users){
        final String[] items = new String[users.size()];
        final String token = MarketingHelper.getToken();
        int[] selectIndex = {0};
        for (int i = 0; i < users.size(); i++) {
            MockUser.User user = users.get(i);
            items[i] = user.name;
            if(user.token.equals(token)){
                selectIndex[0] = i;
            }
        }
        AlertDialog.Builder alertBuilder = new AlertDialog.Builder(mContext);
        alertBuilder.setTitle("请选择登录用户");
        final int[] finalSelectIndex = selectIndex;
        alertBuilder.setSingleChoiceItems(items, selectIndex[0], new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                finalSelectIndex[0] = i;
            }
        });

        alertBuilder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                String token = users.get(finalSelectIndex[0]).token;
                mMockCallback.onSuccess(token);
                selectDialog.dismiss();
            }
        });

        alertBuilder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                selectDialog.dismiss();
            }
        });

        selectDialog = alertBuilder.create();
        selectDialog.show();
    }


    @Override
    protected String doInBackground(MockCallback... mockCallbacks) {
        mMockCallback = mockCallbacks[0];
        return HttpUtils.get(url);
    }

}
