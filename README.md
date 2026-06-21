# JustAd Pixel — Google Tag Manager Template

A Google Tag Manager custom **tag** template that installs the JustAd Pixel. It
initializes the global `justad()` command queue and asynchronously loads the
JustAd SDK using your Advertiser ID.

## What it does

This template is the sandboxed-JavaScript equivalent of the standard JustAd
snippet:

```html
<!-- JustAd Pixel -->
<script>
  window.justad = window.justad || function () {
    (window.justad.q = window.justad.q || []).push(arguments);
  };
</script>
<script async src="https://sdk.just.ad/a.js?a={{Advertiser_id}}"></script>
<!-- End JustAd Pixel -->
```

Because GTM custom templates run in [Sandboxed JavaScript](https://developers.google.com/tag-platform/tag-manager/templates/sandboxed-javascript)
(raw `<script>` injection is not allowed), the snippet is implemented with:

- `createArgumentsQueue('justad', 'justad.q')` — creates the global `window.justad`
  stub function that pushes its arguments onto the `window.justad.q` queue.
- `injectScript('https://sdk.just.ad/a.js?a=<Advertiser ID>')` — loads the SDK
  asynchronously.

## Configuration

| Field | Required | Description |
| --- | --- | --- |
| **Advertiser ID** | Yes | Your JustAd Advertiser ID. Passed to the SDK as the `a` query parameter. Can be set with a GTM variable, e.g. `{{Advertiser ID}}`. |

## Installation

1. In Google Tag Manager, go to **Templates → New** (Tag Templates).
2. Open the overflow menu and choose **Import**, then select `template.tpl`.
3. Save the template.
4. Create a new tag using the **JustAd Pixel** template, set the **Advertiser ID**,
   and add a trigger (typically **All Pages / Initialization**).

## Permissions

- **Accesses global variables**: `justad`, `justad.q` (read, write, execute).
- **Injects scripts**: `https://sdk.just.ad/*`.

## Repository structure

```
.
├── template.tpl      # The GTM custom template (import this into GTM)
├── metadata.yaml     # Community Template Gallery metadata
├── LICENSE           # Apache 2.0
└── README.md
```

## Publishing to the Community Template Gallery

This repo follows the [Community Template Gallery](https://developers.google.com/tag-platform/tag-manager/templates/gallery)
structure. Before submitting:

1. Confirm the **"Agree to the Community Template Gallery Terms of Service"** box
   is checked in the template's **Info** tab.
2. Update `metadata.yaml`:
   - Set `homepage` and `documentation` to real URLs.
   - Replace `REPLACE_WITH_COMMIT_SHA` with the commit SHA of the release.
3. Push to a public GitHub repo with `template.tpl`, `metadata.yaml`, and `LICENSE`
   at the repository root on the `main` branch, with **Issues** enabled.
4. Submit the repository URL at [tagmanager.google.com/gallery](https://tagmanager.google.com/gallery).

## License

Apache License 2.0. See [LICENSE](./LICENSE).
