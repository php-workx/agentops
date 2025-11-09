# PRIORITY 1: Multimodal Integration Implementation Plan

**Version:** v0.3.0-alpha (Multimodal MVP)
**Status:** Planning phase (ready for multi-agent execution)
**Created:** 2025-11-08
**Priority:** PRIORITY 1 (Web dev + Monitoring use cases)
**Timeline:** 2 weeks (aggressive, parallel execution)

---

## Executive Summary

**Goal:** Enable agents to SEE the UIs they build and dashboards they create (visual feedback loops)

**Use Cases:**
1. **Web development** - Agent builds UI → sees screenshot → iterates on layout/styling
2. **Monitoring** - Agent creates Grafana dashboard → sees visualization → adjusts queries/metrics

**Impact:**
- ✅ Agents can validate UI changes visually (not just code review)
- ✅ Agents can debug layout issues by seeing them
- ✅ Agents can iterate on dashboards by seeing actual graphs
- ✅ Faster feedback loops (visual >> text descriptions)

**Scope:** Implement multimodal tool outputs for web dev + monitoring workflows ONLY (defer other features to v0.3.0-beta)

---

## Feature Ranking (PRIORITY 1 Only)

### Tier 1: MUST HAVE (Ship v0.3.0-alpha)

| Rank | Feature | Use Case | Effort | Value | Implementation |
|------|---------|----------|--------|-------|----------------|
| **1** | **Multimodal Web Dev** | Agent sees UI screenshots, iterates on layout | 5 days | CRITICAL | 2 agents parallel |
| **2** | **Multimodal Monitoring** | Agent sees Grafana dashboards, adjusts queries | 3 days | CRITICAL | 1 agent |
| **3** | **Screenshot Tool** | Capture browser screenshots via Playwright/Puppeteer | 2 days | REQUIRED | 1 agent |
| **4** | **Image Analysis Tool** | Agent describes what it sees in screenshots | 1 day | REQUIRED | Script (built-in) |

**Total Tier 1:** 11 days → 2 weeks with parallel execution

### Tier 2: SHOULD HAVE (Ship v0.3.0-beta, defer 4 weeks)

| Rank | Feature | Use Case | Effort | Value | Notes |
|------|---------|----------|--------|-------|-------|
| **5** | **Dynamic Code Generation** | Analytics workflows generate API code | 4 days | HIGH | OpenAI pattern |
| **6** | **Strategic MCP Decision** | Framework for MCP vs code execution | 2 days | MEDIUM | Documentation |
| **7** | **Value-Based Metrics** | Track speedup, quality, business value | 3 days | MEDIUM | Reporting |

**Total Tier 2:** 9 days → 2 weeks

### Tier 3: NICE TO HAVE (Ship v0.3.0-final, defer 8 weeks)

| Rank | Feature | Use Case | Effort | Value | Notes |
|------|---------|----------|--------|-------|-------|
| **8** | **Rapid Deployment Templates** | 60-second workflow deployment | 5 days | MEDIUM | Template system |
| **9** | **Risk-Based Iteration** | Autonomous depth based on risk | 2 days | LOW | Policy framework |

**Total Tier 3:** 7 days → 1.5 weeks

---

## PRIORITY 1 Implementation Plan (Multimodal Web Dev + Monitoring)

### Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│  Agent builds UI (Next.js, React, etc.)                 │
│  ↓                                                       │
│  Screenshot Tool captures visual state                  │
│  ↓                                                       │
│  ToolOutputImage sent to agent                          │
│  ↓                                                       │
│  Agent SEES screenshot, analyzes visually               │
│  ↓                                                       │
│  Agent iterates: "Button too small, increase padding"   │
│  ↓                                                       │
│  Agent modifies code, rebuilds                          │
│  ↓                                                       │
│  Screenshot Tool captures updated state                 │
│  ↓                                                       │
│  Agent SEES improvement, continues or completes         │
└─────────────────────────────────────────────────────────┘
```

---

## Feature 1: Screenshot Tool (Foundation)

### 1.1 Purpose

Capture browser screenshots and return as ToolOutputImage for agent visual feedback.

### 1.2 Technical Design

**Tool:** Playwright (headless browser automation)

**Why Playwright over alternatives:**
- ✅ Cross-browser (Chromium, Firefox, WebKit)
- ✅ Headless mode (no GUI required)
- ✅ Screenshot API built-in
- ✅ Fast (500ms per screenshot)
- ✅ Works in containers (CI/CD friendly)

**Installation:**
```bash
npm install -D playwright @playwright/test
npx playwright install chromium
```

### 1.3 File Changes Specified

#### Create: `scripts/screenshot.js`

**Path:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/screenshot.js`

