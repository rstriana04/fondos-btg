# Design System — FondosBTG

## Color Palette

### Primary (Brand BTG Pactual)
| Token | Hex | Usage |
|-------|-----|-------|
| Navy | `#0A2647` | Headers, sidebar, primary text |
| Blue Dark | `#144272` | Secondary backgrounds |
| Blue Mid | `#205295` | Button hover states |
| Blue Accent | `#2C74B3` | Primary buttons, active nav, links |

### Semantic
| Token | Hex | Usage |
|-------|-----|-------|
| Success | `#1D9E75` | Positive amounts, active indicators |
| Error | `#E24B4A` | Error banners, cancel buttons border |
| Warning | `#EF9F27` | Warning states |

### Surfaces
| Token | Hex | Usage |
|-------|-----|-------|
| White | `#FFFFFF` | Cards, modals, table backgrounds |
| Surface | `#F5F7FA` | Page backgrounds |
| Divider | `#E8ECF1` | Borders, separators |

### Category Badges
| Category | Background | Text |
|----------|-----------|------|
| FPV | `#E6F1FB` | `#0C447C` |
| FIC | `#EEEDFE` | `#3C3489` |

### Text
| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#0A2647` | Headings, fund names, amounts |
| Secondary | `#888780` | Labels, descriptions, dates |
| Muted | `#B4B2A9` | Disabled states, inactive nav |

### Transaction Colors
| Type | Icon BG | Amount/Text |
|------|---------|-------------|
| Subscription (money out) | `#FCEBEB` | `#A32D2D` |
| Cancellation (money in) | `#E1F5EE` | `#085041` |

## Typography

- **Font Family**: System UI (`-apple-system, system-ui, sans-serif`)
- **Font Weight**: 400 (regular), 500 (medium)

| Element | Size | Weight | Color |
|---------|------|--------|-------|
| App title | 20px | 500 | White |
| Page title (desktop) | 22px | 500 | Navy |
| Balance amount | 28px (mobile) / 22px (desktop) | 500 | White |
| Section title | 14-16px | 500 | `#444441` |
| Fund name | 13-15px | 500 | Navy |
| Min amount / labels | 12-13px | 400 | Secondary |
| Badge text | 10-11px | 500 | Category color |
| Button text | 12-15px | 500 | White |
| Nav items | 10px (mobile) / 14px (desktop) | 400 | Varies |

## Components

### Fund Card
- Background: White
- Border: 0.5px solid `#E8ECF1`
- Border radius: 12px (mobile) / 14px (desktop)
- Desktop hover: border color changes to `#B5D4F4`

### Subscribe Button
- Background: `#2C74B3`
- Text: White, 500 weight
- Border radius: 8px
- Desktop hover: background darkens to `#205295`

### Category Badge
- Border radius: 6px
- Padding: 2-3px 8-10px
- Font size: 10-11px, weight 500

### Bottom Sheet (Mobile)
- Border radius: 20px 20px 0 0
- Handle bar: 36x4px, `#D3D1C7`, centered
- Overlay: `rgba(10,38,71,0.6)`

### Dialog (Desktop)
- Width: 440px
- Border radius: 16px
- Padding: 32px
- Shadow: `0 8px 32px rgba(10,38,71,0.12)`
- Overlay: `rgba(10,38,71,0.45)`

### Radio Card (Notification Selector)
- Unselected: border 0.5px `#E8ECF1`, white bg
- Selected: border 2px `#2C74B3`, bg `#E6F1FB`, text `#0C447C`
- Desktop hover: border `#B5D4F4`
- Border radius: 10-12px

### Error Banner
- Background: `#FCEBEB`
- Border radius: 8-10px
- Icon: 6px red dot (mobile) / 20px red circle with "!" (desktop)
- Text: `#791F1F`

### Cancel Subscription Button
- Background: transparent
- Border: 0.5px solid `#E24B4A`
- Text: `#A32D2D`
- Desktop hover: fills with `#FCEBEB`

### Table (Desktop only)
- Background: White
- Border radius: 14px
- Border: 0.5px `#E8ECF1`
- Header: `#FAFBFC` bg, 12px, `#888780` text
- Row hover: `#F5F7FA`

## Layout

### Mobile (< 960px)
- Full-width content
- Bottom navigation bar (3 tabs)
- Navy header with balance

### Desktop (>= 960px)
- Fixed sidebar: 240px, navy background
- Top bar: white, page title + balance pill
- Content area with padding 32px 40px
- Stats row: 3 equal columns
- Grid/Table layouts for data

### Spacing
- Card padding: 14-20px
- Section gaps: 10-16px
- Page padding: 16px (mobile) / 32-40px (desktop)

## Currency Format

Colombian Pesos (COP) with period as thousands separator:
- `$500.000`
- `$75.000`
- `-$125.000` (subscription/deduction)
- `+$50.000` (cancellation/refund)

## Date Format

Spanish locale, abbreviated:
- `25 mar 2026, 10:32 a.m.`
