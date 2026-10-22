# =============================================================================

# Scrunch - 1 row per AI response  -  DWH.DBO."TransUnion_Scrunch_Dynamic_Table"
# - Measures = current period (CP); *_pp = previous period of same length
# - First-mention = brand_position 'top' (Scrunch has no numeric rank)
# =============================================================================

view: scrunch_response {
  sql_table_name: DWH.DBO."TransUnion_Scrunch_Dynamic_Table" ;;

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

  # ---------------- Sentiment switch ----------------
  parameter: sentiment_none_mode {
    label: "Sentiment: 'none' handling"
    description: "'none' = TU mentioned without tone. Neutral keeps it in Net Sentiment; Exclude drops it."
    type: unquoted
    allowed_value: { label: "Count 'none' as neutral" value: "neutral" }
    allowed_value: { label: "Exclude 'none'"          value: "exclude" }
    default_value: "neutral"
  }

  # ---------------- Dimensions ----------------
  dimension: response_id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.RESPONSE_ID ;;
  }

  dimension_group: report {
    type: time
    label: "Report"
    timeframes: [raw, date, week, month]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.REPORT_DATE ;;
  }

  dimension: prompt_id    { group_label: "Prompt" hidden: yes sql: ${TABLE}.PROMPT_ID ;; }
  dimension: prompt       { group_label: "Prompt" label: "Prompt / Query" sql: ${TABLE}.PROMPT ;; }
  dimension: persona_name { group_label: "Prompt" label: "Persona" sql: ${TABLE}.PERSONA_NAME ;; }
  dimension: stage        { group_label: "Prompt" sql: ${TABLE}.STAGE ;; }
  dimension: is_branded_prompt { group_label: "Prompt" type: yesno sql: ${TABLE}.IS_BRANDED_PROMPT ;; }
  dimension: primary_topic {
    group_label: "Prompt"
    label: "Brand Attribute / Topic"
    description: "First Scrunch key topic of the response"
    sql: ${TABLE}.PRIMARY_TOPIC ;;
  }
  dimension: tags_list {
    group_label: "Prompt"
    label: "Tags"
    description: "Scrunch tags (product tag TUCE/TUCP mapping pending TU)"
    sql: ${TABLE}.TAGS_LIST ;;
  }

  dimension: ai_platform  { group_label: "AI" label: "AI Engine" suggest_explore: ai_platform_suggest suggest_dimension: dim_ai_platform.ai_platform sql: ${TABLE}.AI_PLATFORM ;; }
  dimension: is_top5_ai_platform { group_label: "AI" type: yesno sql: ${TABLE}.IS_TOP5_AI_PLATFORM ;; }
  dimension: country      { group_label: "Market" map_layer_name: countries sql: ${TABLE}.COUNTRY ;; }

  dimension: transunion_status {
    group_label: "TransUnion"
    label: "TU Status"
    sql: ${TABLE}.TRANSUNION_STATUS ;;
    html: {% if value == 'Cited' %}<span style="background:#E7F8EF;color:#067647;padding:3px 10px;border-radius:12px;font-weight:600">● Cited</span>
          {% elsif value == 'Mentioned' %}<span style="background:#FEF6E7;color:#B54708;padding:3px 10px;border-radius:12px;font-weight:600">● Mentioned</span>
          {% else %}<span style="background:#FEECEB;color:#B42318;padding:3px 10px;border-radius:12px;font-weight:600">● Missing</span>{% endif %} ;;
  }
  dimension: transunion_status_value { group_label: "TransUnion" label: "TU Status Value" sql: ${TABLE}.TRANSUNION_STATUS_VALUE ;; }
  dimension: brand_position  { group_label: "TransUnion" label: "TU Position" sql: ${TABLE}.BRAND_POSITION ;; }
  dimension: brand_sentiment { group_label: "TransUnion" label: "TU Sentiment" sql: ${TABLE}.BRAND_SENTIMENT ;; }
  dimension: winner_domain   { group_label: "Citations" sql: ${TABLE}.WINNER_DOMAIN ;; }

  # ---------------- Volume ----------------
  measure: responses {
    group_label: "Volume"
    label: "Responses"
    type: sum
    sql: IFF(${is_cp}, ${TABLE}.RESPONSE_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: prompts_tracked {
    group_label: "Volume"
    type: count_distinct
    sql: IFF(${is_cp}, ${TABLE}.PROMPT_ID, NULL) ;;
  }

  # ---------------- Mentions ----------------
  measure: brand_mentions {
    group_label: "Visibility"
    label: "TU Mentions"
    type: sum
    sql: IFF(${is_cp}, ${TABLE}.BRAND_MENTION_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: brand_mentions_pp {
    group_label: "Visibility · PP"
    label: "TU Mentions (PP)"
    type: sum
    sql: IFF(${is_pp}, ${TABLE}.BRAND_MENTION_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: mention_rate {
    group_label: "Visibility"
    label: "Mention Rate"
    type: number
    sql: ${brand_mentions} / NULLIF(${responses}, 0) ;;
    value_format_name: percent_1
  }

  # ---------------- Citations ----------------
  measure: cited_responses {
    group_label: "Visibility"
    label: "TU Cited Responses"
    type: sum
    sql: IFF(${is_cp}, ${TABLE}.TU_CITED_RESPONSE_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: cited_responses_pp {
    group_label: "Visibility · PP"
    label: "TU Cited Responses (PP)"
    type: sum
    sql: IFF(${is_pp}, ${TABLE}.TU_CITED_RESPONSE_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: citation_rate {
    group_label: "Visibility"
    label: "Citation Rate"
    type: number
    sql: ${cited_responses} / NULLIF(${responses}, 0) ;;
    value_format_name: percent_1
  }

  # ---------------- First mention (top position) ----------------
  measure: top_position_count    { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.TOP_POSITION_COUNT, NULL) ;; }
  measure: top_position_count_pp { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.TOP_POSITION_COUNT, NULL) ;; }
  measure: first_mention_rate {
    group_label: "Visibility"
    label: "First-Mention Rate"
    description: "Share of TU mentions in the top part of the answer"
    type: number
    sql: ${top_position_count} / NULLIF(${brand_mentions}, 0) ;;
    value_format_name: percent_1
  }
  measure: first_mention_rate_pp {
    group_label: "Visibility · PP"
    label: "First-Mention Rate (PP)"
    type: number
    sql: ${top_position_count_pp} / NULLIF(${brand_mentions_pp}, 0) ;;
    value_format_name: percent_1
  }

  # ---------------- Sentiment ----------------
  measure: positive_cnt    { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.POSITIVE_SENTIMENT_COUNT, NULL) ;; }
  measure: negative_cnt    { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.NEGATIVE_SENTIMENT_COUNT, NULL) ;; }
  measure: scored_cnt      { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.SENTIMENT_SCORED_COUNT, NULL) ;; }
  measure: none_cnt        { hidden: yes type: sum sql: IFF(${is_cp} AND ${TABLE}.BRAND_SENTIMENT = 'none', 1, NULL) ;; }
  measure: positive_cnt_pp { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.POSITIVE_SENTIMENT_COUNT, NULL) ;; }
  measure: negative_cnt_pp { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.NEGATIVE_SENTIMENT_COUNT, NULL) ;; }
  measure: scored_cnt_pp   { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.SENTIMENT_SCORED_COUNT, NULL) ;; }
  measure: none_cnt_pp     { hidden: yes type: sum sql: IFF(${is_pp} AND ${TABLE}.BRAND_SENTIMENT = 'none', 1, NULL) ;; }

  measure: net_sentiment {
    group_label: "Sentiment"
    label: "Net Sentiment"
    description: "(positive - negative) / scored responses. 'none' handling via parameter."
    type: number
    sql: (${positive_cnt} - ${negative_cnt})
      / NULLIF(${scored_cnt} {% if sentiment_none_mode._parameter_value == 'exclude' %} - ${none_cnt} {% endif %}, 0) ;;
    value_format_name: percent_1
  }
  measure: net_sentiment_pp {
    group_label: "Sentiment · PP"
    label: "Net Sentiment (PP)"
    type: number
    sql: (${positive_cnt_pp} - ${negative_cnt_pp})
      / NULLIF(${scored_cnt_pp} {% if sentiment_none_mode._parameter_value == 'exclude' %} - ${none_cnt_pp} {% endif %}, 0) ;;
    value_format_name: percent_1
  }
  measure: sentiment_index {
    group_label: "Sentiment"
    label: "Sentiment Index (-1 to +1)"
    description: "Avg sentiment score. Interim for Sentiment Weight Index (definition pending TU)."
    type: average
    sql: IFF(${is_cp}, ${TABLE}.SENTIMENT_SCORE, NULL) ;;
    value_format_name: decimal_2
  }

  # ---------------- Share of voice (overall) ----------------
  measure: competitor_mentions {
    group_label: "Share of Voice"
    type: sum
    sql: IFF(${is_cp}, ${TABLE}.COMPETITOR_MENTION_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: share_of_voice {
    group_label: "Share of Voice"
    label: "TU Share of Voice"
    type: number
    sql: ${brand_mentions} / NULLIF(${brand_mentions} + ${competitor_mentions}, 0) ;;
    value_format_name: percent_1
  }

  # ---------------- Prompt matrix helpers ----------------
  measure: latest_status {
    group_label: "Prompt Matrix"
    label: "Latest TU Status"
    type: string
    sql: MAX_BY(IFF(${is_cp}, ${TABLE}.TRANSUNION_STATUS_VALUE, NULL), IFF(${is_cp}, ${TABLE}.RESPONSE_CREATED_AT, NULL)) ;;
    html: {% if value contains 'Cited' %}<span style="background:#E7F8EF;color:#067647;padding:3px 10px;border-radius:12px;font-weight:600">{{ value }}</span>
          {% elsif value contains 'Mentioned' %}<span style="background:#FEF6E7;color:#B54708;padding:3px 10px;border-radius:12px;font-weight:600">{{ value }}</span>
          {% else %}<span style="background:#FEECEB;color:#B42318;padding:3px 10px;border-radius:12px;font-weight:600">{{ value }}</span>{% endif %} ;;
  }
  measure: top_winner_domain {
    group_label: "Prompt Matrix"
    label: "Winner Domain"
    description: "Most frequent winner domain in the period"
    type: string
    sql: MODE(IFF(${is_cp}, ${TABLE}.WINNER_DOMAIN, NULL)) ;;
  }
}
