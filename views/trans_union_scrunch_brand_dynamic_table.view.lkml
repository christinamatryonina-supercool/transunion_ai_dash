# =============================================================================

# Scrunch - 1 row per response x brand named in the answer
# DWH.DBO."TransUnion_Scrunch_Brand_Dynamic_Table"
# - TU SOV = TU mentions / all brands' mentions
# - Per-brand SOV in tiles: table calc mentions / sum(mentions)
# =============================================================================

view: scrunch_brand {
  sql_table_name: DWH.DBO."TransUnion_Scrunch_Brand_Dynamic_Table" ;;

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

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.RESPONSE_ID || '|' || ${TABLE}.BRAND_NAME ;;
  }

  dimension_group: report {
    type: time
    label: "Report"
    timeframes: [raw, date, week, month]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.REPORT_DATE ;;
  }

  dimension: brand_name      { group_label: "Brand" label: "Brand" sql: ${TABLE}.BRAND_NAME ;; }
  dimension: is_client_brand { group_label: "Brand" label: "Is TransUnion" type: yesno sql: ${TABLE}.IS_CLIENT_BRAND ;; }
  dimension: brand_domain {
    group_label: "Brand"
    label: "Domain"
    sql: CASE ${TABLE}.BRAND_NAME
           WHEN 'TransUnion'   THEN 'transunion.com'
           WHEN 'Experian'     THEN 'experian.com'
           WHEN 'Equifax'      THEN 'equifax.com'
           WHEN 'Credit Karma' THEN 'creditkarma.com'
           WHEN 'WalletHub'    THEN 'wallethub.com'
           ELSE LOWER(REPLACE(${TABLE}.BRAND_NAME, ' ', '')) || '.com'
         END ;;
  }
  dimension: brand_position  { group_label: "Brand" label: "Position"  sql: ${TABLE}.BRAND_POSITION ;; }
  dimension: brand_sentiment { group_label: "Brand" label: "Sentiment" sql: ${TABLE}.BRAND_SENTIMENT ;; }

  dimension: prompt       { group_label: "Prompt" sql: ${TABLE}.PROMPT ;; }
  dimension: persona_name { group_label: "Prompt" label: "Persona" sql: ${TABLE}.PERSONA_NAME ;; }
  dimension: primary_topic { group_label: "Prompt" label: "Brand Attribute / Topic" sql: ${TABLE}.PRIMARY_TOPIC ;; }
  dimension: ai_platform  { group_label: "AI" label: "AI Engine" suggest_explore: ai_platform_suggest suggest_dimension: dim_ai_platform.ai_platform sql: ${TABLE}.AI_PLATFORM ;; }
  dimension: country      { group_label: "Market" sql: ${TABLE}.COUNTRY ;; }

  measure: mentions {
    label: "Mentions"
    type: sum
    sql: IFF(${is_cp}, ${TABLE}.MENTION_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: tu_mentions    { hidden: yes type: sum sql: IFF(${is_cp} AND ${TABLE}.IS_CLIENT_BRAND, ${TABLE}.MENTION_COUNT, NULL) ;; }
  measure: mentions_pp    { hidden: yes type: sum sql: IFF(${is_pp}, ${TABLE}.MENTION_COUNT, NULL) ;; }
  measure: tu_mentions_pp { hidden: yes type: sum sql: IFF(${is_pp} AND ${TABLE}.IS_CLIENT_BRAND, ${TABLE}.MENTION_COUNT, NULL) ;; }

  measure: tu_share_of_voice {
    label: "TU Share of Voice"
    type: number
    sql: ${tu_mentions} / NULLIF(${mentions}, 0) ;;
    value_format_name: percent_1
  }
  measure: tu_share_of_voice_pp {
    label: "TU Share of Voice (PP)"
    type: number
    sql: ${tu_mentions_pp} / NULLIF(${mentions_pp}, 0) ;;
    value_format_name: percent_1
  }

  measure: top_position_count { hidden: yes type: sum sql: IFF(${is_cp}, ${TABLE}.TOP_POSITION_COUNT, NULL) ;; }
  measure: first_mention_rate {
    label: "First-Mention Rate"
    type: number
    sql: ${top_position_count} / NULLIF(${mentions}, 0) ;;
    value_format_name: percent_1
  }
  measure: sentiment_index {
    label: "Sentiment Index (-1 to +1)"
    type: average
    sql: IFF(${is_cp}, ${TABLE}.SENTIMENT_SCORE, NULL) ;;
    value_format_name: decimal_2
  }

  # ---------------- Granularity (Daily / Weekly / Monthly) ----------------
  parameter: granularity {
    label: "Granularity"
    type: unquoted
    allowed_value: { label: "Daily"   value: "day" }
    allowed_value: { label: "Weekly"  value: "week" }
    allowed_value: { label: "Monthly" value: "month" }
    default_value: "day"
  }

  dimension: report_period_start {
    hidden: yes
    # no type: date on purpose - referenced as a real DATE in report_period / is_partial_period
    sql: {% if granularity._parameter_value == 'week' %} DATEADD(day, 1 - DAYOFWEEKISO(${TABLE}.REPORT_DATE), ${TABLE}.REPORT_DATE)
         {% elsif granularity._parameter_value == 'month' %} DATE_TRUNC('month', ${TABLE}.REPORT_DATE)
         {% else %} ${TABLE}.REPORT_DATE {% endif %} ;;
  }

  dimension: report_period_end {
    hidden: yes
    # no type: date on purpose (see report_period_start)
    sql: {% if granularity._parameter_value == 'week' %} DATEADD(day, 7 - DAYOFWEEKISO(${TABLE}.REPORT_DATE), ${TABLE}.REPORT_DATE)
         {% elsif granularity._parameter_value == 'month' %} LAST_DAY(${TABLE}.REPORT_DATE)
         {% else %} ${TABLE}.REPORT_DATE {% endif %} ;;
  }

  dimension: is_partial_period {
    hidden: yes
    type: yesno
    description: "Week/month not fully inside the Date Range, or not fully loaded yet (ISO weeks, Mon-Sun)"
    sql: {% if granularity._parameter_value == 'day' %} FALSE
         {% else %}
           (   ${report_period_start} < COALESCE({% date_start period %}::DATE, ${report_period_start})
            OR ${report_period_end}   >= COALESCE({% date_end period %}::DATE, DATEADD(day, 1, ${report_period_end}))
            OR ${report_period_end}   >  DATEADD(day, -1, CURRENT_DATE()) )
         {% endif %} ;;
  }

  dimension: report_period_date {
    label_from_parameter: granularity
    description: "Chart axis: day, ISO week start (Mon) or month start, following the Granularity control"
    type: date
    convert_tz: no
    sql: ${report_period_start} ;;
  }

  dimension: report_period {
    label_from_parameter: granularity
    description: "Report date grouped by the Granularity control; partial weeks/months are labelled"
    order_by_field: report_period_start
    sql: {% if granularity._parameter_value == 'week' %} 'Wk of ' || TO_CHAR(${report_period_start}, 'Mon DD')
         {% elsif granularity._parameter_value == 'month' %} TO_CHAR(${report_period_start}, 'Mon YYYY')
         {% else %} TO_CHAR(${report_period_start}, 'Mon DD') {% endif %}
         || IFF(${is_partial_period}, ' (partial)', '') ;;
  }

  # ---------------- KPI cards (generated by dashboard builder - do not edit) ----------------
  measure: kpi_tu_share_of_voice {
    hidden: yes
    group_label: "KPI cards"
    label: "tu_share_of_voice (card)"
    description: "Scorecard version of tu_share_of_voice: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${tu_share_of_voice} ;;
    value_format_name: percent_1
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_brand.tu_share_of_voice_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }
  # ---------------- end KPI cards ----------------
}
