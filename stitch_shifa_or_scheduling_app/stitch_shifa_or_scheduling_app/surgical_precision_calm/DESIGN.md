---
name: Surgical Precision Calm
colors:
  surface: '#effdf6'
  surface-dim: '#cfddd7'
  surface-bright: '#effdf6'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e9f7f0'
  surface-container: '#e3f1ea'
  surface-container-high: '#ddebe5'
  surface-container-highest: '#d8e6df'
  on-surface: '#121e1a'
  on-surface-variant: '#3f4944'
  inverse-surface: '#27332f'
  inverse-on-surface: '#e6f4ed'
  outline: '#6f7a74'
  outline-variant: '#bec9c3'
  surface-tint: '#086b53'
  primary: '#005440'
  on-primary: '#ffffff'
  primary-container: '#0f6e56'
  on-primary-container: '#9aedcf'
  inverse-primary: '#84d6b9'
  secondary: '#006c4e'
  on-secondary: '#ffffff'
  secondary-container: '#83f5c6'
  on-secondary-container: '#007151'
  tertiary: '#684000'
  on-tertiary: '#ffffff'
  tertiary-container: '#885600'
  on-tertiary-container: '#ffd5a6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a0f3d4'
  primary-fixed-dim: '#84d6b9'
  on-primary-fixed: '#002117'
  on-primary-fixed-variant: '#00513e'
  secondary-fixed: '#86f8c9'
  secondary-fixed-dim: '#68dbae'
  on-secondary-fixed: '#002115'
  on-secondary-fixed-variant: '#00513a'
  tertiary-fixed: '#ffddb7'
  tertiary-fixed-dim: '#ffb95d'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#effdf6'
  on-background: '#121e1a'
  surface-variant: '#d8e6df'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 38px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  title-md:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 20px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  space-xxs: 0.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.5rem
  space-2xl: 2rem
  space-3xl: 2.5rem
  screen-edge-margin: 1rem
  card-inner-padding: 1.25rem
  stack-gap: 1rem
---

## Brand & Style

This design system serves high-stakes surgical environments where visual noise directly correlates with cognitive fatigue and clinical error. Built for operating room (OR) directors, charge nurses, and surgical coordinators, the aesthetic combines absolute operational clarity with therapeutic calm. 

The design narrative embodies **Clinical Serenity & Decisive Clarity**:
- **Personality:** Controlled, precise, reassuring, and immediate.
- **Target Audience:** Surgical staff, circulating nurses, anesthesiologists, and chief medical officers monitoring real-time room velocity on mobile devices.
- **Emotional Response:** Certainty, trust, and unhurried composure under intense clinical timelines.
- **Design Style:** Modern Clinical Minimalism. Eliminates dense desktop-style hospital tables in favor of glanceable mobile cards, open negative space, and disciplined color-coded state management.
- **Core Rule of Restraint:** A strict threshold of 4–6 primary interactive or informational elements per view to guarantee sub-second situational awareness during rounds or quick scrub transitions.

## Colors

The palette balances clinical sterility with organic reassurance, prioritizing glanceable status identification across OR suites.

### Core Architecture
- **Primary (`#0F6E56`):** Deep surgical teal. Anchors primary actions, confirmed states, selected room navigation, and high-level structure.
- **Secondary (`#1D9E75`):** Medium lively teal. Utilized for secondary confirmations, interactive highlights, and active filter states.
- **Accent / Alert (`#EF9F27`):** Warm amber. Reserved exclusively for surgical delays, turnover warnings, and sterilization holds.
- **Danger / Emergency (`#E24B4A`):** Emergency crimson. Used solely for emergency add-ons, patient trauma priority flags, and critical OR equipment failure.
- **Backgrounds:** Canvas defaults to `#F8FAF9` with secondary sections leveraging `#F9FBFA` to prevent screen glare under harsh surgical overheads.
- **Surfaces:** Pure `#FFFFFF` cards framed by structural borders (`#E5EBE8`).
- **Text & Contrast:** Neutral `#17231F` achieves rigorous WCAG AAA compliance on all surface cards, with `#52665F` serving as the subdued secondary text.

### Clinical Operational Statuses
- **Free / Available:** Background `#E6F5F0`, Text/Border `#0F6E56`
- **In Use / Active Case:** Background `#0F6E56`, Text `#FFFFFF`
- **Preparing / Pre-Op:** Background `#FEF6E9`, Text `#B4710A`
- **Cleaning / Turnover:** Background `#F0F3F2`, Text `#52665F`

## Typography

Typography pairs **Plus Jakarta Sans** for commanding, humanized headings with **Inter** for rational, data-dense legibility.

### Hierarchy & Scale Rules
- **Numerical Primacy:** Time sequences (e.g., "07:30 - 11:45") and room identifiers (e.g., "OR-04") must render with tabular figures (`tnum`) to maintain structural alignment in live queue updates.
- **Visual Weighting:** Headline weights are restricted to Semi-Bold (`600`) and Bold (`700`) to assure instantaneous legibility when the phone is mounted or held at arm's length.
- **De-emphasized Metadata:** Anesthesiologist names, case IDs, and scrub team credentials leverage `body-sm` in secondary neutral (`#52665F`) to maintain clear hierarchy over surgical case titles.

