# NICHE-BUILD-PLAYBOOK.md

Version 4.0 — Pricing tiers, feature lists, Stripe links, and setup fee are locked in. Save this file as `NICHE-BUILD-PLAYBOOK.md` in your repo root. For each new niche, copy it, fill every `[BRACKET]`, and open Claude Code with: "Follow NICHE-BUILD-PLAYBOOK.md before writing a single line of code."

---

## Expected Time Profile (for your records)

| Phase | NeedleMoved actual | With this playbook |
| --- | --- | --- |
| Initial build (18 pages, 3 parallel subagents) | ~3 hours | ~3 hours (same) |
| Content polish rounds | ~8 rounds | ~2 rounds |
| Webhook / CORS / n8n wiring | ~4 rounds | 0 rounds |
| Deploy + DNS debug | ~3 rounds | ~1 round |
| Pricing rebuild | full rebuild | 0 rounds |
| Free trial language sweep | full sweep | 0 rounds |
| Post-deploy cosmetic fixes | ~10 rounds | ~2 rounds |
| Total elapsed | 1–2 weeks | 2–3 days |

The four decisions that save the most time: pricing model, free trial status, production webhook URLs, and CORS fetch config — all four are pre-filled in this playbook.

---

## BUILD PROMPT — [NICHE NAME]

Build a fully production-ready, [N]-page marketing website for [PRODUCT_NAME], a [1-sentence product description] built exclusively for [TARGET AUDIENCE].

The site must be complete, conversion-optimized, and deployable to Coolify as a 100% static HTML/CSS/JS site — no frameworks, no build step, no node_modules, no npm. Every page must be finished on first delivery: no `[TODO]` comments, no `[Placeholder]` tokens, no fake 555 numbers, no lorem ipsum, no placeholder logos.

---

## SECTION 0 — VARIABLES

Fill every `[BRACKET]` before sending this prompt. The pricing block, Stripe links, and setup fee are already filled — do not change them.

```
PRODUCT_NAME:         [NAME]
NICHE:                [e.g. "med spa"]
NICHE_CODE:           [short prefix, e.g. "nm" for NeedleMoved, "rf" for roofing]
TAGLINE:              [ONE SENTENCE]
ACCENT_COLOR:         [HEX — e.g. #E8B4A0]
SECONDARY_COLOR:      [HEX or "none"]
BACKGROUND_COLOR:     [#FFFFFF or specify]
TEXT_COLOR:           [#1A1A1A or specify]
LOGO:                 [SVG file path OR "placeholder [XX] monogram in accent color"]
DOMAIN:               [domain.com]
DNS_PROVIDER:         [Namecheap | Cloudflare | other]
CONTACT_EMAIL:        [hello@domain.com]
INTERNAL_EMAIL:       [info@domain.com]
BUSINESS_PHONE:       [number OR "omit — not available yet"]
LEGAL_ENTITY:         [e.g. "Illumination Lab LLC"]
FORMATION_STATE:      [e.g. "Delaware"]
GOVERNING_LAW:        [e.g. "State of Texas, Travis County"]
MAILING_ADDRESS:      [full address]
EFFECTIVE_DATE:       [e.g. "May 1, 2025"]
LEAD_WEBHOOK:         [https://illuminationlab.app.n8n.cloud/webhook/UUID]
NEWSLETTER_WEBHOOK:   [https://illuminationlab.app.n8n.cloud/webhook/UUID]
GHL_CALENDAR_EMBED:   [full iframe + script HTML]
CHATBOT_EMBED:        [full script HTML OR "none — route pricing intent to pricing.html"]
DRIP_TAG_PREFIX:      [NICHE_CODE value above, e.g. "nm"]
CONTENT_FILE:         [path/to/content.md]
CSS_JS_VERSION:       v1
FREE_TRIAL:           NO
```

### PRICING (LOCKED — do not change these values)