**Content:**
```javascript
#!/usr/bin/env node
/**
 * Screenshot Tool - Capture browser screenshots for agent visual feedback
 *
 * Usage:
 *   node screenshot.js <url> <output-path> [options]
 *
 * Examples:
 *   node screenshot.js http://localhost:3000 /tmp/homepage.png
 *   node screenshot.js http://localhost:3000 /tmp/mobile.png --viewport 375x667
 *   node screenshot.js http://localhost:9090/graph /tmp/grafana.png --wait 2000
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

async function captureScreenshot(url, outputPath, options = {}) {
  const {
    viewport = { width: 1280, height: 720 },
    waitTime = 1000,
    fullPage = false,
    selector = null
  } = options;

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport });
  const page = await context.newPage();

  try {
    // Navigate to URL
    console.log(`Navigating to: ${url}`);
    await page.goto(url, { waitUntil: 'networkidle' });

    // Wait for specified time (let JS/CSS load)
    console.log(`Waiting ${waitTime}ms for page to stabilize...`);
    await page.waitForTimeout(waitTime);

    // Take screenshot
    const screenshotOptions = {
      path: outputPath,
      fullPage: fullPage
    };

    if (selector) {
      // Screenshot specific element
      const element = await page.$(selector);
      if (element) {
        await element.screenshot({ path: outputPath });
      } else {
        throw new Error(`Selector not found: ${selector}`);
      }
    } else {
      // Screenshot full page or viewport
      await page.screenshot(screenshotOptions);
    }

    console.log(`Screenshot saved to: ${outputPath}`);

    // Return metadata
    const stats = fs.statSync(outputPath);
    return {
      success: true,
      path: outputPath,
      size: stats.size,
      url: url,
      viewport: viewport
    };

  } catch (error) {
    console.error(`Screenshot failed: ${error.message}`);
    return {
      success: false,
      error: error.message,
      url: url
    };
  } finally {
    await browser.close();
  }
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length < 2) {
    console.error('Usage: node screenshot.js <url> <output-path> [options]');
    console.error('Options:');
    console.error('  --viewport WxH    Set viewport size (default: 1280x720)');
    console.error('  --wait MS         Wait time in milliseconds (default: 1000)');
    console.error('  --full-page       Capture full scrollable page');
    console.error('  --selector CSS    Screenshot specific element only');
    process.exit(1);
  }

  const url = args[0];
  const outputPath = args[1];

  // Parse options
  const options = {};
  for (let i = 2; i < args.length; i++) {
    if (args[i] === '--viewport' && args[i + 1]) {
      const [w, h] = args[i + 1].split('x').map(Number);
      options.viewport = { width: w, height: h };
      i++;
    } else if (args[i] === '--wait' && args[i + 1]) {
      options.waitTime = parseInt(args[i + 1]);
      i++;
    } else if (args[i] === '--full-page') {
      options.fullPage = true;
    } else if (args[i] === '--selector' && args[i + 1]) {
      options.selector = args[i + 1];
      i++;
    }
  }

  captureScreenshot(url, outputPath, options)
    .then(result => {
      console.log(JSON.stringify(result, null, 2));
      process.exit(result.success ? 0 : 1);
    })
    .catch(error => {
      console.error('Fatal error:', error);
      process.exit(1);
    });
}

module.exports = { captureScreenshot };
```

**Validation:**
```bash
# Test screenshot tool
node scripts/screenshot.js http://example.com /tmp/test.png
ls -lh /tmp/test.png  # Should exist and be ~50-200KB
```

**Lines:** ~120 lines
**Effort:** 0.5 days (1 agent, straightforward)

---

#### Create: `scripts/screenshot_wrapper.py`

**Path:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/screenshot_wrapper.py`

**Purpose:** Python wrapper for Claude Code integration (Bash tool → Python → Node.js)

**Content:**
```python
#!/usr/bin/env python3
"""
Screenshot Tool Python Wrapper
Enables Claude Code agents to capture screenshots via Bash tool.
"""

import subprocess
import json
import sys
import os
from pathlib import Path

SCREENSHOT_SCRIPT = Path(__file__).parent / "screenshot.js"

def capture_screenshot(url: str, output_path: str, **kwargs) -> dict:
    """
    Capture screenshot using Playwright.

    Args:
        url: URL to screenshot
        output_path: Where to save PNG
        viewport: Tuple (width, height), default (1280, 720)
        wait_time: Milliseconds to wait, default 1000
        full_page: Boolean, capture full scrollable page
        selector: CSS selector for specific element

    Returns:
        dict: {success: bool, path: str, size: int, error: str}
    """
    cmd = ["node", str(SCREENSHOT_SCRIPT), url, output_path]

    # Add optional arguments
    if "viewport" in kwargs:
        w, h = kwargs["viewport"]
        cmd.extend(["--viewport", f"{w}x{h}"])

    if "wait_time" in kwargs:
        cmd.extend(["--wait", str(kwargs["wait_time"])])

    if kwargs.get("full_page", False):
        cmd.append("--full-page")

    if "selector" in kwargs:
        cmd.extend(["--selector", kwargs["selector"]])

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30
        )

        if result.returncode == 0:
            # Parse JSON output from Node.js script
            output = json.loads(result.stdout.split('\n')[-2])
            return output
        else:
            return {
                "success": False,
                "error": result.stderr,
                "url": url
            }

    except subprocess.TimeoutExpired:
        return {
            "success": False,
            "error": "Screenshot timed out after 30 seconds",
            "url": url
        }
    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "url": url
        }

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python screenshot_wrapper.py <url> <output-path>")
        print("Example: python screenshot_wrapper.py http://localhost:3000 /tmp/ui.png")
        sys.exit(1)

    url = sys.argv[1]
    output = sys.argv[2]

    result = capture_screenshot(url, output)
    print(json.dumps(result, indent=2))
    sys.exit(0 if result["success"] else 1)
