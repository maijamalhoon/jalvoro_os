package com.jalvoro.controlcenter;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.provider.Settings;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.GridLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Safe, launchable control hub for the Jalvoro AOSP prototype.
 * Delegates system changes to Android settings; it is not privileged SystemUI.
 */
public final class MainActivity extends Activity {
    private int dp(float value) { return (int) (value * getResources().getDisplayMetrics().density + 0.5f); }
    private int color(int id) { return getResources().getColor(id, getTheme()); }

    @Override protected void onCreate(Bundle state) {
        super.onCreate(state);
        getWindow().setStatusBarColor(color(R.color.canvas));
        getWindow().setNavigationBarColor(color(R.color.canvas));
        buildUi();
    }

    private void buildUi() {
        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);
        scroll.setBackgroundColor(color(R.color.canvas));
        LinearLayout page = new LinearLayout(this);
        page.setOrientation(LinearLayout.VERTICAL);
        page.setPadding(dp(22), dp(24), dp(22), dp(28));
        scroll.addView(page);

        TextView brand = new TextView(this);
        brand.setText(R.string.brand); brand.setTextColor(color(R.color.accent));
        brand.setTextSize(12); brand.setLetterSpacing(0.18f);
        brand.setTypeface(Typeface.DEFAULT, Typeface.BOLD); page.addView(brand);

        TextView title = new TextView(this);
        title.setText(R.string.title); title.setTextColor(color(R.color.ink));
        title.setTextSize(32); title.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams tp = params(); tp.topMargin = dp(8); page.addView(title, tp);

        TextView subtitle = new TextView(this);
        subtitle.setText(R.string.subtitle); subtitle.setTextColor(color(R.color.muted)); subtitle.setTextSize(15);
        LinearLayout.LayoutParams sp = params(); sp.topMargin = dp(4); sp.bottomMargin = dp(22); page.addView(subtitle, sp);

        addSection(page, R.string.connections);
        GridLayout connections = createGrid(page);
        addCard(connections, R.string.wifi, R.string.wifi_desc, Settings.ACTION_WIFI_SETTINGS);
        addCard(connections, R.string.bluetooth, R.string.bluetooth_desc, Settings.ACTION_BLUETOOTH_SETTINGS);
        addCard(connections, R.string.display, R.string.display_desc, Settings.ACTION_DISPLAY_SETTINGS);
        addCard(connections, R.string.sound, R.string.sound_desc, Settings.ACTION_SOUND_SETTINGS);
        addCard(connections, R.string.battery, R.string.battery_desc, Settings.ACTION_BATTERY_SAVER_SETTINGS);
        addCard(connections, R.string.privacy, R.string.privacy_desc, Settings.ACTION_PRIVACY_SETTINGS);
        addSection(page, R.string.system);
        GridLayout system = createGrid(page);
        addCard(system, R.string.about, R.string.about_desc, Settings.ACTION_DEVICE_INFO_SETTINGS);

        TextView footer = new TextView(this);
        footer.setText(R.string.footer); footer.setTextColor(color(R.color.muted));
        footer.setTextSize(12); footer.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams fp = params(); fp.topMargin = dp(22); page.addView(footer, fp);
        setContentView(scroll);
    }

    private void addSection(LinearLayout page, int labelRes) {
        TextView label = new TextView(this);
        label.setText(labelRes); label.setTextColor(color(R.color.muted)); label.setTextSize(11);
        label.setLetterSpacing(0.12f); label.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams p = params(); p.topMargin = dp(8); p.bottomMargin = dp(10); page.addView(label, p);
    }

    private GridLayout createGrid(LinearLayout page) {
        GridLayout grid = new GridLayout(this);
        grid.setColumnCount(2);
        grid.setUseDefaultMargins(false);
        page.addView(grid, params());
        return grid;
    }

    private void addCard(GridLayout grid, int titleRes, int descRes, final String action) {
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        card.setMinimumHeight(dp(132));
        card.setPadding(dp(14), dp(14), dp(14), dp(14));
        GradientDrawable shape = new GradientDrawable();
        shape.setColor(color(R.color.surface));
        shape.setCornerRadius(dp(18));
        shape.setStroke(dp(1), color(R.color.outline));
        card.setBackground(shape);
        card.setFocusable(true);
        card.setClickable(true);
        card.setContentDescription(getString(titleRes) + ". " + getString(descRes));

        TextView symbol = new TextView(this);
        symbol.setText("•");
        symbol.setTextColor(color(R.color.accent));
        symbol.setTextSize(25);
        symbol.setGravity(Gravity.CENTER);
        GradientDrawable symbolBg = new GradientDrawable();
        symbolBg.setColor(color(R.color.accent_soft));
        symbolBg.setCornerRadius(dp(13));
        symbol.setBackground(symbolBg);
        LinearLayout.LayoutParams symbolParams = new LinearLayout.LayoutParams(dp(38), dp(38));
        card.addView(symbol, symbolParams);

        TextView title = new TextView(this);
        title.setText(titleRes);
        title.setTextColor(color(R.color.ink));
        title.setTextSize(15);
        title.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams titleParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        titleParams.topMargin = dp(12);
        card.addView(title, titleParams);

        TextView description = new TextView(this);
        description.setText(descRes);
        description.setTextColor(color(R.color.muted));
        description.setTextSize(12);
        LinearLayout.LayoutParams descParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        descParams.topMargin = dp(4);
        card.addView(description, descParams);

        card.setOnClickListener(v -> openSettings(action));
        GridLayout.LayoutParams cardParams = new GridLayout.LayoutParams(
                GridLayout.spec(GridLayout.UNDEFINED, 1f),
                GridLayout.spec(GridLayout.UNDEFINED));
        cardParams.width = 0;
        cardParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        cardParams.setMargins(dp(0), dp(0), dp(10), dp(10));
        grid.addView(card, cardParams);
    }

    private void openSettings(String action) {
        try { startActivity(new Intent(action)); }
        catch (ActivityNotFoundException | SecurityException exception) {
            Toast.makeText(this, R.string.unavailable, Toast.LENGTH_SHORT).show();
        }
    }

    private LinearLayout.LayoutParams params() {
        return new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    }
}