```
PRICING_MODEL:        tiered monthly subscription + pay-as-you-go usage
SETUP_FEE:            $200 one-time (bundled into each Stripe Payment Link)
COUPON_CODE:          [issued situationally — do not publish publicly; omit from website copy]
STRIPE_STARTER:       https://buy.stripe.com/eVq3cv2iafin2iubPa8Ra09
STRIPE_GROWTH:        https://buy.stripe.com/14AcN5aOG3zF4qC8CY8Ra0a
STRIPE_PROFESSIONAL:  https://buy.stripe.com/3cIeVd9KC1rxf5gbPa8Ra0b
```

> Every webhook URL must use `/webhook/UUID` — never `/webhook-test/UUID`. The n8n workflow is already Active.
>
> Accent color must be defined before writing a single CSS rule. Do not pick a color mid-build.
>
> The coupon code is NOT published on the website. It is issued offline in specific situations only. Do not add "use code X for free setup" anywhere in site copy.

---

## SECTION 1 — CONTENT & STRUCTURE

Read `[CONTENT_FILE]` first. It is the authoritative source for all copy. Do not invent feature claims, pricing language, or statistics that contradict it.

Pages to build (exact filenames):

- `index.html`
- `features.html`
- `use-cases.html`
- `resources.html`
- `pricing.html`
- `about.html`
- `contact.html`
- `book-demo.html`
- `privacy.html`
- `terms.html`

If the source content uses different page names, map them explicitly here before building. Do not carry over a previous project's page structure if it doesn't match this list.

### Page-type decisions

- `features.html` → single page with `#anchor` nav sections, NOT individual sub-pages
- `use-cases.html` → single page with `#anchor` nav sections, NOT individual sub-pages
- `resources.html` → blog-index/listing layout only; individual post pages are Phase 2
- `book-demo.html` → GHL calendar embed ONLY — no custom HTML form on this page
- `privacy.html` + `terms.html` → full legal content, minimal styling, no hero section

### Absolute copy rules — enforced across every file

- ❌ NO free trial language: "Start Free Trial", "Try [Product] Free", "Try it free", "14-day free trial", etc. `FREE_TRIAL = NO`.
- ❌ NO social media icons anywhere — not in header, footer, contact page, or anywhere else
- ❌ NO fake phone numbers (555-xxxx). If `BUSINESS_PHONE = omit`, remove phone fields entirely
- ❌ NO `[Placeholder]`, `[Logo 1]`, `[TODO]`, or any bracket tokens in delivered files
- ❌ NO "Trusted by [logos]" bar — omit until real client logos are provided
- ❌ NO coupon code anywhere in site copy — it is issued offline only
- ✅ Testimonial stand-ins: first name + last initial + city only (e.g., "Maria S., Austin TX"). Generic role ("Owner, Austin Med Spa"). No fabricated stats, no named companies. Will swap for real clients later.
- ✅ CTAs use: "Book a Demo", "Sign Up Now", "See Pricing", "Get Started"

---

## SECTION 2 — BRAND

- Product name: `[PRODUCT_NAME]`
- Tagline: `[TAGLINE]`
- Accent color: `[ACCENT_COLOR]` — set as `--color-accent` CSS custom property on `:root`. Use this variable everywhere — never hardcode the raw hex more than once.
- Secondary color: `[SECONDARY_COLOR]`
- Background: `[BACKGROUND_COLOR]`
- Body text: `[TEXT_COLOR]`

### Logo: `[LOGO]`

- Use the same SVG as the `<link rel="icon">` favicon, wrapped in a 32×32 viewBox
- If placeholder: render the first two letters of the product name as a monogram SVG filled with `--color-accent`

### Hero imagery: `[real photos: filename1.jpg, filename2.jpg | "use mock product-UI cards"]`

- If mock cards: homepage hero is centered single-column — headline, subheadline, CTA buttons, trust strip (3–4 icon + short-phrase items), then a mock product demo card (e.g. a Voice AI call transcript or chat conversation).
- ❌ Do NOT use a split-grid hero with a decorative right column — invisible on dark backgrounds, wastes half of above-the-fold space.

---

## SECTION 3 — PRICING (FULLY SPECIFIED — build exactly as written)

**Model:** Tiered monthly subscription. Base price covers platform access. Each feature also carries per-use costs (calls, SMS, emails, AI minutes, etc.) billed on top — clients only pay for what they use. Do not publish specific per-use rates; describe the model as "pay only for what you use" throughout.