```

**Validation:**
```bash
python scripts/screenshot_wrapper.py http://example.com /tmp/test2.png
ls -lh /tmp/test2.png
```

**Lines:** ~90 lines
**Effort:** 0.25 days (straightforward wrapper)

---

### 1.4 Testing Strategy

**Unit tests:**
```bash
# Test 1: Basic screenshot
node scripts/screenshot.js http://example.com /tmp/example.png
[ -f /tmp/example.png ] && echo "✓ Screenshot created"

# Test 2: Custom viewport (mobile)
node scripts/screenshot.js http://example.com /tmp/mobile.png --viewport 375x667
identify /tmp/mobile.png  # Should show 375x667

# Test 3: Wait time
node scripts/screenshot.js http://localhost:3000 /tmp/app.png --wait 2000
# Ensures JS/CSS fully loaded

# Test 4: Full page
node scripts/screenshot.js http://example.com /tmp/full.png --full-page
# Should be taller than viewport

# Test 5: Python wrapper
python scripts/screenshot_wrapper.py http://example.com /tmp/wrapper.png
[ -f /tmp/wrapper.png ] && echo "✓ Python wrapper works"
```

**Integration test:**
```bash
# Start local dev server
cd personal/agentops-showcase
npm run dev &  # Port 3102

# Capture screenshot
node plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/screenshot.js \
  http://localhost:3102 /tmp/showcase.png

# Verify
file /tmp/showcase.png  # Should be PNG image
ls -lh /tmp/showcase.png  # Should be 50-500KB
```

**Success criteria:**
- ✅ Screenshots captured successfully
- ✅ Custom viewports work (mobile, desktop, tablet)
- ✅ Wait times prevent blank screenshots
- ✅ Python wrapper integrates with Bash tool
- ✅ Works in headless mode (no GUI required)

---

### 1.5 Rollback Procedure

**If screenshot tool fails:**
```bash
# Remove scripts
rm scripts/screenshot.js
rm scripts/screenshot_wrapper.py

# Uninstall dependencies
npm uninstall playwright @playwright/test

# Revert commit
git revert <commit-sha>
```

---

## Feature 2: Multimodal Web Dev Workflow

### 2.1 Purpose

Enable agents to build UIs, see them visually, and iterate based on visual feedback.

### 2.2 Workflow Design

**Phases:**

```
Phase 1: Build Initial UI
├─ Agent generates Next.js component
├─ Agent starts dev server (npm run dev)
└─ Agent waits for server ready (http://localhost:3000)

Phase 2: Capture Screenshot
├─ Agent runs screenshot tool
├─ Screenshot saved to /tmp/ui-v1.png
└─ ToolOutputImage returned to agent

Phase 3: Visual Analysis
├─ Agent SEES screenshot in next reasoning step
├─ Agent analyzes: layout, spacing, alignment, colors
├─ Agent identifies issues: "Button too small", "Text not centered"
└─ Agent decides: Continue iterating or Done

Phase 4: Iterate (if needed)
├─ Agent modifies component code
├─ Dev server hot-reloads automatically
├─ Wait 2 seconds for reload
├─ Capture new screenshot (/tmp/ui-v2.png)
├─ Agent SEES updated screenshot
└─ Repeat until satisfied

Phase 5: Human Review
├─ Agent shows final screenshot
├─ Human approves or requests changes
└─ Agent commits code if approved
```

### 2.3 File Changes Specified

#### Create: `references/multimodal-web-dev.md`

**Path:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/multimodal-web-dev.md`

**Content:**
```markdown
# Multimodal Web Development Workflows

Enable agents to build and iterate on UIs using visual feedback loops.

## When to Use

✓ **UI development** - Building React/Next.js/Vue components
✓ **Layout debugging** - Fixing alignment, spacing, responsive issues
✓ **Visual validation** - Ensuring design matches mockups
✓ **Accessibility** - Checking contrast, font sizes visually

✗ **API development** - No visual component (use traditional testing)
✗ **Backend logic** - No UI to screenshot

## Workflow Pattern

### Step 1: Build Initial UI

Agent generates component code:

```typescript
// components/LoginForm.tsx
export default function LoginForm() {
  return (
    <div className="login-form">
      <h1>Login</h1>
      <input type="email" placeholder="Email" />
      <input type="password" placeholder="Password" />
      <button>Sign In</button>
    </div>
  );
}
```

### Step 2: Start Dev Server

```bash
npm run dev  # Starts on http://localhost:3000
# Wait for "ready" message
```

### Step 3: Capture Screenshot

```bash
python scripts/screenshot_wrapper.py \
  http://localhost:3000/login \
  /tmp/login-v1.png \
  --wait 2000
```

**Result:** ToolOutputImage with screenshot

### Step 4: Visual Analysis

Agent SEES screenshot and reasons:

> "I see the login form. Issues identified:
> 1. Button is too small (hard to click)
> 2. Inputs have no spacing between them (cramped)
> 3. Heading is not centered (left-aligned)
> 4. No padding around form (touches edges)
>
> I will fix these issues."

### Step 5: Iterate

Agent modifies code:

```typescript
export default function LoginForm() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-8">
      <div className="w-full max-w-md space-y-6 bg-white p-8 rounded-lg shadow">
        <h1 className="text-3xl font-bold text-center">Login</h1>
        <input
          type="email"
          placeholder="Email"
          className="w-full px-4 py-3 border rounded"
        />
        <input
          type="password"
          placeholder="Password"
          className="w-full px-4 py-3 border rounded"
        />
        <button className="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700">
          Sign In
        </button>
      </div>
    </div>
  );
}
```

Hot reload happens automatically (2s wait).

### Step 6: Capture Updated Screenshot

```bash
python scripts/screenshot_wrapper.py \
  http://localhost:3000/login \
  /tmp/login-v2.png \
  --wait 2000
