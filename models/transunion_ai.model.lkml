# =============================================================================

# TransUnion AI - model (transunion_ai)
# - GA4 on "TransUnion_GA4_Daily_Dynamic_Table" (sessions + key events, same dimensions)
# - Scrunch on the 3 Scrunch dynamic tables (response / brand / citation)
# - Explores are never joined to each other; each requires a Date Range (CP vs PP)
# =============================================================================

connection: "snowflake-dwh"

include: "/views/*.view.lkml"
include: "/dashboards/*.dashboard.lookml"

datagroup: tu_geo_daily {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}
persist_with: tu_geo_daily

# ---------------- GA4 ----------------
# Totals: sites only (subproperties are already inside GA4 US)
explore: ga4_ai_traffic {
  view_name: ga4_daily
  label: "GA4 · AI Referral Traffic"
  always_filter: { filters: [ga4_daily.period: "28 days"] }
  sql_always_where: ${ga4_daily.include_in_total}
    AND {% if ga4_daily.period._is_filtered %} ${ga4_daily.period_type} IS NOT NULL {% else %} 1=1 {% endif %} ;;
}

# Products: subproperties only (DSS, ACR, B2B, ...) - never mixed with totals
explore: ga4_products {
  view_name: ga4_daily
  label: "GA4 · AI Traffic by Product"
  always_filter: { filters: [ga4_daily.period: "28 days"] }
  sql_always_where: NOT ${ga4_daily.include_in_total}
    AND {% if ga4_daily.period._is_filtered %} ${ga4_daily.period_type} IS NOT NULL {% else %} 1=1 {% endif %} ;;
}

# ---------------- Scrunch ----------------
explore: scrunch_responses {
  view_name: scrunch_response
  label: "Scrunch · AI Responses"
  always_filter: { filters: [scrunch_response.period: "28 days"] }
  sql_always_where: {% if scrunch_response.period._is_filtered %} ${scrunch_response.period_type} IS NOT NULL {% else %} 1=1 {% endif %} ;;
}
explore: scrunch_brands {
  view_name: scrunch_brand
  label: "Scrunch · Brands (Share of Voice)"
  always_filter: { filters: [scrunch_brand.period: "28 days"] }
  sql_always_where: {% if scrunch_brand.period._is_filtered %} ${scrunch_brand.period_type} IS NOT NULL {% else %} 1=1 {% endif %} ;;
}
explore: scrunch_citations {
  view_name: scrunch_citation
  label: "Scrunch · Citations"
  always_filter: { filters: [scrunch_citation.period: "28 days"] }
  sql_always_where: {% if scrunch_citation.period._is_filtered %} ${scrunch_citation.period_type} IS NOT NULL {% else %} 1=1 {% endif %} ;;
}

# ---------------- Filter value sources (hidden) ----------------
explore: ai_platform_suggest { view_name: dim_ai_platform hidden: yes }
explore: suggest_ga4         { view_name: ga4_daily hidden: yes }
explore: suggest_scrunch     { view_name: scrunch_response hidden: yes }
