const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright');

const root = path.resolve(__dirname, '..');
const types = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.jpg': 'image/jpeg', '.png': 'image/png', '.mp4': 'video/mp4' };

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    const page = await browser.newPage();
    const missing = [], errors = [];
    page.on('pageerror', error => errors.push(error.message));
    await page.route('**/*', async route => {
      const url = new URL(route.request().url());
      if (url.hostname !== 'localhost') return route.abort();
      let relative = decodeURIComponent(url.pathname);
      if (relative.endsWith('/')) relative += 'index.html';
      const file = path.resolve(root, '.' + relative);
      if (!file.startsWith(root + path.sep) || !fs.existsSync(file)) {
        missing.push(relative);
        return route.fulfill({ status: 404, body: 'Missing' });
      }
      return route.fulfill({ path: file, contentType: types[path.extname(file)] });
    });
    await page.goto('http://localhost/website/');
    assert.equal(await page.locator('.card').count(), 44);
    // Interaction during the initial delay must permanently cancel startup autoplay.
    await page.locator('#nextBtn').click();
    await page.waitForTimeout(2200);
    assert.equal(await page.evaluate(() => autoplay), false);

    await page.locator('.card[data-id="neon-gif"]').click();
    await page.waitForFunction(() => document.getElementById('spotlightVideo').getAttribute('src')?.endsWith('neon-gif/assets/wallpaper.mp4'));
    assert.equal(await page.locator('#spotlightName').textContent(), 'NEON');
    assert.equal(await page.locator('.sdot[aria-current="true"]').count(), 1);

    await page.locator('.card[data-id="marvel"]').focus();
    await page.keyboard.press('Enter');
    assert.equal(await page.locator('#spotlightName').textContent(), 'MARVEL');
    assert.equal(await page.locator('#spotlightVideo').getAttribute('src'), null);
    assert.equal(await page.evaluate(() => document.getElementById('spotlightVideo').paused), true);

    // Delayed image callbacks must not overwrite a newer slide's background.
    assert.equal(await page.evaluate(() => {
      const OriginalImage = window.Image;
      const images = [];
      window.Image = class { constructor() { images.push(this); } };
      goTo(0);
      goTo(1);
      const expected = $bg.style.backgroundImage;
      images[0].onload();
      const unchanged = $bg.style.backgroundImage === expected;
      window.Image = OriginalImage;
      return unchanged;
    }), true);

    await page.locator('#search').fill('everest');
    assert.equal(await page.locator('.card').count(), 1);
    await page.locator('#search').fill('no-theme-matches-this');
    assert.equal(await page.locator('#noResults').isVisible(), true);
    await page.locator('#noResults button').click();
    assert.equal(await page.locator('.card').count(), 44);

    await page.evaluate(() => Object.defineProperty(navigator, 'clipboard', { configurable: true, value: { writeText: async () => { throw new Error('Denied'); } } }));
    await page.locator('#spotlightCopy').click();
    await page.waitForFunction(() => document.getElementById('toast').textContent.startsWith('Could not copy'));
    assert.equal(await page.evaluate(() => {
      startAuto();
      const firstTimer = autoTimer;
      startAuto();
      const replaced = firstTimer !== autoTimer;
      stopAuto();
      return replaced && autoTimer === null;
    }), true);

    const screenshots = path.join(root, 'build/website-tests');
    fs.mkdirSync(screenshots, { recursive: true });
    await page.screenshot({ path: path.join(screenshots, 'desktop.png'), fullPage: true });
    await page.setViewportSize({ width: 390, height: 844 });
    assert.equal(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), true);
    await page.screenshot({ path: path.join(screenshots, 'mobile.png'), fullPage: true });
    assert.deepEqual(missing, []);
    assert.deepEqual(errors, []);

    const reduced = await browser.newContext({ reducedMotion: 'reduce' });
    const reducedPage = await reduced.newPage();
    // Reuse the verified request handler by serving these local files again.
    await reducedPage.route('**/*', async route => {
      const url = new URL(route.request().url());
      if (url.hostname !== 'localhost') return route.abort();
      const file = path.join(root, url.pathname.endsWith('/') ? url.pathname + 'index.html' : url.pathname);
      return route.fulfill({ path: file, contentType: types[path.extname(file)] });
    });
    await reducedPage.goto('http://localhost/website/');
    assert.equal(await reducedPage.evaluate(() => startupTimer), null);
    await reducedPage.locator('.card[data-id="neon-gif"]').click();
    assert.equal(await reducedPage.locator('#spotlightVideo').getAttribute('src'), null);
    await reduced.close();
    console.log('Website checks passed: animation URLs, autoplay, keyboard navigation, stale media, clipboard errors, search, mobile layout, reduced motion.');
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