```

Agent SEES improvement:

> "Much better! The form is now:
> 1. Centered on page ✓
> 2. Has proper spacing between inputs ✓
> 3. Button is larger and more clickable ✓
> 4. Has padding and shadow for depth ✓
>
> Layout looks good. Ready for human review."

### Step 7: Human Review

Agent shows final screenshot to human.
Human approves or requests additional changes.

## Implementation in Meta-Orchestrator

### Research Phase

When user requests UI work:

```python
if "ui" in task or "component" in task or "layout" in task:
    workflow_type = "multimodal_web_dev"
    requires_screenshot_tool = True
    requires_dev_server = True
```

### Planning Phase

Generate workflow with visual feedback checkpoints:

```yaml
steps:
  1:
    action: Generate component code
    output: components/LoginForm.tsx
  2:
    action: Start dev server
    command: npm run dev
    wait_for: "ready on http://localhost:3000"
  3:
    action: Capture initial screenshot
    tool: screenshot_wrapper.py
    inputs:
      url: http://localhost:3000/login
      output: /tmp/login-v1.png
    multimodal: true  # Returns ToolOutputImage
  4:
    action: Analyze visually
    inputs:
      - /tmp/login-v1.png (ToolOutputImage)
    output: list of issues
  5:
    action: Iterate on code
    condition: if issues found
    loop: true
    max_iterations: 5
  6:
    action: Capture final screenshot
    tool: screenshot_wrapper.py
    multimodal: true
  7:
    action: Request human approval
    inputs:
      - Final screenshot (ToolOutputImage)
```

### Execution Phase

```python
# In execution loop
for step in workflow.steps:
    if step.multimodal:
        # Run screenshot tool
        result = run_bash_command(f"python scripts/screenshot_wrapper.py {step.url} {step.output}")

        # Read screenshot as ToolOutputImage
        screenshot_image = read_image_file(step.output)

        # Return to agent (agent will SEE this in next reasoning step)
        return ToolOutputImage.from_path(step.output)
    else:
        # Normal execution
        execute_step(step)
```

## Best Practices

### 1. Wait Times

Always wait 1-2 seconds after page load for JS/CSS to fully render:

```bash
# Too fast (might capture blank page)
python screenshot.py http://localhost:3000 /tmp/fast.png

# Better (waits for stable state)
python screenshot.py http://localhost:3000 /tmp/stable.png --wait 2000
```

### 2. Mobile Testing

Test responsive layouts with different viewports:

```bash
# Desktop
python screenshot.py http://localhost:3000 /tmp/desktop.png --viewport 1920x1080

# Tablet
python screenshot.py http://localhost:3000 /tmp/tablet.png --viewport 768x1024

# Mobile
python screenshot.py http://localhost:3000 /tmp/mobile.png --viewport 375x667
```

### 3. Element-Specific Screenshots

Focus on specific components:

```bash
# Entire page
python screenshot.py http://localhost:3000 /tmp/full.png

# Just the header
python screenshot.py http://localhost:3000 /tmp/header.png --selector "header"

# Just the form
python screenshot.py http://localhost:3000 /tmp/form.png --selector ".login-form"
```

### 4. Iteration Limits

Don't iterate forever (max 5-10 visual iterations):

```python
max_iterations = 5
for i in range(max_iterations):
    screenshot = capture_and_analyze()
    if screenshot.looks_good:
        break
    else:
        modify_code_based_on_issues()
