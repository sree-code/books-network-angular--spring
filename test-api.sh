#!/bin/bash

# Quick API Test Script
# Tests if your Render deployment is working

API_BASE="https://book-social-network-api-wkiu.onrender.com"

echo "🧪 Testing Book Social Network API..."
echo "======================================"
echo ""

echo "1️⃣ Testing Swagger UI..."
echo "URL: ${API_BASE}/api/v1/swagger-ui/index.html"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${API_BASE}/api/v1/swagger-ui/index.html")
if [ "$STATUS" == "200" ]; then
    echo "✅ SUCCESS: Swagger UI is accessible"
else
    echo "❌ FAILED: Swagger UI returned status $STATUS"
fi
echo ""

echo "2️⃣ Testing API Status Endpoint (after redeploy)..."
echo "URL: ${API_BASE}/api/v1/status"
RESPONSE=$(curl -s "${API_BASE}/api/v1/status" 2>/dev/null)
if echo "$RESPONSE" | grep -q "status"; then
    echo "✅ SUCCESS: Status endpoint is working"
    echo "Response: $RESPONSE"
else
    echo "⏳ WAITING: Status endpoint not available yet (deploy in progress)"
fi
echo ""

echo "3️⃣ Testing Root URL (after redeploy)..."
echo "URL: ${API_BASE}/"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${API_BASE}/")
if [ "$STATUS" == "302" ] || [ "$STATUS" == "301" ]; then
    echo "✅ SUCCESS: Root URL redirects (status $STATUS)"
elif [ "$STATUS" == "404" ]; then
    echo "⏳ WAITING: Root URL still 404 (redeploy not complete yet)"
else
    echo "📋 INFO: Root URL returned status $STATUS"
fi
echo ""

echo "======================================"
echo "📊 Summary:"
echo ""
echo "Your API base URL:"
echo "  ${API_BASE}/api/v1"
echo ""
echo "Swagger UI (always works):"
echo "  ${API_BASE}/api/v1/swagger-ui/index.html"
echo ""
echo "After redeploy completes:"
echo "  Root URL: ${API_BASE}/"
echo "  Status:   ${API_BASE}/api/v1/status"
echo "  Health:   ${API_BASE}/api/v1/status/health"
echo ""
echo "Open Swagger UI in your browser to test your API! 🚀"

