#!/bin/bash
# Fetch Klaviyo data and save as JSON for static dashboard

API_KEY="${KLAVIYO_API_KEY}"
REVISION="2024-10-15"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/../data"

mkdir -p "$OUTPUT_DIR"

echo "Fetching campaign report..."
curl -s -X POST "https://a.klaviyo.com/api/campaign-values-reports/" \
  -H "Authorization: Klaviyo-API-Key $API_KEY" \
  -H "revision: $REVISION" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "data": {
      "type": "campaign-values-report",
      "attributes": {
        "statistics": ["opens", "clicks", "recipients", "open_rate", "click_rate", "unsubscribes", "conversion_value", "conversions"],
        "timeframe": {"key": "last_365_days"},
        "conversion_metric_id": "L6yntZ"
      }
    }
  }' > "$OUTPUT_DIR/campaigns.json"

sleep 2

echo "Fetching flow report..."
curl -s -X POST "https://a.klaviyo.com/api/flow-values-reports/" \
  -H "Authorization: Klaviyo-API-Key $API_KEY" \
  -H "revision: $REVISION" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "data": {
      "type": "flow-values-report",
      "attributes": {
        "statistics": ["opens", "clicks", "recipients", "open_rate", "click_rate", "unsubscribes", "conversion_value", "conversions"],
        "timeframe": {"key": "last_365_days"},
        "conversion_metric_id": "L6yntZ"
      }
    }
  }' > "$OUTPUT_DIR/flows.json"

sleep 2

echo "Fetching flows metadata..."
curl -s "https://a.klaviyo.com/api/flows/" \
  -H "Authorization: Klaviyo-API-Key $API_KEY" \
  -H "revision: $REVISION" \
  -H "Accept: application/json" > "$OUTPUT_DIR/flows-meta.json"

sleep 2

echo "Fetching campaigns metadata..."
curl -s "https://a.klaviyo.com/api/campaigns/?filter=equals(messages.channel,'email')" \
  -H "Authorization: Klaviyo-API-Key $API_KEY" \
  -H "revision: $REVISION" \
  -H "Accept: application/json" > "$OUTPUT_DIR/campaigns-meta.json"

echo "Done! Data saved to $OUTPUT_DIR"
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" > "$OUTPUT_DIR/last-updated.txt"