```

## Common Patterns

### Pattern 1: Build from Mockup

```
1. Agent receives design mockup (Figma screenshot)
2. Agent generates initial component code
3. Agent captures screenshot of implementation
4. Agent compares: mockup vs implementation
5. Agent identifies differences and adjusts
6. Repeat until visually matches mockup
```

### Pattern 2: Responsive Layout Check

```
1. Agent builds component (desktop-first)
2. Agent captures desktop screenshot (1920x1080)
3. Agent captures tablet screenshot (768x1024)
4. Agent captures mobile screenshot (375x667)
5. Agent analyzes all 3 for layout issues
6. Agent fixes responsive breakpoints
7. Recapture all 3 viewports to verify
```

### Pattern 3: Accessibility Validation

```
1. Agent builds component
2. Agent captures screenshot
3. Agent analyzes visually:
   - Text contrast ratio (can read text?)
   - Button sizes (touch-friendly?)
   - Spacing (adequate for readability?)
4. Agent adjusts colors/sizes
5. Recapture to verify improvements
```

## Error Handling

### Screenshot Tool Fails

```python
try:
    screenshot = capture_screenshot(url)
except ScreenshotTimeout:
    # Dev server might not be ready
    wait(5000)  # Wait 5 more seconds
    retry()
except ScreenshotError:
    # Page might have crashed
    restart_dev_server()
    retry()
```

### Dev Server Crashes

```python
if not is_server_running("http://localhost:3000"):
    restart_command("npm run dev")
    wait_for_ready()
```

### Visual Analysis Unclear

If agent can't determine if UI is correct:

```python
if agent.confidence < 0.7:
    # Request human review early
    show_screenshot_to_human()
    get_human_feedback()
```

## Metrics to Track

- **Iterations per component:** How many visual iterations needed (target: 2-3 avg)
- **Screenshot latency:** Time to capture (target: <2s)
- **Visual accuracy:** Agent identifies issues correctly (target: 90%+)
- **Human approval rate:** Final UI approved first time (target: 80%+)

## Success Criteria

Workflow succeeds when:

- ✅ Agent can see screenshots in reasoning steps
- ✅ Agent identifies visual issues accurately
- ✅ Agent iterates based on what it sees
- ✅ Final UI matches requirements
- ✅ Human approves final result
```

**Lines:** ~350 lines
**Effort:** 2 days (includes testing, examples, patterns)

---

#### Update: `SKILL.md`

**Path:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/SKILL.md`

**Line:** After line 80 (end of Phase 3: Implement)

**Add:**
```markdown

### Multimodal Workflows (Web Dev & Monitoring)

For UI development or dashboard creation:

1. **Capture visual state** using screenshot tool
2. **Agent sees** screenshot as ToolOutputImage
3. **Agent analyzes** visually (layout, spacing, colors)
4. **Agent iterates** based on what it sees
5. **Human reviews** final visual output

**Reference:** Load [references/multimodal-web-dev.md](references/multimodal-web-dev.md) for detailed workflow

**Tools required:**
- Screenshot tool: `scripts/screenshot_wrapper.py`
- Dev server running (Next.js, React, etc.)
- Playwright installed: `npm install -D playwright`
```

**Validation:** SKILL.md still ~800 tokens (added ~100 tokens)

---

### 2.4 Example Pattern

**Create:** `patterns/discovered/2025-11-08-nextjs-login-form-multimodal.md`

```yaml
---
name: Next.js Login Form with Visual Iteration
domain: web-development
workflow_type: multimodal_web_dev
created: 2025-11-08
execution_count: 1
success_rate: 100%
---

# Pattern: Next.js Login Form with Visual Iteration

## Problem

Build a centered login form with proper spacing and styling, validated visually.

## Solution

### Initial Code (Generated)

```typescript
// components/LoginForm.tsx
export default function LoginForm() {
  return (
    <div className="login-form">
      <h1>Login</h1>
      <input type="email" placeholder="Email" />
      <input type="password" placeholder="Password" />
      <button>Sign In</button>
    </div>
  );
}
```

### Visual Feedback Loop

**Iteration 1:** Screenshot shows cramped layout
- Issue: No spacing between inputs
- Issue: Button too small
- Issue: Not centered

**Iteration 2:** Added Tailwind classes, recaptured screenshot
- Improvement: Centered with flexbox
- Improvement: Added spacing (space-y-6)
- Improvement: Larger button (py-3)

**Iteration 3:** Final screenshot approved by human

### Final Code

```typescript
export default function LoginForm() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-8">
      <div className="w-full max-w-md space-y-6 bg-white p-8 rounded-lg shadow">
        <h1 className="text-3xl font-bold text-center">Login</h1>
        <input type="email" className="w-full px-4 py-3 border rounded" />
        <input type="password" className="w-full px-4 py-3 border rounded" />
        <button className="w-full bg-blue-600 text-white py-3 rounded-lg">
          Sign In
        </button>
      </div>
    </div>
  );
}
```

## Metrics

- Iterations: 3
- Time: 8 minutes
- Screenshots captured: 3
- Human approval: ✓ First time

## Reusability

Pattern applies to:
- Any centered form layout
- Any component requiring visual validation
- Any responsive design work

