# The name of this view in Looker is "Trans Union Ga4 Dynamic Table"
view: trans_union_ga4_dynamic_table {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "DBO"."TransUnion_GA4_Dynamic_Table" ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Ai Platform" in Explore.

  dimension: ai_platform {
    type: string
    sql: ${TABLE}."AI_PLATFORM" ;;
  }

  dimension: channel_grouping {
    type: string
    sql: ${TABLE}."CHANNEL_GROUPING" ;;
  }

  dimension: client_id {
    type: number
    sql: ${TABLE}."CLIENT_ID" ;;
  }

  dimension: conversion_dashboard_column {
    type: string
    sql: ${TABLE}."CONVERSION_DASHBOARD_COLUMN" ;;
  }

  dimension: conversion_funnel_stage {
    type: string
    sql: ${TABLE}."CONVERSION_FUNNEL_STAGE" ;;
  }

  dimension: conversion_name {
    type: string
    sql: ${TABLE}."CONVERSION_NAME" ;;
  }

  dimension: conversion_product_group {
    type: string
    sql: ${TABLE}."CONVERSION_PRODUCT_GROUP" ;;
  }

  dimension: conversions {
    type: number
    sql: ${TABLE}."CONVERSIONS" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension: device_category {
    type: string
    sql: ${TABLE}."DEVICE_CATEGORY" ;;
  }

  dimension: device_sessions {
    type: number
    sql: ${TABLE}."DEVICE_SESSIONS" ;;
  }

  dimension: device_users {
    type: number
    sql: ${TABLE}."DEVICE_USERS" ;;
  }

  dimension: engaged_sessions {
    type: number
    sql: ${TABLE}."ENGAGED_SESSIONS" ;;
  }

  dimension: ga4_dataset {
    type: string
    sql: ${TABLE}."GA4_DATASET" ;;
  }

  dimension: is_ai_referral {
    type: yesno
    sql: ${TABLE}."IS_AI_REFERRAL" ;;
  }

  dimension: is_business_conversion {
    type: yesno
    sql: ${TABLE}."IS_BUSINESS_CONVERSION" ;;
  }

  dimension: is_top5_ai_platform {
    type: yesno
    sql: ${TABLE}."IS_TOP5_AI_PLATFORM" ;;
  }

  dimension: market_revenue {
    type: number
    sql: ${TABLE}."MARKET_REVENUE" ;;
  }

  dimension: market_sessions {
    type: number
    sql: ${TABLE}."MARKET_SESSIONS" ;;
  }

  dimension: market_transactions {
    type: number
    sql: ${TABLE}."MARKET_TRANSACTIONS" ;;
  }

  dimension: property_id {
    type: string
    sql: ${TABLE}."PROPERTY_ID" ;;
  }

  dimension: purchase_revenue {
    type: number
    sql: ${TABLE}."PURCHASE_REVENUE" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."REGION" ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: report {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."REPORT_DATE" ;;
  }

  dimension: screen_page_views {
    type: number
    sql: ${TABLE}."SCREEN_PAGE_VIEWS" ;;
  }

  dimension: session_duration_sec {
    type: number
    sql: ${TABLE}."SESSION_DURATION_SEC" ;;
  }

  dimension: session_medium {
    type: string
    sql: ${TABLE}."SESSION_MEDIUM" ;;
  }

  dimension: session_source {
    type: string
    sql: ${TABLE}."SESSION_SOURCE" ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}."SESSIONS" ;;
  }

  dimension: source_medium {
    type: string
    sql: ${TABLE}."SOURCE_MEDIUM" ;;
  }

  dimension: total_users {
    type: number
    sql: ${TABLE}."TOTAL_USERS" ;;
  }

  dimension: transactions {
    type: number
    sql: ${TABLE}."TRANSACTIONS" ;;
  }
  measure: count {
    type: count
    drill_fields: [conversion_name]
  }
}
