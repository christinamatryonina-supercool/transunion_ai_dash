# =============================================================================

# GA4 daily - DWH.DBO."TransUnion_GA4_Daily_Dynamic_Table"
# - ROW_TYPE sessions | events, same dimensions -> Date, AI Engine, Market, Device cut everything
# - Measures = current period (CP); *_pp = previous period of the same length
# - Totals: explore ga4_ai_traffic (sites only). Products: explore ga4_products (subproperties)
# =============================================================================

view: ga4_daily {
  sql_table_name: DWH.DBO."TransUnion_GA4_Daily_Dynamic_Table" ;;

  # ---------------- Period: CP vs PP ----------------
  filter: period {
    type: date
    label: "Date Range"
    description: "Current period (CP). PP = same number of days right before."
  }
  dimension: period_type {
    type: string
    label: "Period (CP / PP)"
    sql: CASE
           WHEN ${TABLE}.REPORT_DATE >= {% date_start period %}::DATE
            AND ${TABLE}.REPORT_DATE <  {% date_end period %}::DATE THEN 'CP'
           WHEN ${TABLE}.REPORT_DATE >= DATEADD(day, DATEDIFF(day, {% date_end period %}::DATE, {% date_start period %}::DATE), {% date_start period %}::DATE)
            AND ${TABLE}.REPORT_DATE <  {% date_start period %}::DATE THEN 'PP'
         END ;;
  }
  dimension: is_cp { hidden: yes type: yesno sql: ${period_type} = 'CP' ;; }
  dimension: is_pp { hidden: yes type: yesno sql: ${period_type} = 'PP' ;; }

  # ---------------- Dimensions ----------------
  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.ROW_TYPE || '|' || ${TABLE}.REPORT_DATE || '|' || ${TABLE}.PROPERTY_ID || '|' ||
         COALESCE(${TABLE}.SESSION_SOURCE_MEDIUM,'') || '|' || COALESCE(${TABLE}.CHANNEL_GROUP,'') || '|' ||
         COALESCE(${TABLE}.DEVICE_CATEGORY,'') || '|' || COALESCE(${TABLE}.COUNTRY,'') || '|' ||
         COALESCE(${TABLE}.REGION,'') || '|' || COALESCE(${TABLE}.EVENT_NAME,'') ;;
  }

  dimension_group: report {
    type: time
    label: "Report"
    timeframes: [raw, date, week, month]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.REPORT_DATE ;;
  }

  dimension: row_type      { group_label: "Technical" description: "sessions | events" sql: ${TABLE}.ROW_TYPE ;; }

  dimension: property_name { group_label: "Property" label: "GA4 Property" sql: ${TABLE}.PROPERTY_NAME ;; }
  dimension: product {
    group_label: "Property"
    label: "Product"
    description: "Subproperty as product (DSS, ACR, B2B...)"
    sql: REPLACE(REPLACE(${TABLE}.PROPERTY_NAME, 'GA4 TUCI ', ''), 'GA ', '') ;;
  }
  dimension: property_type { group_label: "Property" description: "site | subproperty" sql: ${TABLE}.PROPERTY_TYPE ;; }
  dimension: include_in_total { group_label: "Property" type: yesno sql: ${TABLE}.INCLUDE_IN_TOTAL ;; }

  dimension: source_medium  { group_label: "Source" label: "Source / Medium" sql: ${TABLE}.SESSION_SOURCE_MEDIUM ;; }
  dimension: session_source { group_label: "Source" label: "Source" sql: ${TABLE}.SESSION_SOURCE ;; }
  dimension: session_medium { group_label: "Source" label: "Medium" sql: ${TABLE}.SESSION_MEDIUM ;; }
  dimension: channel_group  { group_label: "Source" label: "Channel" sql: ${TABLE}.CHANNEL_GROUP ;; }

  dimension: ai_platform {
    group_label: "AI"
    label: "AI Engine"
    suggest_explore: ai_platform_suggest
    suggest_dimension: dim_ai_platform.ai_platform
    sql: ${TABLE}.AI_PLATFORM ;;
  }
  dimension: is_ai_referral      { group_label: "AI" label: "Is AI Referral" type: yesno sql: ${TABLE}.IS_AI_REFERRAL ;; }
  dimension: is_top5_ai_platform { group_label: "AI" label: "Is Top 5 AI Engine" type: yesno sql: ${TABLE}.IS_TOP5_AI_PLATFORM ;; }

  dimension: device_category { group_label: "Audience" label: "Device" sql: ${TABLE}.DEVICE_CATEGORY ;; }
  dimension: country         { group_label: "Audience" label: "Country" map_layer_name: countries sql: ${TABLE}.COUNTRY ;; }
  dimension: region { hidden: yes group_label: "Audience" label: "Region" description: "Not available yet (NULL) - country only" sql: ${TABLE}.REGION ;; }

  dimension: event_name                  { group_label: "Conversion" label: "Key Event" sql: ${TABLE}.EVENT_NAME ;; }
  dimension: conversion_product_group    { group_label: "Conversion" label: "Product Group" sql: ${TABLE}.CONVERSION_PRODUCT_GROUP ;; }
  dimension: conversion_funnel_stage     { group_label: "Conversion" label: "Funnel Stage" sql: ${TABLE}.CONVERSION_FUNNEL_STAGE ;; }
  dimension: is_business_conversion      { group_label: "Conversion" type: yesno sql: ${TABLE}.IS_BUSINESS_CONVERSION ;; }
  dimension: conversion_dashboard_column { group_label: "Conversion" label: "Dashboard Column" sql: ${TABLE}.CONVERSION_DASHBOARD_COLUMN ;; }

  # ---------------- Traffic ----------------
  measure: sessions    { group_label: "Traffic" type: sum sql: IFF(${is_cp}, ${TABLE}.SESSIONS, NULL) ;; value_format_name: decimal_0 }
  measure: sessions_pp { group_label: "Traffic · PP" label: "Sessions (PP)" type: sum sql: IFF(${is_pp}, ${TABLE}.SESSIONS, NULL) ;; value_format_name: decimal_0 }

  measure: ai_sessions    { group_label: "Traffic" label: "AI Sessions" type: sum sql: IFF(${is_cp} AND ${TABLE}.IS_AI_REFERRAL, ${TABLE}.SESSIONS, NULL) ;; value_format_name: decimal_0 }
  measure: ai_sessions_pp { group_label: "Traffic · PP" label: "AI Sessions (PP)" type: sum sql: IFF(${is_pp} AND ${TABLE}.IS_AI_REFERRAL, ${TABLE}.SESSIONS, NULL) ;; value_format_name: decimal_0 }
  measure: ai_share {
    group_label: "Traffic"
    label: "AI Share of Traffic"
    description: "AI sessions / all sessions"
    type: number
    sql: ${ai_sessions} / NULLIF(${sessions}, 0) ;;
    value_format_name: percent_2
  }
  measure: ai_share_pp {
    group_label: "Traffic · PP"
    label: "AI Share of Traffic (PP)"
    type: number
    sql: ${ai_sessions_pp} / NULLIF(${sessions_pp}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_users    { group_label: "Traffic" label: "Users" description: "Summed across days - slightly above GA4 unique users" type: sum sql: IFF(${is_cp}, ${TABLE}.TOTAL_USERS, NULL) ;; value_format_name: decimal_0 }
  measure: total_users_pp { group_label: "Traffic · PP" label: "Users (PP)" type: sum sql: IFF(${is_pp}, ${TABLE}.TOTAL_USERS, NULL) ;; value_format_name: decimal_0 }
  measure: new_users      { group_label: "Traffic" type: sum sql: IFF(${is_cp}, ${TABLE}.NEW_USERS, NULL) ;; value_format_name: decimal_0 }

  # ---------------- Engagement ----------------
  measure: engaged_sessions        { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.ENGAGED_SESSIONS, NULL) ;; }
  measure: engaged_sessions_pp     { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.ENGAGED_SESSIONS, NULL) ;; }
  measure: screen_page_views       { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.SCREEN_PAGE_VIEWS, NULL) ;; }
  measure: session_duration_sec    { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.SESSION_DURATION_SEC, NULL) ;; }
  measure: session_duration_sec_pp { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.SESSION_DURATION_SEC, NULL) ;; }

  measure: engagement_rate    { group_label: "Engagement" type: number sql: ${engaged_sessions} / NULLIF(${sessions}, 0) ;; value_format_name: percent_1 }
  measure: engagement_rate_pp { group_label: "Engagement · PP" label: "Engagement Rate (PP)" type: number sql: ${engaged_sessions_pp} / NULLIF(${sessions_pp}, 0) ;; value_format_name: percent_1 }
  measure: pages_per_session  { group_label: "Engagement" label: "Pages / Session" type: number sql: ${screen_page_views} / NULLIF(${sessions}, 0) ;; value_format_name: decimal_2 }
  measure: avg_session_duration    { group_label: "Engagement" label: "Avg Session Duration" type: number sql: ${session_duration_sec} / NULLIF(${sessions}, 0) / 86400 ;; value_format: "m:ss" }
  measure: avg_session_duration_pp { group_label: "Engagement · PP" label: "Avg Session Duration (PP)" type: number sql: ${session_duration_sec_pp} / NULLIF(${sessions_pp}, 0) / 86400 ;; value_format: "m:ss" }

  # ---------------- Revenue ----------------
  measure: transactions        { group_label: "Revenue" type: sum sql: IFF(${is_cp}, ${TABLE}.TRANSACTIONS, NULL) ;; value_format_name: decimal_0 }
  measure: purchase_revenue    { group_label: "Revenue" label: "Revenue" type: sum sql: IFF(${is_cp}, ${TABLE}.PURCHASE_REVENUE, NULL) ;; value_format_name: usd_0 }
  measure: purchase_revenue_pp { group_label: "Revenue · PP" label: "Revenue (PP)" type: sum sql: IFF(${is_pp}, ${TABLE}.PURCHASE_REVENUE, NULL) ;; value_format_name: usd_0 }

  # ---------------- Conversions (events rows) ----------------
  measure: key_events    { group_label: "Conversions" label: "Key Events" type: sum sql: IFF(${is_cp}, ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: key_events_pp { group_label: "Conversions · PP" label: "Key Events (PP)" type: sum sql: IFF(${is_pp}, ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: business_conversions    { group_label: "Conversions" description: "Key events excl. errors, clicks, downloads" type: sum sql: IFF(${is_cp} AND ${TABLE}.IS_BUSINESS_CONVERSION, ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: business_conversions_pp { group_label: "Conversions · PP" label: "Business Conversions (PP)" type: sum sql: IFF(${is_pp} AND ${TABLE}.IS_BUSINESS_CONVERSION, ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: signups    { group_label: "Conversions" type: sum sql: IFF(${is_cp} AND ${TABLE}.CONVERSION_DASHBOARD_COLUMN = 'Signups', ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: signups_pp { group_label: "Conversions · PP" label: "Signups (PP)" type: sum sql: IFF(${is_pp} AND ${TABLE}.CONVERSION_DASHBOARD_COLUMN = 'Signups', ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: visits_dss { group_label: "Conversions" label: "DSS Events" description: "PROVISIONAL Visits_DSS = DSS_* key events" type: sum sql: IFF(${is_cp} AND ${TABLE}.CONVERSION_PRODUCT_GROUP = 'DSS', ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }
  measure: visits_acr { group_label: "Conversions" label: "ACR Events" description: "PROVISIONAL Visits_ACR = FactAct_* key events" type: sum sql: IFF(${is_cp} AND ${TABLE}.CONVERSION_PRODUCT_GROUP = 'FactAct', ${TABLE}.KEY_EVENTS, NULL) ;; value_format_name: decimal_0 }

  measure: conversion_rate    { group_label: "Conversions" label: "Conversion Rate" description: "Business conversions / sessions" type: number sql: ${business_conversions} / NULLIF(${sessions}, 0) ;; value_format_name: percent_2 }
  measure: conversion_rate_pp { group_label: "Conversions · PP" label: "Conversion Rate (PP)" type: number sql: ${business_conversions_pp} / NULLIF(${sessions_pp}, 0) ;; value_format_name: percent_2 }
  measure: signup_rate        { group_label: "Conversions" label: "Signup Rate" type: number sql: ${signups} / NULLIF(${sessions}, 0) ;; value_format_name: percent_2 }
}
