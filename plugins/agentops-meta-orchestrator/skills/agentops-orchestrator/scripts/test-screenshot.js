#!/usr/bin/env node
/**
 * Test Suite for Screenshot Tooling
 *
 * Purpose: Comprehensive tests for screenshot.js, wrapper, and Grafana helper
 * Usage: node test-screenshot.js
 */

const { captureScreenshot } = require('./screenshot.js');
const fs = require('fs');
const { execSync } = require('child_process');
const path = require('path');

// Test configuration
const TEST_OUTPUT_DIR = '/tmp/screenshot-tests';
const TESTS_RUN = [];
const TESTS_PASSED = [];
const TESTS_FAILED = [];

// Ensure test output directory exists
if (!fs.existsSync(TEST_OUTPUT_DIR)) {
  fs.mkdirSync(TEST_OUTPUT_DIR, { recursive: true });
}

// Helper: Run a test
async function runTest(name, testFn) {
  process.stdout.write(`\n[TEST] ${name}... `);
  TESTS_RUN.push(name);

  try {
    await testFn();
    console.log('✓ PASS');
    TESTS_PASSED.push(name);
    return true;
  } catch (error) {
    console.log(`✗ FAIL`);
    console.log(`       Error: ${error.message}`);
    TESTS_FAILED.push({ name, error: error.message });
    return false;
  }
}

// Helper: Assert
function assert(condition, message) {
  if (!condition) {
    throw new Error(message || 'Assertion failed');
  }
}

// Helper: File exists
function fileExists(path) {
  return fs.existsSync(path);
}

// Helper: File size
function fileSize(path) {
  return fs.statSync(path).size;
}

// Test 1: Basic screenshot capture
async function test01_BasicCapture() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '01-basic.png');
  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: false,
    timeout: 30000
  });

  assert(result.success, 'Screenshot should succeed');
  assert(fileExists(outputPath), 'Output file should exist');
  assert(fileSize(outputPath) > 0, 'Output file should not be empty');
}

// Test 2: Custom viewport (mobile)
async function test02_MobileViewport() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '02-mobile.png');
  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 375, height: 667 }, // iPhone SE
    waitTime: 500,
    fullPage: false,
    timeout: 30000
  });

  assert(result.success, 'Mobile screenshot should succeed');
  assert(fileExists(outputPath), 'Mobile output file should exist');
}

// Test 3: Full page capture
async function test03_FullPage() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '03-fullpage.png');
  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: true,
    timeout: 30000
  });

  assert(result.success, 'Full page screenshot should succeed');
  assert(fileExists(outputPath), 'Full page output file should exist');
}

// Test 4: Custom wait time
async function test04_CustomWait() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '04-wait.png');
  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 2000, // 2 seconds
    fullPage: false,
    timeout: 30000
  });

  assert(result.success, 'Custom wait screenshot should succeed');
  assert(result.duration >= 2000, 'Should wait at least 2 seconds');
}

// Test 5: Invalid URL handling
async function test05_InvalidURL() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '05-invalid.png');
  const result = await captureScreenshot({
    url: 'http://invalid-url-that-does-not-exist-12345.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: false,
    timeout: 5000 // Short timeout
  });

  assert(!result.success, 'Invalid URL should fail');
  assert(result.error, 'Should have error message');
}

// Test 6: Python wrapper - basic
async function test06_PythonWrapperBasic() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '06-python.png');
  const scriptDir = path.dirname(__filename);

  try {
    execSync(
      `python3 "${path.join(scriptDir, 'screenshot_wrapper.py')}" https://example.com "${outputPath}"`,
      { stdio: 'pipe' }
    );
    assert(fileExists(outputPath), 'Python wrapper output should exist');
  } catch (error) {
    throw new Error(`Python wrapper failed: ${error.message}`);
  }
}

// Test 7: Python wrapper - custom viewport
async function test07_PythonWrapperViewport() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '07-python-viewport.png');
  const scriptDir = path.dirname(__filename);

  try {
    execSync(
      `python3 "${path.join(scriptDir, 'screenshot_wrapper.py')}" https://example.com "${outputPath}" --viewport 1920x1080`,
      { stdio: 'pipe' }
    );
    assert(fileExists(outputPath), 'Python wrapper viewport output should exist');
  } catch (error) {
    throw new Error(`Python wrapper viewport failed: ${error.message}`);
  }
}

// Test 8: Python wrapper - full page
async function test08_PythonWrapperFullPage() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '08-python-fullpage.png');
  const scriptDir = path.dirname(__filename);

  try {
    execSync(
      `python3 "${path.join(scriptDir, 'screenshot_wrapper.py')}" https://example.com "${outputPath}" --full-page`,
      { stdio: 'pipe' }
    );
    assert(fileExists(outputPath), 'Python wrapper full page output should exist');
  } catch (error) {
    throw new Error(`Python wrapper full page failed: ${error.message}`);
  }
}

// Test 9: CLI - basic usage
async function test09_CLIBasic() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '09-cli.png');
  const scriptDir = path.dirname(__filename);

  try {
    execSync(
      `node "${path.join(scriptDir, 'screenshot.js')}" https://example.com "${outputPath}"`,
      { stdio: 'pipe' }
    );
    assert(fileExists(outputPath), 'CLI output should exist');
  } catch (error) {
    throw new Error(`CLI failed: ${error.message}`);
  }
}