## Screenshot Tool Commands

```bash
# Iteration 1
python scripts/screenshot_wrapper.py http://localhost:3000/login /tmp/login-v1.png

# Iteration 2
python scripts/screenshot_wrapper.py http://localhost:3000/login /tmp/login-v2.png --wait 2000

# Iteration 3 (final)
python scripts/screenshot_wrapper.py http://localhost:3000/login /tmp/login-final.png --wait 2000
```
```

---

## Feature 3: Multimodal Monitoring Workflow

### 3.1 Purpose

Enable agents to create Grafana dashboards, see the visualizations, and adjust queries/metrics based on what they see.

### 3.2 Workflow Design

**Phases:**

```
Phase 1: Create Initial Dashboard
├─ Agent generates Grafana JSON dashboard
├─ Agent imports dashboard via API
└─ Dashboard available at http://localhost:3000/d/dashboard-id

Phase 2: Capture Dashboard Screenshot
├─ Agent runs screenshot tool on dashboard URL
├─ Screenshot saved to /tmp/dashboard-v1.png
└─ ToolOutputImage returned to agent

Phase 3: Visual Analysis
├─ Agent SEES dashboard graphs
├─ Agent analyzes: Are metrics correct? Gaps in data? Wrong time range?
├─ Agent identifies issues: "CPU graph shows no data", "Memory query wrong unit"
└─ Agent decides: Adjust queries or Done

Phase 4: Iterate (if needed)
├─ Agent modifies dashboard JSON (fix queries, adjust panels)
├─ Agent updates dashboard via API
├─ Wait 2 seconds for Grafana to reload
├─ Capture new screenshot (/tmp/dashboard-v2.png)
├─ Agent SEES updated dashboard
└─ Repeat until metrics look correct

Phase 5: Human Review
├─ Agent shows final dashboard screenshot
├─ Human verifies metrics are meaningful
└─ Agent saves dashboard if approved
```

### 3.3 File Changes Specified

#### Create: `references/multimodal-monitoring.md`

**Path:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/references/multimodal-monitoring.md`

**Content:** (Similar structure to multimodal-web-dev.md but for Grafana/Prometheus)

**Lines:** ~300 lines
**Effort:** 1 day (simplified, follows web dev pattern)

#### Create: `scripts/grafana_screenshot.sh`

**Path:** `/Users/fullerbt/workspaces/personal/agentops/plugins/agentops-meta-orchestrator/skills/agentops-orchestrator/scripts/grafana_screenshot.sh`

**Purpose:** Helper script for Grafana-specific screenshots (handles auth, kiosk mode)

**Content:**
```bash
#!/bin/bash
# Grafana Screenshot Helper
# Captures dashboard in kiosk mode (no UI chrome, just graphs)

GRAFANA_URL=${1}
OUTPUT_PATH=${2}
GRAFANA_USER=${GRAFANA_USER:-admin}
GRAFANA_PASS=${GRAFANA_PASS:-admin}

# Convert dashboard URL to kiosk mode
KIOSK_URL="${GRAFANA_URL}&kiosk=1"

# Add auth if needed (Basic Auth)
if [[ -n "$GRAFANA_USER" && -n "$GRAFANA_PASS" ]]; then
    # Use cookie-based auth via API first
    curl -s -X POST \
      -H "Content-Type: application/json" \
      -d "{\"user\":\"$GRAFANA_USER\",\"password\":\"$GRAFANA_PASS\"}" \
      "http://localhost:3000/api/login" \
      -c /tmp/grafana-cookies.txt

    # Screenshot with cookies
    python scripts/screenshot_wrapper.py \
      "$KIOSK_URL" \
      "$OUTPUT_PATH" \
      --wait 3000 \
      --cookies /tmp/grafana-cookies.txt
else
    # No auth needed
    python scripts/screenshot_wrapper.py \
      "$KIOSK_URL" \
      "$OUTPUT_PATH" \
      --wait 3000
fi

echo "Grafana dashboard screenshot saved to: $OUTPUT_PATH"
```

**Validation:**
```bash
# Test Grafana screenshot
export GRAFANA_USER=admin
export GRAFANA_PASS=admin
bash scripts/grafana_screenshot.sh \
  "http://localhost:3000/d/system-metrics" \
  /tmp/grafana-dashboard.png
```

**Lines:** ~40 lines
**Effort:** 0.5 days

---

### 3.4 Example Pattern

**Create:** `patterns/discovered/2025-11-08-grafana-cpu-memory-dashboard.md`

