# Rihla Place Data 🗺️

Structured tourism data for the **Rihla (رحلة)** AI-powered vacation planner for Algeria.

## Place Types

| Type | Code | Description | Bookable? | Trackable? |
|------|------|-------------|-----------|------------|
| 🏨 Comfortable | `comfortable` | Hotels, restaurants, paid services | ✅ YES | ❌ |
| 🕌 Public | `public` | Heritage sites, mosques, museums | ❌ NO | ❌ |
| 🏔️ Wild | `wild` | Mountains, beaches, nature parks | ❌ NO | ✅ YES (GPS) |

## Supported Wilayas

- 🇩🇿 **الجزائر العاصمة** (Algiers)
- 🏖️ **بجاية** (Bejaia)
- 🔜 More coming soon...

## Data Structure

```json
{
  "wilayas": [
    {
      "id": "algiers",
      "name": "الجزائر العاصمة",
      "places": [...],
      "guides": [...]
    }
  ]
}
```

## Usage

This data is consumed by the Rihla Flutter app and the AI agent system for itinerary generation.