**One-time setup fee:** $200, bundled into each Stripe Payment Link at checkout.

**Coupon code:** Exists but is NOT mentioned anywhere on the site. Issued offline in specific situations only.

### Tier 1 — Starter: $99/month

Stripe link: `https://buy.stripe.com/eVq3cv2iafin2iubPa8Ra09`

Includes:
- 2-Way Text & Email Conversation
- GMB (Google My Business) Messaging
- Web Chat
- Facebook Messenger
- GMB Call Tracking
- Missed Call Text-Back
- Launchpad
- Invoice
- CRM
- Opportunities
- Email Marketing
- Reporting
- Documents & Contracts
- QR Codes

Best for: `[NICHE]` businesses getting started with CRM and client communication — replace your scattered inboxes and manual follow-up with one system.

### Tier 2 — Growth: $199/month ← MOST POPULAR

Stripe link: `https://buy.stripe.com/14AcN5aOG3zF4qC8CY8Ra0a`

Includes everything in Starter, plus:
- Reputation Management
- Trigger Links
- SMS & Email Templates
- Workflows
- Triggers
- Marketing Automation
- AI Voice — answers calls, books appointments, takes notes, creates CRM records
- AI Conversation — 24/7 chat across website, SMS, and social DMs
- AI Content — generates social posts, emails, blogs, and website copy

Best for: Growing `[NICHE]` businesses ready to automate follow-up, deploy AI staff, and run marketing without hiring a bigger team.

### Tier 3 — Professional: $299/month

Stripe link: `https://buy.stripe.com/3cIeVd9KC1rxf5gbPa8Ra0b`

Includes everything in Growth, plus:
- Social Planner
- Form Builder
- Funnels
- Campaigns
- Ad Manager

Best for: Established `[NICHE]` businesses running paid advertising, multi-channel campaigns, and full-funnel marketing at scale.

### Pricing page rules (pricing.html)

**Usage framing** — use this language throughout:

> "Your base subscription covers the platform. Features like calls, SMS messages, emails, and AI interactions are billed at a small per-use rate — so you only pay when the system is actively working for you. No bloated bundles. No paying for features you don't use."

**Page structure:**

- Headline + one-paragraph usage model explanation (above the tier cards)
- Three tier cards side-by-side (Starter | Growth | Professional)
  - Growth card: `2px solid var(--color-accent)` border + "Most Popular" badge in accent color above card header
  - Each card: tier name, price, feature list, Stripe CTA button
  - All Stripe buttons link to their PRODUCTION URL from Section 0
- Full feature comparison table (all three tiers, every feature, checkmarks)
- "What does pay-as-you-go mean?" explainer section (no specific rates — describe the concept)
- FAQ section (6–8 questions drawn from `[CONTENT_FILE]`)

**Stripe email prefill:** `pricing.html` reads `?email=` from the URL on page load and appends `prefilled_email=[value]` to every `buy.stripe.com` href via an inline `<script>` at the bottom of the file.

**Setup fee transparency:** Include one clear line on the pricing page — e.g. "A one-time $200 setup fee is included at checkout." No further explanation needed. Do not mention coupon code.

---

## SECTION 4 — WEBHOOKS & INTEGRATIONS

### 4a — Fetch config (ALL forms — do not deviate)

```javascript
// ✅ Correct — avoids CORS OPTIONS preflight that silently blocks n8n
fetch(WEBHOOK_URL, {
  method: 'POST',
  headers: { 'Content-Type': 'text/plain;charset=UTF-8' },
  mode: 'no-cors',
  body: JSON.stringify(formData)
});

// ❌ Wrong — triggers preflight, webhook never fires, no error shown in console
fetch(WEBHOOK_URL, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(formData)
});
```

- Lead capture webhook: `[LEAD_WEBHOOK]`
- Newsletter signup webhook: `[NEWSLETTER_WEBHOOK]`

### 4b — Required fields on every form POST

The shared n8n workflow switches on `form_location` and tags contacts by `source_site`. Every form must POST the following fields in addition to its own:

```
source_site      — [NICHE_CODE] (set once per site, injected automatically by main.js from window.SITE_CONFIG)
form_location    — contact | newsletter | book-demo | revenue-calculator | playbook (set per-form as a hidden input)
page_url         — autofilled by main.js
referrer         — autofilled by main.js
submitted_at     — autofilled by main.js (ISO 8601)
```

Contact form keeps `first_name` and `last_name` as separate fields (not concatenated).

### 4c — n8n parse Code node (required at the start of every receiving workflow)

```javascript
let data = typeof $json.body === 'string'
  ? JSON.parse($json.body)
  : ($json.body || $json);
if (data.contact)     { Object.assign(data, data.contact);     delete data.contact; }
if (data.appointment) { Object.assign(data, data.appointment); delete data.appointment; }
return { json: data };
```

### 4d — GHL Calendar (book-demo.html)

`book-demo.html` contains only the GHL calendar embed — no custom HTML form on this page:

```html
[GHL_CALENDAR_EMBED — paste full iframe + form_embed.js script here]
```

Wrap the iframe in:

```html
<div style="background:#fff; border-radius:12px; overflow:visible; padding:1rem;">
  <!-- GHL iframe here -->
</div>
```

Add this page-level inline script immediately before `</body>` to prefill the calendar from URL params:

```javascript
(function() {
  const p = new URLSearchParams(location.search);
  const iframe = document.querySelector('iframe[src*="msgsndr"], iframe[src*="chiefautomationexperts"]');
  if (!iframe) return;
  const url = new URL(iframe.src);
  ['first_name','last_name','email','phone'].forEach(function(k) {
    if (p.get(k)) url.searchParams.set(k, p.get(k));
  });
  iframe.src = url.toString();
})();
```

Override `.split-visual` on this page only (in a `<style>` block in `<head>`):

```css
.split-visual {
  aspect-ratio: auto !important;
  background: none !important;
  border: none !important;
  overflow: visible !important;
  display: block !important;
}
```

### 4e — Chatbot widget

```
[CHATBOT_EMBED — paste full script HTML]
```

Place inside `<body>` of every page except `privacy.html` and `terms.html`.

If `CHATBOT_EMBED = "none"`: route the "pricing" intent on the contact form to `pricing.html` instead of a chatbot URL.

---

## SECTION 5 — CONTACT FORM & INTENT ROUTING

### Form fields (contact.html)

| Field | Type | Required |
| --- | --- | --- |
| First Name | text | required |
| Last Name | text | required |
| Business Name | text | required |
| Email | email | required |
| Phone | tel | required \| optional \| OMIT if `BUSINESS_PHONE = omit` |
| What are you looking for? (select, required) | select | required |
| Message | textarea | optional |

The select options are:
- `"Book a Demo"` → value `demo`
- `"I'm switching from another platform"` → value `switching`
- `"I'm opening a new [NICHE] business"` → value `new-biz`
- `"I want to learn more about pricing"` → value `pricing`
- `"Something else"` → value `other`

### Event architecture

`main.js` fires a cancelable custom event after a successful POST:

```javascript
document.dispatchEvent(new CustomEvent('form:success', {
  cancelable: true,
  detail: { data: formData, formElement: form }
}));
```

`contact.html` has a page-level `<script>` that calls `e.preventDefault()` and routes by the intent field:

| Intent value | Action |
| --- | --- |
| `demo` / `switching` / `new-biz` | Redirect → `book-demo.html?first_name=X&last_name=Y&email=Z&phone=P` |
| `signup` | Redirect → `pricing.html?email=Z#plans` |
| `pricing` | Redirect → `[CHATBOT_EMBED URL OR pricing.html]` |
| `other` | Stay on page — show inline thank-you message, no redirect |

### Email responsibility split

**n8n handles:**
- ✅ Internal alert → `[INTERNAL_EMAIL]`
- ✅ Contact upsert into GHL with intent-based drip tag

**GHL handles (via workflow triggers):**
- ✅ Customer auto-reply
- ✅ All drip sequences
- ✅ Appointment confirmations
- ✅ Native unsubscribe link (automatic in GHL emails)