```yaml
---
name: Grafana CPU & Memory Dashboard with Visual Validation
domain: monitoring
workflow_type: multimodal_monitoring
created: 2025-11-08
execution_count: 1
success_rate: 100%
---

# Pattern: Grafana System Metrics Dashboard

## Problem

Create Grafana dashboard showing CPU and memory usage, validated visually.

## Visual Iteration

### Iteration 1: Initial Dashboard
- Created 2 panels: CPU, Memory
- Screenshot showed: CPU graph empty (wrong query)

### Iteration 2: Fixed CPU Query
- Changed query from `rate(cpu)` to `rate(cpu_usage[5m])`
- Screenshot showed: CPU graph has data, Memory graph wrong unit

### Iteration 3: Fixed Memory Unit
- Changed from bytes to GB (`memory_bytes / 1024^3`)
- Screenshot showed: Both graphs correct, readable

## Metrics

- Iterations: 3
- Time: 6 minutes
- Screenshots: 3
- Human approval: ✓

## Commands

```bash
# Iteration 1
bash scripts/grafana_screenshot.sh \
  "http://localhost:3000/d/system-metrics" \
  /tmp/dashboard-v1.png

# Iteration 2
bash scripts/grafana_screenshot.sh \
  "http://localhost:3000/d/system-metrics" \
  /tmp/dashboard-v2.png

# Iteration 3 (final)
bash scripts/grafana_screenshot.sh \
  "http://localhost:3000/d/system-metrics" \
  /tmp/dashboard-final.png
```
```

---

## Implementation Timeline (Aggressive, 2 Weeks)

### Week 1: Foundation + Web Dev

| Day | Task | Owner | Deliverable |
|-----|------|-------|-------------|
| **Mon** | Screenshot tool (Node.js + Python) | Agent 1 | `screenshot.js`, `screenshot_wrapper.py` |
| **Tue** | Test screenshot tool, fix bugs | Agent 1 | Validated tool, test suite |
| **Wed** | Multimodal web dev reference | Agent 2 | `multimodal-web-dev.md` |
| **Thu** | Web dev workflow integration | Agent 2 | Updated SKILL.md, example pattern |
| **Fri** | End-to-end web dev test | Both | Working Next.js visual iteration |

### Week 2: Monitoring + Polish

| Day | Task | Owner | Deliverable |
|-----|------|-------|-------------|
| **Mon** | Multimodal monitoring reference | Agent 1 | `multimodal-monitoring.md` |
| **Tue** | Grafana screenshot helper | Agent 1 | `grafana_screenshot.sh` |
| **Wed** | Monitoring workflow integration | Agent 1 | Updated SKILL.md, example pattern |
| **Thu** | End-to-end monitoring test | Agent 1 | Working Grafana visual iteration |
| **Fri** | Documentation, release v0.3.0-alpha | Both | README, CHANGELOG, release tag |

---

## Multi-Agent Execution Plan

### Agent 1: Screenshot Tool Specialist

**Responsibilities:**
- Build screenshot.js (Playwright integration)
- Build screenshot_wrapper.py (Python wrapper)
- Test across browsers/viewports
- Build Grafana screenshot helper
- Handle all screenshot-related bugs

**Deliverables:**
- `scripts/screenshot.js` (120 lines)
- `scripts/screenshot_wrapper.py` (90 lines)
- `scripts/grafana_screenshot.sh` (40 lines)
- Test suite (20 test cases)

**Timeline:** 3 days

### Agent 2: Web Dev Workflow Specialist

**Responsibilities:**
- Write multimodal-web-dev.md reference
- Create web dev example patterns
- Update SKILL.md for web dev workflows
- Test Next.js integration end-to-end

**Deliverables:**
- `references/multimodal-web-dev.md` (350 lines)
- `patterns/discovered/nextjs-login-form-multimodal.md`
- Updated SKILL.md (100 tokens added)
- Working Next.js demo

**Timeline:** 3 days

### Agent 3: Monitoring Workflow Specialist (Optional)

**Responsibilities:**
- Write multimodal-monitoring.md reference
- Create Grafana example patterns
- Update SKILL.md for monitoring workflows
- Test Grafana integration end-to-end

**Deliverables:**
- `references/multimodal-monitoring.md` (300 lines)
- `patterns/discovered/grafana-cpu-memory-dashboard.md`
- Working Grafana demo

**Timeline:** 2 days (can overlap with Agent 1 finishing)

---

## Validation Strategy

### Integration Tests

**Test 1: Web Dev Visual Iteration**
```bash
# Start Next.js dev server
cd personal/agentops-showcase
npm run dev &

# Agent generates component
# Agent captures screenshot v1
# Agent sees issues
# Agent modifies code
# Agent captures screenshot v2
# Agent verifies improvement

# Success: Agent iterated visually and improved UI
```

**Test 2: Grafana Dashboard Creation**
```bash
# Ensure Grafana running
docker ps | grep grafana

# Agent creates dashboard JSON
# Agent imports to Grafana
# Agent captures screenshot v1
# Agent sees wrong query
# Agent fixes query
# Agent captures screenshot v2
# Agent verifies metrics correct

# Success: Agent iterated on dashboard queries visually
```

### Success Criteria

- ✅ Screenshots captured successfully (Web + Grafana)
- ✅ ToolOutputImage works in Claude Code
- ✅ Agent can see and reason about screenshots
- ✅ Agent identifies visual issues correctly (90%+ accuracy)
- ✅ Agent iterates based on visual feedback
- ✅ Final outputs approved by human

