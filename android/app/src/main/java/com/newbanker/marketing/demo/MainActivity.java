package com.newbanker.marketing.demo;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;

import com.newbanker.marketing.EntryEnum;
import com.newbanker.marketing.MarketingHelper;
import com.newbanker.marketing.demo.request.MockCallback;
import com.newbanker.marketing.demo.request.RequestMockUser;

public class MainActivity extends AppCompatActivity {

    private String[] data = {"财经资讯", "财经早报", "智能名片", "营销线索", "访客记录", "营销分析"};
    private EntryEnum[] entries = {
            EntryEnum.NBMarketingNews,
            EntryEnum.NBMarketingHeadline,
            EntryEnum.NBMarketingCard,
            EntryEnum.NBMarketingLeads,
            EntryEnum.NBMarketingActivity,
            EntryEnum.NBMarketingAnalysis,
    };

    EditText customTokenEdit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(
                MainActivity.this,
                android.R.layout.simple_list_item_1, data);

        ListView listView = findViewById(R.id.list_view);

        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                gotoMainActivity(entries[position]);
            }
        });

        customTokenEdit = findViewById(R.id.customToken);
        customTokenEdit.setText(MarketingHelper.getToken());

    }

    @Override
    protected void onStop() {
        super.onStop();
        updateToken();
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        updateToken();
    }

    private void updateToken(){
        String token = customTokenEdit.getText().toString();
        MarketingHelper.setToken(token);
    }

    private void gotoMainActivity(EntryEnum entry){
        this.updateToken();
        MarketingHelper.startActivity(MainActivity.this, entry);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.select_user) {
            new RequestMockUser(this).execute(new MockCallback() {
                @Override
                public void onSuccess(String token) {
                    customTokenEdit.setText(token);
                }

                @Override
                public void onFailed() {

                }
            });
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


}
