# The name of this view in Looker is "Trans Union Looker Dynamic Table"
view: trans_union_looker_dynamic_table {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "DBO"."TransUnion_Looker_dynamic_table" ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Account ID" in Explore.

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}."account_name" ;;
  }

  dimension: ai_platform {
    type: string
    sql: ${TABLE}."ai_platform" ;;
  }

  dimension: brand_attribute {
    type: string
    sql: ${TABLE}."brand_attribute" ;;
  }

  dimension: brand_mention_count {
    type: number
    sql: ${TABLE}."brand_mention_count" ;;
  }

  dimension: brand_position {
    type: string
    sql: ${TABLE}."brand_position" ;;
  }

  dimension: branded {
    type: yesno
    sql: ${TABLE}."branded" ;;
  }

  dimension: channel_grouping {
    type: string
    sql: ${TABLE}."channel_grouping" ;;
  }

  dimension: citation_count {
    type: number
    sql: ${TABLE}."citation_count" ;;
  }

  dimension: client_id {
    type: number
    sql: ${TABLE}."client_id" ;;
  }

  dimension: client_name {
    type: string
    sql: ${TABLE}."client_name" ;;
  }

  dimension: competitor_mention_count {
    type: number
    sql: ${TABLE}."competitor_mention_count" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: date {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."date" ;;
  }

  dimension: device_category {
    type: string
    sql: ${TABLE}."device_category" ;;
  }

  dimension: engagement_sessions {
    type: number
    sql: ${TABLE}."engagement_sessions" ;;
  }

  dimension: event_count {
    type: number
    sql: ${TABLE}."event_count" ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}."event_name" ;;
  }

  dimension: first_mention_count {
    type: number
    sql: ${TABLE}."first_mention_count" ;;
  }

  dimension: is_ai_referral {
    type: yesno
    sql: ${TABLE}."is_ai_referral" ;;
  }

  dimension: negative_sentiment_count {
    type: number
    sql: ${TABLE}."negative_sentiment_count" ;;
  }

  dimension: neutral_sentiment_count {
    type: number
    sql: ${TABLE}."neutral_sentiment_count" ;;
  }

  dimension: new_users {
    type: number
    sql: ${TABLE}."new_users" ;;
  }

  dimension: persona_id {
    type: string
    sql: ${TABLE}."persona_id" ;;
  }

  dimension: persona_name {
    type: string
    sql: ${TABLE}."persona_name" ;;
  }

  dimension: positive_sentiment_count {
    type: number
    sql: ${TABLE}."positive_sentiment_count" ;;
  }

  dimension: product_tag {
    type: string
    sql: ${TABLE}."product_tag" ;;
  }

  dimension: prompt {
    type: string
    sql: ${TABLE}."prompt" ;;
  }

  dimension: prompt_id {
    type: string
    sql: ${TABLE}."prompt_id" ;;
  }

  dimension: property_id {
    type: string
    sql: ${TABLE}."property_id" ;;
  }

  dimension: purchase_revenue {
    type: number
    sql: ${TABLE}."purchase_revenue" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."region" ;;
  }

  dimension: response_count {
    type: number
    sql: ${TABLE}."response_count" ;;
  }

  dimension: screen_page_views {
    type: number
    sql: ${TABLE}."screen_page_views" ;;
  }

  dimension: sentiment_score_sum {
    type: number
    sql: ${TABLE}."sentiment_score_sum" ;;
  }

  dimension: sentiment_scored_count {
    type: number
    sql: ${TABLE}."sentiment_scored_count" ;;
  }

  dimension: session_duration {
    type: number
    sql: ${TABLE}."session_duration" ;;
  }

  dimension: session_medium {
    type: string
    sql: ${TABLE}."session_medium" ;;
  }

  dimension: session_source {
    type: string
    sql: ${TABLE}."session_source" ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}."sessions" ;;
  }

  dimension: source_medium {
    type: string
    sql: ${TABLE}."source_medium" ;;
  }

  dimension: source_table {
    type: string
    sql: ${TABLE}."source_table" ;;
  }

  dimension: stage {
    type: string
    sql: ${TABLE}."stage" ;;
  }

  dimension: total_users {
    type: number
    sql: ${TABLE}."total_users" ;;
  }

  dimension: transactions {
    type: number
    sql: ${TABLE}."transactions" ;;
  }

  dimension: transunion_cited_response_count {
    type: number
    sql: ${TABLE}."transunion_cited_response_count" ;;
  }

  dimension: transunion_status {
    type: string
    sql: ${TABLE}."transunion_status" ;;
  }

  dimension: transunion_status_value {
    type: string
    sql: ${TABLE}."transunion_status_value" ;;
  }

  dimension: winner_domain {
    type: string
    sql: ${TABLE}."winner_domain" ;;
  }
  measure: count {
    type: count
    drill_fields: [client_name, account_name, event_name, persona_name]
  }
}