// Test 10: CLI - all options
async function test10_CLIAllOptions() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '10-cli-options.png');
  const scriptDir = path.dirname(__filename);

  try {
    execSync(
      `node "${path.join(scriptDir, 'screenshot.js')}" https://example.com "${outputPath}" --viewport 1024x768 --wait 1000 --timeout 15000`,
      { stdio: 'pipe' }
    );
    assert(fileExists(outputPath), 'CLI with options output should exist');
  } catch (error) {
    throw new Error(`CLI with options failed: ${error.message}`);
  }
}

// Test 11: Output directory creation
async function test11_OutputDirCreation() {
  const outputPath = path.join(TEST_OUTPUT_DIR, 'nested/deep/dir/11-nested.png');
  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: false,
    timeout: 30000
  });

  assert(result.success, 'Nested directory screenshot should succeed');
  assert(fileExists(outputPath), 'Nested output file should exist');
}

// Test 12: Performance - capture under 5 seconds
async function test12_Performance() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '12-performance.png');
  const startTime = Date.now();

  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: false,
    timeout: 30000
  });

  const duration = Date.now() - startTime;

  assert(result.success, 'Performance test should succeed');
  assert(duration < 5000, `Should complete in under 5s (took ${duration}ms)`);
}

// Test 13: File size validation
async function test13_FileSizeValidation() {
  const outputPath = path.join(TEST_OUTPUT_DIR, '13-filesize.png');
  const result = await captureScreenshot({
    url: 'https://example.com',
    outputPath,
    viewport: { width: 1280, height: 720 },
    waitTime: 500,
    fullPage: false,
    timeout: 30000
  });

  assert(result.success, 'File size test should succeed');
  const size = fileSize(outputPath);
  assert(size > 10000, 'Screenshot should be larger than 10KB');
  assert(size < 1000000, 'Screenshot should be smaller than 1MB');
}

// Test 14: Concurrent screenshots
async function test14_ConcurrentScreenshots() {
  const promises = [];

  for (let i = 0; i < 3; i++) {
    const outputPath = path.join(TEST_OUTPUT_DIR, `14-concurrent-${i}.png`);
    promises.push(captureScreenshot({
      url: 'https://example.com',
      outputPath,
      viewport: { width: 1280, height: 720 },
      waitTime: 500,
      fullPage: false,
      timeout: 30000
    }));
  }

  const results = await Promise.all(promises);

  for (const result of results) {
    assert(result.success, 'Concurrent screenshot should succeed');
  }
}

// Test 15: Grafana helper script exists
async function test15_GrafanaHelperExists() {
  const scriptDir = path.dirname(__filename);
  const grafanaScript = path.join(scriptDir, 'grafana_screenshot.sh');

  assert(fileExists(grafanaScript), 'Grafana helper script should exist');

  const stats = fs.statSync(grafanaScript);
  assert(stats.mode & fs.constants.S_IXUSR, 'Grafana script should be executable');
}

// Main test runner
async function runAllTests() {
  console.log('\n=== AgentOps Screenshot Tool Test Suite ===\n');

  // Run all tests
  await runTest('01: Basic screenshot capture', test01_BasicCapture);
  await runTest('02: Mobile viewport (375x667)', test02_MobileViewport);
  await runTest('03: Full page capture', test03_FullPage);
  await runTest('04: Custom wait time (2s)', test04_CustomWait);
  await runTest('05: Invalid URL handling', test05_InvalidURL);
  await runTest('06: Python wrapper - basic', test06_PythonWrapperBasic);
  await runTest('07: Python wrapper - viewport', test07_PythonWrapperViewport);
  await runTest('08: Python wrapper - full page', test08_PythonWrapperFullPage);
  await runTest('09: CLI - basic usage', test09_CLIBasic);
  await runTest('10: CLI - all options', test10_CLIAllOptions);
  await runTest('11: Output directory creation', test11_OutputDirCreation);
  await runTest('12: Performance (< 5s)', test12_Performance);
  await runTest('13: File size validation', test13_FileSizeValidation);
  await runTest('14: Concurrent screenshots (3)', test14_ConcurrentScreenshots);
  await runTest('15: Grafana helper exists', test15_GrafanaHelperExists);

  // Print summary
  console.log('\n=== Test Summary ===\n');
  console.log(`Total tests: ${TESTS_RUN.length}`);
  console.log(`Passed: ${TESTS_PASSED.length}`);
  console.log(`Failed: ${TESTS_FAILED.length}`);

  if (TESTS_FAILED.length > 0) {
    console.log('\nFailed tests:');
    TESTS_FAILED.forEach(({ name, error }) => {
      console.log(`  - ${name}: ${error}`);
    });
  }

  console.log(`\nTest outputs: ${TEST_OUTPUT_DIR}`);
  console.log('');

  // Exit with appropriate code
  process.exit(TESTS_FAILED.length > 0 ? 1 : 0);
}

// Run tests
runAllTests().catch(error => {
  console.error('Fatal test error:', error);
  process.exit(1);
});