n8n does NOT send customer-facing email — prevents duplicate sends and missing unsubscribe compliance.

### GHL drip tag naming (niche-prefixed — prevents cross-site collision in shared GHL account)

```
[DRIP_TAG_PREFIX]-drip-demo-interest
[DRIP_TAG_PREFIX]-drip-switching
[DRIP_TAG_PREFIX]-drip-new-biz
[DRIP_TAG_PREFIX]-drip-pricing
[DRIP_TAG_PREFIX]-newsletter
[DRIP_TAG_PREFIX]-signed-up
```

Example with prefix `nm`: `nm-drip-demo-interest`, `nm-newsletter`, `nm-signed-up`.

---

## SECTION 6 — CSS ARCHITECTURE (write on day 1, before any page content)

These are the exact rules that caused the most rework on NeedleMoved. Bake them in from the first commit.

```css
/* ─── RESET: announcement bar + header ─────────────────────────────────────
   Static — scrolls away with the page.
   ❌ Never position:fixed or position:sticky
   ❌ Never JS scroll-listeners that toggle .style.top
   ──────────────────────────────────────────────────────────────────────── */
.announcement-bar,
.site-header {
  position: relative;
}

/* ─── RESET: split-visual container ────────────────────────────────────────
   The 4:3 aspect-ratio / background / border were placeholder defaults for
   image slots. Non-image content (cards, GHL iframe, calculator, forms)
   placed inside .split-visual was being hard-cropped into a 4:3 box.
   ❌ Never set aspect-ratio, background, border, or overflow:hidden here.
   ──────────────────────────────────────────────────────────────────────── */
.split-visual {
  display: block;
}

/* Opt-in class only for sections with a genuinely framed image: */
.split-visual-frame {
  aspect-ratio: 4 / 3;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 12px;
  overflow: hidden;
}

/* ─── RESET: checklist items ────────────────────────────────────────────────
   ❌ Never display:flex on .checklist li — turns every inline child
      (<strong>, <span>, bare text) into separate flex columns.
   ✅ Use absolute-positioned SVG so inline content flows naturally.
   ──────────────────────────────────────────────────────────────────────── */
.checklist {
  list-style: none;
  padding: 0;
  margin: 0;
}
.checklist li {
  position: relative;
  padding-left: 34px;
  margin-bottom: 0.75rem;
  line-height: 1.6;
}
.checklist li svg {
  position: absolute;
  left: 0;
  top: 3px;
  width: 20px;
  height: 20px;
}

/* ─── RESET: stats row ──────────────────────────────────────────────────────
   justify-content: center must be in the BASE rule, not only mobile queries.
   Without it, stat items align to flex-start on desktop.
   ──────────────────────────────────────────────────────────────────────── */
.stats-row {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  text-align: center;
  gap: 2rem;
}

/* ─── RESET: page-hero subtitle ─────────────────────────────────────────────
   max-width alone doesn't center the block — needs margin auto.
   ──────────────────────────────────────────────────────────────────────── */
.page-hero p {
  max-width: 640px;
  margin-left: auto;
  margin-right: auto;
}
```

---

## SECTION 7 — JAVASCRIPT ARCHITECTURE

### Cache-busting (day 1 — bump `?v=` on every CSS or JS change)

Every HTML file must include:

```html
<!-- CSS/JS version: v1 — bump on every CSS or JS change -->
<link rel="stylesheet" href="css/styles.css?v=1">
<script src="js/main.js?v=1" defer></script>
```

### Site-config injection (per-site constants)

Every HTML page includes this inline snippet in `<head>`, before `main.js` runs:

```html
<script>window.SITE_CONFIG = { source_site: "[NICHE_CODE]" };</script>
```

`main.js` reads `window.SITE_CONFIG.source_site` and adds it to every form POST automatically. Each page's form supplies its own `form_location` via a hidden input.

### `main.js` responsibilities

- Single unified form handler for all pages except `book-demo.html`
- After successful fetch POST, fires cancelable `form:success` event — does NOT redirect itself
- If any page has a live calculator: wire input listeners to update hidden `<input>` fields so computed values are included in the webhook POST:

