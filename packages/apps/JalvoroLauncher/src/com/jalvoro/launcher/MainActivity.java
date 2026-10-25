package com.jalvoro.launcher;

import android.app.Activity;
import android.app.WallpaperManager;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.content.Context;
import android.widget.EditText;
import android.widget.GridLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Minimal, dependency-free home screen for the Jalvoro AOSP prototype.
 * This deliberately uses platform widgets so it can be built directly by Soong.
 */
public final class MainActivity extends Activity {
    private static final int INK = Color.rgb(20, 28, 48);
    private static final int MUTED = Color.rgb(103, 115, 139);
    private static final int ACCENT = Color.rgb(72, 104, 232);
    private static final int SURFACE = Color.WHITE;

    private final List<ResolveInfo> allApps = new ArrayList<>();
    private LinearLayout appList;
    private EditText search;
    private TextView clock;
    private TextView date;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setStatusBarColor(Color.rgb(235, 241, 255));
        getWindow().setNavigationBarColor(Color.rgb(235, 241, 255));
        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR | View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR);
        buildHome();
        loadApps();
        renderApps("");
        updateDateTime();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (appList != null) {
            loadApps();
            renderApps(search == null ? "" : search.getText().toString());
            updateDateTime();
        }
    }

    private void buildHome() {
        ScrollView scroll = new ScrollView(this);
        scroll.setFillViewport(true);
        scroll.setBackground(new GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                new int[] { Color.rgb(235, 241, 255), Color.rgb(248, 249, 253) }));

        LinearLayout page = new LinearLayout(this);
        page.setOrientation(LinearLayout.VERTICAL);
        page.setPadding(dp(22), dp(26), dp(22), dp(22));
        scroll.addView(page);

        TextView brand = new TextView(this);
        brand.setText("JALVORO");
        brand.setTextColor(ACCENT);
        brand.setTextSize(13);
        brand.setLetterSpacing(0.18f);
        brand.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        page.addView(brand);

        clock = new TextView(this);
        clock.setTextColor(INK);
        clock.setTextSize(42);
        clock.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams clockParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        clockParams.topMargin = dp(16);
        page.addView(clock, clockParams);

        date = new TextView(this);
        date.setTextColor(MUTED);
        date.setTextSize(15);
        page.addView(date);

        TextView welcome = new TextView(this);
        welcome.setText("A calmer home for everything.");
        welcome.setTextColor(INK);
        welcome.setTextSize(17);
        welcome.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        LinearLayout.LayoutParams welcomeParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        welcomeParams.topMargin = dp(28);
        welcomeParams.bottomMargin = dp(12);
        page.addView(welcome, welcomeParams);

        LinearLayout searchCard = new LinearLayout(this);
        searchCard.setGravity(Gravity.CENTER_VERTICAL);
        searchCard.setPadding(dp(16), dp(4), dp(16), dp(4));
        searchCard.setBackground(rounded(Color.WHITE, dp(18)));
        search = new EditText(this);
        search.setSingleLine(true);
        search.setTextSize(15);
        search.setTextColor(INK);
        search.setHintTextColor(MUTED);
        search.setHint("Search apps");
        search.setBackgroundColor(Color.TRANSPARENT);
        search.setPadding(0, dp(10), 0, dp(10));
        search.setCompoundDrawablesWithIntrinsicBounds(
                android.R.drawable.ic_menu_search, 0, 0, 0);
        search.setCompoundDrawablePadding(dp(10));
        searchCard.addView(search, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        LinearLayout.LayoutParams searchParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        searchParams.bottomMargin = dp(20);
        page.addView(searchCard, searchParams);

        TextView appsTitle = new TextView(this);
        appsTitle.setText("YOUR APPS");
        appsTitle.setTextColor(MUTED);
        appsTitle.setTextSize(12);
        appsTitle.setLetterSpacing(0.12f);
        appsTitle.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        page.addView(appsTitle);

        appList = new LinearLayout(this);
        appList.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams listParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        listParams.topMargin = dp(12);
        page.addView(appList, listParams);

        TextView footer = new TextView(this);
        footer.setText("Jalvoro OS • Early prototype");
        footer.setTextColor(MUTED);
        footer.setTextSize(12);
        footer.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams footerParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        footerParams.topMargin = dp(28);
        page.addView(footer, footerParams);

        setContentView(scroll);
        search.addTextChangedListener(new android.text.TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
            @Override public void onTextChanged(CharSequence s, int start, int before, int count) {
                renderApps(s == null ? "" : s.toString());
            }
            @Override public void afterTextChanged(android.text.Editable e) {}
        });
    }

    private void loadApps() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        List<ResolveInfo> resolved = getPackageManager().queryIntentActivities(intent, 0);
        allApps.clear();
        for (ResolveInfo item : resolved) {
            if (item.activityInfo == null || getPackageName().equals(item.activityInfo.packageName)) {
                continue;
            }
            allApps.add(item);
        }
        Collections.sort(allApps, new Comparator<ResolveInfo>() {
            @Override public int compare(ResolveInfo a, ResolveInfo b) {
                return labelOf(a).compareToIgnoreCase(labelOf(b));
            }
        });
    }

    private void renderApps(String query) {
        if (appList == null) return;
        appList.removeAllViews();
        String normalized = query == null ? "" : query.trim().toLowerCase(Locale.ROOT);
        List<ResolveInfo> visible = new ArrayList<>();
        for (ResolveInfo app : allApps) {
            if (labelOf(app).toLowerCase(Locale.ROOT).contains(normalized)) visible.add(app);
        }

        if (visible.isEmpty()) {
            TextView empty = new TextView(this);
            empty.setText(normalized.isEmpty() ? "No launchable apps found." : "No apps match “" + query + "”.");
            empty.setTextColor(MUTED);
            empty.setPadding(dp(4), dp(18), dp(4), dp(18));
            appList.addView(empty);
            return;
        }

        GridLayout grid = new GridLayout(this);
        grid.setColumnCount(4);
        int width = getResources().getDisplayMetrics().widthPixels
                - dp(44) - dp(24);
        int cellWidth = Math.max(dp(62), width / 4);
        for (final ResolveInfo app : visible) {
            LinearLayout cell = new LinearLayout(this);
            cell.setOrientation(LinearLayout.VERTICAL);
            cell.setGravity(Gravity.CENTER_HORIZONTAL);
            cell.setPadding(dp(3), dp(10), dp(3), dp(10));
            cell.setBackground(rounded(Color.argb(70, 255, 255, 255), dp(16)));

            android.widget.ImageView icon = new android.widget.ImageView(this);
            try {
                icon.setImageDrawable(app.loadIcon(getPackageManager()));
            } catch (RuntimeException ignored) {
                icon.setImageResource(android.R.drawable.sym_def_app_icon);
            }
            cell.addView(icon, new LinearLayout.LayoutParams(dp(42), dp(42)));

            TextView label = new TextView(this);
            label.setText(labelOf(app));
            label.setTextColor(INK);
            label.setTextSize(11);
            label.setGravity(Gravity.CENTER);
            label.setMaxLines(2);
            label.setEllipsize(android.text.TextUtils.TruncateAt.END);
            LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, dp(34));
            labelParams.topMargin = dp(7);
            cell.addView(label, labelParams);

            cell.setContentDescription(labelOf(app));
            cell.setOnClickListener(new View.OnClickListener() {
                @Override public void onClick(View v) { launch(app); }
            });
            GridLayout.LayoutParams params = new GridLayout.LayoutParams();
            params.width = cellWidth;
            params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
            params.setMargins(dp(2), dp(2), dp(2), dp(8));
            grid.addView(cell, params);
        }
        appList.addView(grid);
    }

    private String labelOf(ResolveInfo info) {
        CharSequence label = info.loadLabel(getPackageManager());
        return label == null ? info.activityInfo.packageName : label.toString();
    }

    private void launch(ResolveInfo app) {
        try {
            Intent launch = new Intent(Intent.ACTION_MAIN);
            launch.addCategory(Intent.CATEGORY_LAUNCHER);
            launch.setClassName(app.activityInfo.packageName, app.activityInfo.name);
            launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(launch);
            if (search != null) {
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                if (imm != null) imm.hideSoftInputFromWindow(search.getWindowToken(), 0);
            }
        } catch (ActivityNotFoundException | SecurityException exception) {
            Toast.makeText(this, "This app could not be opened.", Toast.LENGTH_SHORT).show();
        }
    }

    private void updateDateTime() {
        if (clock != null) clock.setText(DateFormat.getTimeInstance(DateFormat.SHORT).format(new Date()));
        if (date != null) date.setText(DateFormat.getDateInstance(DateFormat.FULL).format(new Date()));
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
