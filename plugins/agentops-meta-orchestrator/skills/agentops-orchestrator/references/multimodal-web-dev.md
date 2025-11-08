# Multimodal Web Development Workflow

**Visual feedback loops for UI development - agents see what they build.**

## Overview

Multimodal web development enables agents to:
- **See** visual UI outputs (screenshots)
- **Analyze** layout, colors, spacing, typography
- **Iterate** based on visual feedback (3-5x faster than text)
- **Validate** against visual acceptance criteria

**Key insight:** Agents that can see what they build iterate faster and produce better UIs than text-only feedback.

---

## Core Visual Feedback Loop

```
1. Generate/Modify Code
   ↓
2. Start Dev Server (if not running)
   ↓
3. Capture Screenshot
   ↓
4. Read Screenshot (visual analysis)
   ↓
5. Analyze Against Criteria
   ↓
6. Issues Found? → Go to Step 1 (iterate)
   ↓
7. No Issues? → Human Review → Approve
```

**Iteration limit:** 5 iterations max before requesting human feedback

---

## Screenshot Tool Usage

### Basic Screenshot Capture

```bash
# Using Python wrapper (recommended for Claude Code)
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/ui.png

# Using Node.js directly
node scripts/screenshot.js http://localhost:3000 /tmp/ui.png

# Custom viewport (mobile)
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/mobile.png \
  --viewport 375x667

# Full page screenshot
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/full.png \
  --full-page
```

### Common Viewports

| Device | Viewport | Usage |
|--------|----------|-------|
| Desktop | 1280x720 | Default, most common |
| Desktop HD | 1920x1080 | Large screens |
| iPad | 768x1024 | Tablet portrait |
| iPad Landscape | 1024x768 | Tablet landscape |
| iPhone SE | 375x667 | Mobile small |
| iPhone 12/13 | 390x844 | Mobile standard |
| iPhone 14 Pro Max | 430x932 | Mobile large |

### Reading Screenshots for Analysis

```bash
# 1. Capture screenshot
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/ui.png

# 2. Use Read tool to analyze (Claude Code)
# Read tool will display the image visually
# Agent can then analyze: layout, colors, spacing, text, etc.
```

**What agents can see:**
- Layout and positioning (centered, left-aligned, grid structure)
- Colors and contrast (background, text, buttons, borders)
- Typography (font sizes, weights, readability)
- Spacing (padding, margins, whitespace)
- UI elements (buttons, forms, nav, cards, etc.)
- Responsive behavior (when comparing multiple viewports)

---

## Complete Workflow Examples

### Example 1: Next.js Login Form

**Goal:** Create a centered login form with email, password, and submit button

#### Iteration 1: Initial Implementation

**Step 1: Generate code**

```typescript
// app/login/page.tsx
export default function LoginPage() {
  return (
    <div>
      <h1>Login</h1>
      <form>
        <input type="email" placeholder="Email" />
        <input type="password" placeholder="Password" />
        <button type="submit">Login</button>
      </form>
    </div>
  );
}
```

**Step 2: Start dev server**
```bash
npm run dev  # Starts on http://localhost:3000
```

**Step 3: Capture screenshot**
```bash
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000/login \
  /tmp/login-v1.png
```

**Step 4: Read and analyze**
```
Visual analysis of /tmp/login-v1.png:
- Layout: Elements are left-aligned, not centered ❌
- Form: Inputs have no visible borders ❌
- Button: Default browser button, no styling ❌
- Spacing: Inputs are touching (no margin between) ❌
- Typography: Heading is default size, not prominent ❌
```

**Issues identified:** 5 visual problems

**Step 5: Iterate**

#### Iteration 2: Add Tailwind Styling

**Step 1: Modify code**

```typescript
// app/login/page.tsx
export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow-md">
        <h1 className="text-3xl font-bold text-center text-gray-900">Login</h1>
        <form className="space-y-6">
          <input
            type="email"
            placeholder="Email"
            className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          <input
            type="password"
            placeholder="Password"
            className="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          <button
            type="submit"
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition-colors"
          >
            Login
          </button>
        </form>
      </div>
    </div>
  );
}
```

**Step 3: Capture screenshot**
```bash
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000/login \
  /tmp/login-v2.png
```

**Step 4: Read and analyze**
```
Visual analysis of /tmp/login-v2.png:
- Layout: Centered vertically and horizontally ✓
- Form: White card with shadow, clear boundaries ✓
- Inputs: Visible borders, proper padding ✓
- Button: Blue, full-width, clear hover state ✓
- Spacing: Consistent spacing between elements ✓
- Typography: Large heading, readable labels ✓
```