## Layout & Spacing

The layout employs a vertical single-column mobile rhythm engineered around thumb zones and immediate scanning.

### Layout Model
- **Grid Architecture:** Single-column card stacks on mobile devices (`360px` to `428px`) with `16px` outer boundary margins (`screen-edge-margin`).
- **Rhythm & Cadence:** An 8-point base grid system rules all element spacing. Vertical spacing between room schedule cards is strictly set to `16px` (`space-md`), creating distinct mental modules without visual crowding.
- **Scannable Capacity:** Screens must never scroll endlessly through raw logs. Each view surfaces a persistent top summary header (active suite status) followed by 4–6 high-priority room objects. Secondary details reside behind modal slide-overs.
- **Touch Targets:** Touch targets must maintain a minimum physical box of `48px × 48px` to support reliable interaction for clinicians wearing surgical gloves.

## Elevation & Depth

Visual hierarchy uses flat architecture stabilized by deliberate, whisper-soft atmospheric depth.

### Depth Strategy
- **Low-Contrast Outlines:** The primary separation mechanism is a `1px` stroke using `#E5EBE8` across cards, dividers, and pill tags. This ensures structural discipline without relying on dark, muddy shadows.
- **Ambient Floor Shadows:** Standard operational cards rest on an ultra-diffused, ambient shadow:
  - `box-shadow: 0 2px 8px -2px rgba(15, 110, 86, 0.04), 0 1px 4px -1px rgba(23, 35, 31, 0.02);`
- **Active / Drag Elevation:** When an OR case is being rescheduled or held, the card transitions to an elevated state:
  - `box-shadow: 0 8px 24px -4px rgba(15, 110, 86, 0.08), 0 2px 6px -1px rgba(23, 35, 31, 0.04);`
  - Border transitions to `#1D9E75` (50% opacity).
- **Modals & Overlays:** Background scrim uses a neutral wash (`#17231F` at 32% opacity) paired with a subtle blur (`backdrop-filter: blur(4px)`).

## Shapes

The design system uses deliberate, rounded geometry to soften the clinical interface and frame complex medical schedules within intuitive containers.

### Corner Radius System
- **Cards & Primary Modules:** Uniform `16px` (`1rem`) border-radius. Every surgical suite card, summary panel, and bottom sheet header maintains this consistent perimeter.
- **Pill Badges & Tags:** Fully circular `9999px` capsule radii to distinguish transient statuses from structural elements.
- **Interactive Buttons:** `12px` (`0.75rem`) corner radius to provide a stable, finger-friendly tactile surface.
- **Input Fields & Search:** `12px` (`0.75rem`) corner radius.

## Components

### Buttons
- **Primary:** Background `#0F6E56`, text `#FFFFFF`, radius `12px`, height `48px`, font `label-lg`. Active state shifts to `#0A4D3C`.
- **Secondary / Subdued:** Background `#E6F5F0`, text `#0F6E56`, border `1px solid transparent`, height `48px`.
- **Destructive / Emergency:** Background `#E24B4A`, text `#FFFFFF`, height `48px`. Reserved for emergency reallocations.

### Pill Status Badges
Status badges are compact (`24px` height, `8px` horizontal padding), full-pill (`9999px`), with `label-sm` typography:
- **Free:** Background `#E6F5F0`, text `#0F6E56`, border `1px solid #C4EADF`.
- **In Use:** Background `#0F6E56`, text `#FFFFFF`, border `1px solid #0F6E56`.
- **Preparing:** Background `#FEF6E9`, text `#B4710A`, border `1px solid #F8DFB7`.
- **Cleaning:** Background `#F0F3F2`, text `#52665F`, border `1px solid #DCE3E0`.

### OR Suite Cards
The signature component of the system:
- **Surface:** Pure `#FFFFFF` background, `16px` border-radius, `1px solid #E5EBE8`, `20px` internal padding.
- **Top Row:** Suite identifier (e.g., "OR-02" in `headline-sm`), accompanied by the full-pill Status Badge aligned right.
- **Middle Section:** Current surgical procedure (e.g., "Laparoscopic Appendectomy" in `title-lg`), followed by lead surgeon name in `body-sm` (`#52665F`).
- **Footer Row:** Schedule interval with a micro clock icon (e.g., "08:30 – 10:15") and a simple elapsed time indicator bar (`4px` height, muted green track, `#1D9E75` fill).

### Lists & Queue Items
- Dividers between scheduled list items use `1px solid #F0F3F2`. Zero harsh black rules.
- Queue rows use dynamic touch highlights with an instant `#F8FAF9` tap state.

### Input & Filter Controls
- **Search & Quick Toggles:** Height `44px`, background `#FFFFFF`, border `1px solid #E5EBE8`, interior placeholder `#8A9E97`.
- **OR Suite Filter Pills:** Horizontal scrollable row of capsules (`36px` height); selected state is solid `#0F6E56` with white text; unselected is white background with `#52665F` text and `1px solid #E5EBE8`.