```javascript
// Pattern: live calculator → hidden inputs → included in POST
document.querySelectorAll('.calc-input').forEach(function(el) {
  el.addEventListener('input', function() {
    document.getElementById('hidden-calc-result').value = computeResult();
  });
});
```

### Page-level inline scripts

| Page | Responsibility |
| --- | --- |
| `contact.html` | Listen for `form:success`, `e.preventDefault()`, route by intent |
| `book-demo.html` | Read URL params → inject into GHL iframe `src` |
| `pricing.html` | Read `?email=` → append `prefilled_email` to every Stripe link |

---

## SECTION 8 — DEPLOYMENT (Coolify)

### Dashboard settings — verify before first deploy

- Build Pack: **Static** (or Nixpacks with "Is it a static site?" = CHECKED)
- Ports Exposes: **80**
- Publish Directory: **/**
- Generate Default Nginx Config: click once before first deploy

### Domain configuration

- Add both domains: `https://[DOMAIN]` and `https://www.[DOMAIN]`
- Direction: Allow both www and non-www

### DNS records (at `[DNS_PROVIDER]`)

| Type | Host | Value | TTL |
| --- | --- | --- | --- |
| A | @ | [Coolify server IP] | Auto |
| A | www | [Coolify server IP] | Auto |

### Deploy checklist

- [ ] "Is it a static site?" is ON (Ports auto-sets to 80)
- [ ] Publish Directory = `/`
- [ ] "Generate Default Nginx Configuration" clicked once
- [ ] Both `https://[DOMAIN]` and `https://www.[DOMAIN]` added under Domains
- [ ] DNS A records for `@` and `www` pointing to Coolify server IP
- [ ] First test always in incognito tab (browser cache serves stale error states)

---

## SECTION 9 — LEGAL PAGES

Generate complete, real legal content — not placeholder text:

```
Legal entity name:     [LEGAL_ENTITY]
Formation state:       [FORMATION_STATE]
Governing law:         [GOVERNING_LAW]
Effective date:        [EFFECTIVE_DATE]
Legal contact email:   [CONTACT_EMAIL]
Mailing address:       [MAILING_ADDRESS]
```

Both pages must include:
- GDPR disclosure (right to access, right to erasure, lawful basis)
- CCPA disclosure (California residents — right to know, delete, opt-out)
- Data retention policy
- Cookie policy (types used, opt-out mechanism)
- Dispute resolution clause referencing `[GOVERNING_LAW]`

---

## SECTION 10 — PHASE 2 SCOPE (do not build now)

These add complexity without adding first-visit conversions. Build after launch:

- Individual blog post pages (listing page only now)
- Member portal / client login
- Live pricing calculator with Stripe quote API
- Multi-language / i18n
- Dark mode toggle
- Real client logo bar (omit until logos exist)
- Individual case study pages

---

## SECTION 11 — DEFINITION OF DONE

Every item must be checked before declaring the build complete.

### Global
- [ ] Zero `[BRACKET]` tokens remain in any file
- [ ] Zero free-trial language (CTAs, meta descriptions, dropdowns, legal pages)
- [ ] Zero social media icons (header, footer, contact, anywhere)
- [ ] Zero fake 555 phone numbers
- [ ] Zero placeholder client names
- [ ] `?v=[CSS_JS_VERSION]` on every `<link>` and `<script>` tag
- [ ] Logo renders in header; favicon renders in browser tab
- [ ] Footer: legal entity name, mailing address, © year, Privacy link, Terms link
- [ ] All pages have unique `<title>` and `<meta name="description">` tags
- [ ] Announcement bar and header scroll away with page (not fixed)
- [ ] Coupon code does not appear anywhere on the site

### Forms & routing
- [ ] Contact form POSTs to production webhook (no `-test` in path)
- [ ] Fetch uses `Content-Type: text/plain;charset=UTF-8` + `mode: 'no-cors'`
- [ ] All 5 intent dropdown values route correctly
- [ ] `window.SITE_CONFIG.source_site` set on every page; main.js injects it into every POST
- [ ] Every form has a `form_location` hidden input
- [ ] Calculated values (if any) in hidden inputs and included in POST
- [ ] `book-demo.html` URL-param prefill populates GHL iframe correctly
- [ ] `pricing.html` Stripe email prefill appends to all three Stripe links

### Pricing
- [ ] Starter tier links to `https://buy.stripe.com/eVq3cv2iafin2iubPa8Ra09`
- [ ] Growth tier links to `https://buy.stripe.com/14AcN5aOG3zF4qC8CY8Ra0a`
- [ ] Professional tier links to `https://buy.stripe.com/3cIeVd9KC1rxf5gbPa8Ra0b`
- [ ] `?email=` prefill working — appended to all three Stripe links when param present
- [ ] Growth tier has accent-color border + "Most Popular" badge
- [ ] "$200 one-time setup fee included at checkout" appears on pricing page
- [ ] Coupon code does NOT appear on pricing page
- [ ] Pay-as-you-go usage model explained in plain language (no specific per-use rates)
- [ ] Feature comparison table present
- [ ] FAQ section present (6–8 questions)

### CSS
- [ ] `.split-visual` has no `aspect-ratio`, no `background`, no `overflow:hidden`
- [ ] `.checklist li` uses `position:relative` + absolute SVG (no `display:flex`)
- [ ] `.stats-row` has `justify-content: center` in base rule
- [ ] `.page-hero p` has `margin-left: auto; margin-right: auto`
- [ ] `.announcement-bar` and `.site-header` are NOT `position:fixed`
- [ ] No scroll-listener JS dynamically adjusting header `.style.top`

### Coolify / DNS
- [ ] Build Pack = Static, Ports = 80, Publish Dir = `/`
- [ ] Default Nginx config generated
- [ ] Both `www` and non-`www` domains added
- [ ] DNS A records for `@` and `www` confirmed pointing to server IP
- [ ] Site loads in incognito on both `https://[DOMAIN]` and `https://www.[DOMAIN]`

---

## APPENDIX A — GHL Drip Sequence Map

Define before build. n8n applies the tag; GHL workflow listens and fires the sequence.

| Form intent | n8n tag applied | GHL workflow | Email sequence |
| --- | --- | --- | --- |
| Book a Demo | `[PREFIX]-drip-demo-interest` | Demo Interest Nurture | 3-touch |
| Switching platforms | `[PREFIX]-drip-switching` | Switch Nurture | 3-touch |
| New business | `[PREFIX]-drip-new-biz` | New Biz Nurture | 3-touch |
| Pricing inquiry | `[PREFIX]-drip-pricing` | Pricing Nudge | 2-touch |
| Newsletter signup | `[PREFIX]-newsletter` | Newsletter Welcome | 1-touch |
| Signup (Stripe) | `[PREFIX]-signed-up` | Onboarding Sequence | No drip — onboarding |

> Tag prefix must be unique per niche site — tags without a prefix collide across sites sharing the same GHL account.

---

## APPENDIX B — Multi-Niche Tag Registry

The canonical registry lives in `_website-template/REGISTRY.md`. Before starting a new niche, confirm the chosen `NICHE_CODE` is not already taken and reserve it there.

---

## APPENDIX C — Pricing Quick-Reference Card

A single-glance reference for anyone building or reviewing the pricing page.

| | Starter | Growth | Professional |
| --- | --- | --- | --- |
| Price | $99/mo | $199/mo | $299/mo |
| Stripe link | `eVq3cv2iafin2iubPa8Ra09` | `14AcN5aOG3zF4qC8CY8Ra0a` | `3cIeVd9KC1rxf5gbPa8Ra0b` |
| 2-Way Text & Email | ✅ | ✅ | ✅ |
| GMB Messaging | ✅ | ✅ | ✅ |
| Web Chat | ✅ | ✅ | ✅ |
| Facebook Messenger | ✅ | ✅ | ✅ |
| GMB Call Tracking | ✅ | ✅ | ✅ |
| Missed Call Text-Back | ✅ | ✅ | ✅ |
| Launchpad | ✅ | ✅ | ✅ |
| Invoice | ✅ | ✅ | ✅ |
| CRM | ✅ | ✅ | ✅ |
| Opportunities | ✅ | ✅ | ✅ |
| Email Marketing | ✅ | ✅ | ✅ |
| Reporting | ✅ | ✅ | ✅ |
| Documents & Contracts | ✅ | ✅ | ✅ |
| QR Codes | ✅ | ✅ | ✅ |
| Reputation Management | — | ✅ | ✅ |
| Trigger Links | — | ✅ | ✅ |
| SMS & Email Templates | — | ✅ | ✅ |
| Workflows | — | ✅ | ✅ |
| Triggers | — | ✅ | ✅ |
| Marketing Automation | — | ✅ | ✅ |
| AI Voice | — | ✅ | ✅ |
| AI Conversation | — | ✅ | ✅ |
| AI Content | — | ✅ | ✅ |
| Social Planner | — | — | ✅ |
| Form Builder | — | — | ✅ |
| Funnels | — | — | ✅ |
| Campaigns | — | — | ✅ |
| Ad Manager | — | — | ✅ |
| Setup fee | $200 one-time | $200 one-time | $200 one-time |
| Usage billing | Pay-as-you-go | Pay-as-you-go | Pay-as-you-go |

---

## APPENDIX D — Common Bug Reference

Check here first before requesting a fix.

| Symptom | Root cause | Fix |
| --- | --- | --- |
| Webhook fires in n8n editor but not in production | Using `/webhook-test/` URL | Change to `/webhook/UUID` |
| Form POST silently blocked (CORS error in DevTools) | `Content-Type: application/json` triggers OPTIONS preflight | Switch to `text/plain;charset=UTF-8` + `mode: 'no-cors'` |
| Content inside `.split-visual` cropped into 4:3 box | Legacy placeholder CSS on `.split-visual` | Remove `aspect-ratio`, `background`, `border`, `overflow:hidden` |
| Checklist items render as narrow columns | `display:flex` on `.checklist li` | Switch to `position:relative` + absolute-positioned SVG |
| Stats items left-aligned on desktop | `justify-content` missing from base `.stats-row` rule | Add `justify-content: center` to base rule (not just mobile) |
| Page hero subtitle left-aligned inside centered container | `max-width` without `margin: 0 auto` | Add `margin-left: auto; margin-right: auto` to `.page-hero p` |
| Header jumps or overlaps content on scroll | `position:fixed` + JS scroll listener | Set `position:relative`, delete scroll JS |
| Stripe checkout doesn't prefill email | `?email=` param not read on `pricing.html` | Add inline script reading `URLSearchParams` → appending to `buy.stripe.com` hrefs |
| GHL calendar doesn't prefill from contact form | URL params not injected into iframe `src` | Add inline script reading URL params → setting `iframe.src` |
| Browser shows stale error after successful redeploy | Browser cache | Test in incognito |
| Coolify deploy fails with 441 / Quirks Mode | "Is it a static site?" unchecked, Ports = 3000 | Check the box, set Ports = 80, regenerate Nginx config |
| CSS/JS changes not reflected after deploy | No cache-bust version on asset URLs | Add/increment `?v=N` on `<link>` and `<script>` tags |
| n8n receives form but fields are missing or nested | Body parsed as string or GHL-nested object | Use the Code node parse pattern from Section 4c |
| Customer gets two auto-reply emails | Both n8n Gmail node AND GHL workflow firing | Remove n8n Gmail node — GHL handles all customer-facing email |
| Drip sequence fires for wrong niche's contacts | Tags missing niche prefix (collision) | Prefix all tags with `[NICHE_CODE]-` |
| Calculated values missing from webhook payload | Hidden inputs not updated on input events | Wire input listeners to update hidden fields before submit |
| Wrong Stripe link on a tier | Links not verified against Appendix C | Cross-check every Stripe href against Appendix C before marking pricing done |
| n8n switch falls through to default branch | `form_location` missing or misspelled on a form | Every form must have a hidden `form_location` input matching a switch branch |
| Contact tagged to wrong niche in GHL | `source_site` missing from POST | `window.SITE_CONFIG.source_site` must be set on every page; main.js auto-injects |