**Issues identified:** 0 visual problems ✓

**Step 6: Request human approval**

```
Login form complete! Screenshot: /tmp/login-v2.png

Visual acceptance criteria met:
✓ Centered layout
✓ Proper input styling with borders
✓ Professional button design
✓ Consistent spacing
✓ Clear typography

Ready for your review and approval.
```

---

### Example 2: React Dashboard Header

**Goal:** Create a dashboard header with logo, navigation, and user profile

#### Complete Workflow

**1. Initial implementation**

```tsx
// components/Header.tsx
export function Header() {
  return (
    <header>
      <div>MyApp</div>
      <nav>
        <a href="/dashboard">Dashboard</a>
        <a href="/analytics">Analytics</a>
        <a href="/settings">Settings</a>
      </nav>
      <div>User Profile</div>
    </header>
  );
}
```

**2. Screenshot iteration 1**
```bash
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/header-v1.png
```

**Visual analysis:**
- Header has no background color (blends with page) ❌
- Items not aligned horizontally ❌
- No spacing between nav items ❌

**3. Add flexbox layout and styling**

```tsx
export function Header() {
  return (
    <header className="bg-white shadow-sm border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <div className="text-xl font-bold text-gray-900">MyApp</div>
          <nav className="flex space-x-8">
            <a href="/dashboard" className="text-gray-700 hover:text-gray-900">
              Dashboard
            </a>
            <a href="/analytics" className="text-gray-700 hover:text-gray-900">
              Analytics
            </a>
            <a href="/settings" className="text-gray-700 hover:text-gray-900">
              Settings
            </a>
          </nav>
          <div className="flex items-center space-x-4">
            <span className="text-sm text-gray-700">John Doe</span>
            <div className="h-8 w-8 rounded-full bg-blue-600 flex items-center justify-center text-white text-sm">
              JD
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
```

**4. Screenshot iteration 2**
```bash
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/header-v2.png
```

**Visual analysis:**
- Header has white background with subtle shadow ✓
- All items aligned horizontally ✓
- Nav items have proper spacing ✓
- User profile with avatar circle ✓
- Professional appearance ✓

**5. Human approval** → Approved ✓

---

## Visual Analysis Checklist

When analyzing screenshots, check these aspects systematically:

### Layout & Structure
- [ ] Elements are positioned correctly (centered, aligned, etc.)
- [ ] Responsive layout works at target viewport
- [ ] Grid/flexbox structure is visually correct
- [ ] No unexpected wrapping or overflow
- [ ] Z-index layering is correct (modals, dropdowns)

### Typography
- [ ] Font sizes are readable (not too small/large)
- [ ] Font weights are appropriate (headings bold, body regular)
- [ ] Line heights provide good readability
- [ ] Text color has sufficient contrast
- [ ] No text cutoff or overflow

### Colors & Contrast
- [ ] Background colors are intentional (not defaults)
- [ ] Text contrasts well with background (WCAG AA minimum)
- [ ] Color scheme is consistent
- [ ] Hover/focus states are visible
- [ ] Error states use appropriate colors (red, yellow)

### Spacing & Whitespace
- [ ] Padding inside elements is sufficient
- [ ] Margins between elements are consistent
- [ ] No elements are touching (unless intentional)
- [ ] Whitespace aids readability
- [ ] Spacing follows a consistent scale (4px, 8px, 16px, etc.)

### UI Elements
- [ ] Buttons look clickable (not flat, have borders/shadows)
- [ ] Form inputs have visible borders
- [ ] Links are distinguishable (color, underline)
- [ ] Icons are properly sized and aligned
- [ ] Images load and display correctly

### Responsive Behavior
- [ ] Mobile viewport: elements stack vertically
- [ ] Tablet viewport: navigation collapses or adapts
- [ ] Desktop viewport: full layout displayed
- [ ] Text remains readable at all sizes
- [ ] Touch targets are large enough on mobile (44px minimum)

---

## Common Visual Issues & Fixes

### Issue 1: Elements Not Centered

**Symptom:** Content is left-aligned when it should be centered

**Visual indicator:** Screenshot shows content hugging left edge

**Fix:**
```tsx
// Before: No centering
<div>Content</div>

// After: Flexbox centering
<div className="flex items-center justify-center">
  Content
</div>

// Or: Grid centering
<div className="grid place-items-center">
  Content
</div>
```

