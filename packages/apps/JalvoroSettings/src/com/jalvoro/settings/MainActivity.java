package com.jalvoro.settings;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Jalvoro Settings is a lightweight entry point to supported Android settings.
 * It intentionally delegates sensitive/system configuration to Android itself.
 */
public final class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle state) {
        super.onCreate(state);
        getWindow().setStatusBarColor(color(R.color.settings_background));
        getWindow().setNavigationBarColor(color(R.color.settings_background));
        buildScreen();
    }

    private void buildScreen() {
        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);
        scroll.setBackgroundColor(CANVAS);

        LinearLayout page = new LinearLayout(this);
        page.setOrientation(LinearLayout.VERTICAL);
        page.setPadding(dp(22), dp(26), dp(22), dp(26));
        scroll.addView(page);

        TextView brand = new TextView(this);
        brand.setText(R.string.brand);
        brand.setTextColor(color(R.color.accent));
        brand.setTextSize(12);
        brand.setLetterSpacing(0.18f);
        brand.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        page.addView(brand);

        TextView title = new TextView(this);
        title.setText(R.string.title);
        title.setTextColor(color(R.color.ink));
        title.setTextSize(34);
        title.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams titleParams = params();
        titleParams.topMargin = dp(8);
        page.addView(title, titleParams);

        TextView subtitle = new TextView(this);
        subtitle.setText(R.string.subtitle);
        subtitle.setTextColor(color(R.color.muted));
        subtitle.setTextSize(15);
        LinearLayout.LayoutParams subtitleParams = params();
        subtitleParams.topMargin = dp(4);
        subtitleParams.bottomMargin = dp(26);
        page.addView(subtitle, subtitleParams);

        addSection(page, R.string.section_device);
        addSetting(page, R.string.display, R.string.display_desc, Settings.ACTION_DISPLAY_SETTINGS);
        addSetting(page, R.string.sound, R.string.sound_desc, Settings.ACTION_SOUND_SETTINGS);
        addSetting(page, R.string.storage, R.string.storage_desc, Settings.ACTION_STORAGE_SETTINGS);

        addSection(page, R.string.section_connections);
        addSetting(page, R.string.wifi, R.string.wifi_desc, Settings.ACTION_WIFI_SETTINGS);
        addSetting(page, R.string.bluetooth, R.string.bluetooth_desc, Settings.ACTION_BLUETOOTH_SETTINGS);

        addSection(page, R.string.section_privacy);
        addSetting(page, R.string.privacy, R.string.privacy_desc, Settings.ACTION_PRIVACY_SETTINGS);
        addSetting(page, R.string.security, R.string.security_desc, Settings.ACTION_SECURITY_SETTINGS);
        addSetting(page, R.string.apps, R.string.apps_desc, Settings.ACTION_APPLICATION_SETTINGS);

        addSection(page, R.string.section_system);
        addSetting(page, R.string.about, R.string.about_desc, Settings.ACTION_DEVICE_INFO_SETTINGS);

        TextView footer = new TextView(this);
        footer.setText(R.string.footer);
        footer.setTextColor(color(R.color.muted));
        footer.setTextSize(12);
        footer.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams footerParams = params();
        footerParams.topMargin = dp(24);
        page.addView(footer, footerParams);

        setContentView(scroll);
    }

    private void addSection(LinearLayout page, int titleRes) {
        TextView title = new TextView(this);
        title.setText(titleRes);
        title.setTextColor(color(R.color.muted));
        title.setTextSize(11);
        title.setLetterSpacing(0.12f);
        title.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams p = params();
        p.topMargin = dp(8);
        p.bottomMargin = dp(10);
        page.addView(title, p);
    }

    private void addSetting(LinearLayout page, int titleRes, int descRes, final String action) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setPadding(dp(16), dp(15), dp(16), dp(15));
        card.setBackground(rounded(color(R.color.surface), dp(17)));
        card.setFocusable(true);
        card.setClickable(true);

        TextView title = new TextView(this);
        title.setText(titleRes);
        title.setTextColor(color(R.color.ink));
        title.setTextSize(16);
        title.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        card.addView(title, params());

        TextView description = new TextView(this);
        description.setText(descRes);
        description.setTextColor(color(R.color.muted));
        description.setTextSize(13);
        LinearLayout.LayoutParams descParams = params();
        descParams.topMargin = dp(4);
        card.addView(description, descParams);

        card.setContentDescription(getString(titleRes) + ". " + getString(descRes));
        card.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View view) {
                openSystemPage(action);
            }
        });

        LinearLayout.LayoutParams cardParams = params();
        cardParams.bottomMargin = dp(9);
        page.addView(card, cardParams);
    }

    private void openSystemPage(String action) {
        try {
            startActivity(new Intent(action));
        } catch (ActivityNotFoundException | SecurityException exception) {
            Toast.makeText(this, R.string.open_failed, Toast.LENGTH_SHORT).show();
        }
    }

    private int color(int resourceId) {
        return getResources().getColor(resourceId);
    }

    private LinearLayout.LayoutParams params() {
        return new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    private GradientDrawable rounded(int color, int radius) {
        GradientDrawable drawable = new GradientDrawable();
        drawable.setColor(color);
        drawable.setCornerRadius(radius);
        return drawable;
    }

    private int dp(int value) {
        return (int) (value * getResources().getDisplayMetrics().density + 0.5f);
    }
}
