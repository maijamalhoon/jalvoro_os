# Jalvoro AOSP product integration

This folder contains a product fragment that adds the Jalvoro app modules to an AOSP product image.

## Apply to a product

1. Copy or integrate the Jalvoro repository into the AOSP source tree so the modules exist at:
   - `packages/apps/JalvoroLauncher`
   - `packages/apps/JalvoroSettings`
2. Copy `device/jalvoro/common/jalvoro_apps.mk` into the matching path in your AOSP tree.
3. In the selected product's `*.mk` file, include it:

   ```make
   $(call inherit-product, device/jalvoro/common/jalvoro_apps.mk)
   ```

4. Build the modules with `m JalvoroLauncher JalvoroSettings`, then build the selected product target.

## Important limits

This fragment only adds the two apps to `PRODUCT_PACKAGES`. It does not select a default HOME activity, replace Launcher3, modify SystemUI, or make a complete Jalvoro OS product. The correct product file and lunch target must be confirmed against the exact AOSP branch in use. Boot and test the resulting image in Cuttlefish before treating the integration as working.