### Issue 2: Inputs Have No Visible Borders

**Symptom:** Form inputs are invisible or hard to see

**Visual indicator:** Screenshot shows input fields blending with background

**Fix:**
```tsx
// Before: Default browser styling
<input type="text" />

// After: Visible borders
<input
  type="text"
  className="border border-gray-300 rounded-md px-4 py-2"
/>
```

### Issue 3: Button Looks Flat/Unclickable

**Symptom:** Button doesn't look interactive

**Visual indicator:** Screenshot shows button as plain text or flat rectangle

**Fix:**
```tsx
// Before: Default button
<button>Submit</button>

// After: Styled button with depth
<button className="bg-blue-600 text-white px-6 py-2 rounded-md shadow-sm hover:bg-blue-700 transition-colors">
  Submit
</button>
```

### Issue 4: Text Too Small to Read

**Symptom:** Text is hard to read in screenshot

**Visual indicator:** Font size appears less than 14px

**Fix:**
```tsx
// Before: Default size (often 12px)
<p>Text content</p>

// After: Readable size (16px base)
<p className="text-base">Text content</p>
```

### Issue 5: Insufficient Spacing

**Symptom:** Elements are touching or cramped

**Visual indicator:** Screenshot shows elements with no gaps between them

**Fix:**
```tsx
// Before: No spacing
<div>
  <input />
  <input />
  <button />
</div>

// After: Consistent spacing
<div className="space-y-4">
  <input />
  <input />
  <button />
</div>
```

---

## Framework-Specific Patterns

### Next.js 13+ (App Router)

**Project structure:**
```
app/
├── page.tsx              # Home page
├── login/
│   └── page.tsx          # Login page
└── dashboard/
    └── page.tsx          # Dashboard page
```

**Screenshot workflow:**
```bash
# Start dev server
npm run dev

# Screenshot specific routes
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/home.png
python3 scripts/screenshot_wrapper.py http://localhost:3000/login /tmp/login.png
python3 scripts/screenshot_wrapper.py http://localhost:3000/dashboard /tmp/dashboard.png
```

### React (Create React App / Vite)

**Screenshot workflow:**
```bash
# Start dev server
npm start  # or: npm run dev

# Screenshot with client-side routing
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/app.png
python3 scripts/screenshot_wrapper.py http://localhost:3000/#/about /tmp/about.png
```

**Tip:** For React Router, use hash-based URLs in dev mode

### Vue.js

**Screenshot workflow:**
```bash
# Start dev server
npm run serve

# Screenshot Vue routes
python3 scripts/screenshot_wrapper.py http://localhost:8080 /tmp/home.png
python3 scripts/screenshot_wrapper.py http://localhost:8080/profile /tmp/profile.png
```

---

## Mobile-First Development

### Workflow: Mobile → Tablet → Desktop

**1. Start with mobile viewport (375x667)**

```bash
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/mobile.png \
  --viewport 375x667
```

**Visual checks:**
- [ ] Navigation collapses to hamburger menu
- [ ] Text is readable (16px minimum)
- [ ] Buttons are large enough to tap (44px)
- [ ] Content stacks vertically
- [ ] No horizontal scrolling

**2. Test tablet viewport (768x1024)**

```bash
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/tablet.png \
  --viewport 768x1024
```

**Visual checks:**
- [ ] Layout adapts to medium width
- [ ] Navigation shows partial or full menu
- [ ] Multi-column layouts begin to appear
- [ ] Images scale appropriately

**3. Verify desktop viewport (1920x1080)**

```bash
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/desktop.png \
  --viewport 1920x1080
```

**Visual checks:**
- [ ] Full navigation visible
- [ ] Multi-column layouts displayed
- [ ] Content doesn't stretch too wide
- [ ] Whitespace is balanced

---

## Iteration Strategies

### Strategy 1: Rapid Iteration (Simple Changes)

**Use when:** Making small visual adjustments (colors, spacing, sizes)

**Pattern:**
```
Modify CSS/classes → Screenshot → Analyze → Repeat (max 3x)
```

**Example:** Adjusting button padding
```
Iteration 1: padding: 8px → Screenshot → Too small
Iteration 2: padding: 16px → Screenshot → Good ✓
```

### Strategy 2: Incremental Building (Complex UIs)

**Use when:** Building complex components from scratch

**Pattern:**
```
1. Basic structure → Screenshot → Verify layout
2. Add styling → Screenshot → Verify appearance
3. Add interactivity → Screenshot → Verify states
4. Responsive → Screenshot (multiple viewports) → Verify adaptation
```