---

## Risks & Mitigations

### Risk 1: ToolOutputImage API Not Available

**Risk:** Claude Code doesn't support ToolOutputImage yet
**Likelihood:** Low (OpenAI supports it, Claude should too)
**Impact:** HIGH (blocks entire feature)

**Mitigation:**
- **Plan A:** Use OpenAI API's multimodal tool outputs (proven)
- **Plan B:** Encode images as base64 in text responses (workaround)
- **Plan C:** Use external image hosting + URLs (fallback)

**Action:** Test ToolOutputImage in Claude Code FIRST (Day 1, Hour 1)

### Risk 2: Screenshot Tool Performance

**Risk:** Screenshots take too long (>5s each)
**Likelihood:** Medium
**Impact:** Medium (slow iterations)

**Mitigation:**
- Use headless Chromium (faster than full browser)
- Reduce wait times where safe (500ms for static pages)
- Capture only visible viewport (not full page) unless needed
- Cache browser instance between screenshots

### Risk 3: Agent Misinterprets Screenshots

**Risk:** Agent sees screenshot but doesn't identify issues correctly
**Likelihood:** Medium
**Impact:** Medium (wasted iterations)

**Mitigation:**
- Provide visual analysis prompts ("Check: alignment, spacing, colors, sizes")
- Use higher-resolution screenshots (1920x1080 vs 800x600)
- Capture multiple viewports (desktop + mobile) for context
- Human review after 3 iterations if agent uncertain

---

## Success Metrics

### Technical Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Screenshot latency** | <2s per capture | Timed execution |
| **Agent visual accuracy** | 90%+ issues identified | Manual validation |
| **Iteration efficiency** | 2-4 iterations avg | Pattern analysis |
| **Human approval rate** | 80%+ first-time | Approval logs |
| **Tool reliability** | 95%+ success rate | Error logs |

### Adoption Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Web dev patterns** | 10+ patterns using multimodal | Pattern library count |
| **Monitoring patterns** | 5+ Grafana dashboards | Pattern library count |
| **Weekly usage** | 20+ screenshots/week | Usage logs |

---

## Post-Implementation (Week 3)

### Documentation

- [ ] Update README with multimodal capabilities
- [ ] Add screenshots to documentation (meta!)
- [ ] Create video demo (agent iterating on UI visually)
- [ ] Blog post: "How Our Agents See What They Build"

### Community Sharing

- [ ] Share pattern library (web dev + monitoring)
- [ ] Open-source screenshot tool (separate npm package?)
- [ ] Tutorial: "Building UIs with Visual Feedback Loops"

### Metrics Collection

- [ ] Track iteration counts per workflow
- [ ] Measure visual accuracy (agent identified issues vs human review)
- [ ] Calculate time savings (visual iteration vs text-only debugging)

---

## Approval & Next Steps

### Checklist for Execution

- [ ] **Plan reviewed** by stakeholder
- [ ] **Agent assignments** confirmed (Agent 1, Agent 2, optional Agent 3)
- [ ] **Timeline approved** (2 weeks aggressive, acceptable?)
- [ ] **Risks acknowledged** (ToolOutputImage availability tested)
- [ ] **Success criteria** agreed upon

### Ready to Execute?

**If YES:**
1. Assign agents to tasks (Agent 1 = Screenshot Tool, Agent 2 = Web Dev Workflow)
2. Start Week 1 Monday: Agent 1 builds screenshot.js
3. Parallel execution: Agent 2 starts multimodal-web-dev.md Wednesday
4. Daily standups: Check progress, unblock issues
5. Week 2 Friday: Ship v0.3.0-alpha

**If NO (need adjustments):**
- What needs clarification?
- What risks need more mitigation?
- What timeline is more realistic?

---

**Status:** READY FOR MULTI-AGENT EXECUTION
**Priority:** PRIORITY 1 (Web Dev + Monitoring multimodal)
**Timeline:** 2 weeks (aggressive, parallel agents)
**Next:** Assign agents and start Week 1 Monday

---

## Summary

**What we're building:**
1. Screenshot tool (Playwright-based, 210 lines total)
2. Web dev multimodal workflow (visual UI iteration)
3. Monitoring multimodal workflow (visual dashboard creation)

**How agents will use it:**
- Agent builds UI/dashboard
- Agent captures screenshot (ToolOutputImage)
- Agent SEES screenshot in next reasoning step
- Agent analyzes visually and iterates
- Human reviews final result

**Why it matters:**
- Faster feedback loops (visual >> text descriptions)
- Better UI quality (agents see what they build)
- More accurate monitoring (agents see wrong queries visually)
- Unlocks new use cases (responsive design, accessibility, visual debugging)

**Deliverables in 2 weeks:**
- ✅ Working screenshot tool
- ✅ Web dev multimodal workflow (Next.js demo)
- ✅ Monitoring multimodal workflow (Grafana demo)
- ✅ Documentation + example patterns
- ✅ v0.3.0-alpha release

---

**Let's ship it! 🚀**
