#!/usr/bin/env node
/**
 * Screenshot Tool for AgentOps Multimodal Workflows
 *
 * Purpose: Capture screenshots of web pages for visual feedback loops
 * Usage: node screenshot.js <url> <output-path> [options]
 *
 * Examples:
 *   node screenshot.js http://localhost:3000 /tmp/ui.png
 *   node screenshot.js http://localhost:3000 /tmp/mobile.png --viewport 375x667
 *   node screenshot.js http://localhost:3000 /tmp/stable.png --wait 2000
 *
 * Options:
 *   --viewport <width>x<height>  Set viewport size (default: 1280x720)
 *   --wait <ms>                  Wait time after load (default: 500ms)
 *   --full-page                  Capture full scrollable page
 *   --timeout <ms>               Page load timeout (default: 30000ms)
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.error('Usage: node screenshot.js <url> <output-path> [options]');
    console.error('');
    console.error('Options:');
    console.error('  --viewport <width>x<height>  Viewport size (default: 1280x720)');
    console.error('  --wait <ms>                  Wait after load (default: 500)');
    console.error('  --full-page                  Capture full page');
    console.error('  --timeout <ms>               Load timeout (default: 30000)');
    process.exit(1);
  }

  const config = {
    url: args[0],
    outputPath: args[1],
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: false,
    timeout: 30000,
    waitUntil: 'networkidle' // Options: load, domcontentloaded, networkidle
  };

  // Parse options
  for (let i = 2; i < args.length; i++) {
    const arg = args[i];

    if (arg === '--viewport' && i + 1 < args.length) {
      const [width, height] = args[i + 1].split('x').map(Number);
      if (width && height) {
        config.viewport = { width, height };
      }
      i++;
    } else if (arg === '--wait' && i + 1 < args.length) {
      config.waitTime = parseInt(args[i + 1], 10);
      i++;
    } else if (arg === '--full-page') {
      config.fullPage = true;
    } else if (arg === '--timeout' && i + 1 < args.length) {
      config.timeout = parseInt(args[i + 1], 10);
      i++;
    } else if (arg === '--wait-until' && i + 1 < args.length) {
      config.waitUntil = args[i + 1];
      i++;
    }
  }

  return config;
}

// Ensure output directory exists
function ensureOutputDir(outputPath) {
  const dir = path.dirname(outputPath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

// Main screenshot function
async function captureScreenshot(config) {
  const startTime = Date.now();
  let browser = null;

  try {
    // Launch headless browser
    console.log(`[screenshot] Launching browser...`);
    browser = await chromium.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    // Create context with specified viewport
    const context = await browser.newContext({
      viewport: config.viewport,
      deviceScaleFactor: 2 // Retina display support
    });

    // Create page
    const page = await context.newPage();

    // Navigate to URL
    console.log(`[screenshot] Navigating to ${config.url}...`);
    await page.goto(config.url, {
      timeout: config.timeout,
      waitUntil: config.waitUntil
    });

    // Additional wait time for JS/CSS rendering
    if (config.waitTime > 0) {
      console.log(`[screenshot] Waiting ${config.waitTime}ms for rendering...`);
      await page.waitForTimeout(config.waitTime);
    }

    // Ensure output directory exists
    ensureOutputDir(config.outputPath);

    // Capture screenshot
    console.log(`[screenshot] Capturing screenshot to ${config.outputPath}...`);
    await page.screenshot({
      path: config.outputPath,
      fullPage: config.fullPage
    });

    const duration = Date.now() - startTime;
    console.log(`[screenshot] ✓ Screenshot captured successfully (${duration}ms)`);
    console.log(`[screenshot] File: ${config.outputPath}`);
    console.log(`[screenshot] Size: ${fs.statSync(config.outputPath).size} bytes`);

    return {
      success: true,
      path: config.outputPath,
      duration,
      size: fs.statSync(config.outputPath).size
    };

  } catch (error) {
    console.error(`[screenshot] ✗ Error: ${error.message}`);
    return {
      success: false,
      error: error.message
    };
  } finally {
    // Close browser
    if (browser) {
      await browser.close();
    }
  }
}

// Main execution
if (require.main === module) {
  const config = parseArgs();

  captureScreenshot(config).then(result => {
    if (result.success) {
      process.exit(0);
    } else {
      process.exit(1);
    }
  }).catch(error => {
    console.error(`[screenshot] Fatal error: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { captureScreenshot };