**Example:** Building a card component
```
Iteration 1: HTML structure → Screenshot → Layout correct?
Iteration 2: Add Tailwind classes → Screenshot → Styling correct?
Iteration 3: Add hover states → Screenshot → Hover visible?
Iteration 4: Test mobile → Screenshot (375x667) → Responsive?
```

### Strategy 3: Comparative Analysis (Before/After)

**Use when:** Refactoring or improving existing UIs

**Pattern:**
```
1. Screenshot before changes → /tmp/before.png
2. Make improvements
3. Screenshot after changes → /tmp/after.png
4. Compare both screenshots
5. Verify improvements achieved
```

---

## Human-in-the-Loop

### When to Request Human Review

**Always request human review when:**
- [ ] 5 iterations reached without satisfactory result
- [ ] Visual design decisions needed (color schemes, layouts)
- [ ] Accessibility concerns (contrast, sizing)
- [ ] Breaking changes to existing UI
- [ ] Final approval before committing code

### Review Request Format

```
Visual UI Review Request

Component: Login Form
Screenshots: /tmp/login-mobile.png, /tmp/login-desktop.png

Changes made:
- Centered form layout
- Added input borders and focus states
- Styled submit button with hover effect
- Responsive design (mobile + desktop)

Visual acceptance criteria met:
✓ Centered layout (desktop)
✓ Stacked layout (mobile)
✓ Input borders visible
✓ Button appears clickable
✓ Consistent spacing

Iterations: 2 of 5

Please review screenshots and approve or provide feedback.
```

---

## Performance Considerations

### Screenshot Capture Speed

**Typical latency:** 1.2-1.8 seconds per screenshot

**Optimization tips:**
- Use default viewport (1280x720) unless specific size needed
- Avoid `--full-page` for fast iteration (use only for final validation)
- Don't wait longer than 2 seconds (`--wait` flag)

### Concurrent Screenshots

**Supported:** Yes, 3+ concurrent screenshots work

**Use case:** Capture multiple viewports simultaneously

```bash
# Run in parallel (separate terminal tabs or background jobs)
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/mobile.png --viewport 375x667 &
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/tablet.png --viewport 768x1024 &
python3 scripts/screenshot_wrapper.py http://localhost:3000 /tmp/desktop.png --viewport 1920x1080 &
wait  # Wait for all to complete
```

---

## Troubleshooting

### Screenshot is Blank/White

**Cause:** Page not fully loaded or dev server not running

**Fix:**
```bash
# 1. Verify dev server is running
curl http://localhost:3000  # Should return HTML

# 2. Increase wait time
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/ui.png \
  --wait 2000  # Wait 2 seconds after load
```

### Screenshot Shows "Cannot GET /route"

**Cause:** Route doesn't exist or React Router not configured

**Fix:**
```bash
# For React Router hash-based routing
python3 scripts/screenshot_wrapper.py http://localhost:3000/#/route /tmp/route.png

# For Next.js, ensure page.tsx exists at route
```

### Screenshot is Cropped/Cut Off

**Cause:** Viewport too small or element overflow

**Fix:**
```bash
# Use larger viewport
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/ui.png \
  --viewport 1920x1080

# Or capture full page
python3 scripts/screenshot_wrapper.py \
  http://localhost:3000 /tmp/ui.png \
  --full-page
```

### Dev Server Port Changed

**Symptom:** Connection refused when screenshotting

**Fix:**
```bash
# Check which port dev server is using
# Common ports: 3000, 3001, 8080, 5173

# Update screenshot URL accordingly
python3 scripts/screenshot_wrapper.py http://localhost:5173 /tmp/ui.png
```

---

## Success Metrics

**Agent efficiency:**
- Average iterations: 2-4 (vs 10+ with text-only feedback)
- Time per iteration: ~2 seconds (screenshot capture)
- Success rate: 90%+ (visual criteria met within 5 iterations)

**Quality indicators:**
- Human approval on first review: 80%+
- Visual regressions: <5%
- Accessibility compliance: WCAG AA minimum

---

## Related References

- **[research-process.md](research-process.md)** - How to discover UI component patterns
- **[execution-guide.md](execution-guide.md)** - General workflow execution
- **[learning-system.md](learning-system.md)** - Capturing visual patterns for reuse
- **Screenshot tools:** `scripts/screenshot.js`, `scripts/screenshot_wrapper.py`
- **Test suite:** `scripts/test-screenshot.js`
