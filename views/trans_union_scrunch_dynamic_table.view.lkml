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

  # ---------------- PP for Tab 3 cards ----------------
  measure: responses_pp {
    group_label: "Volume · PP"
    label: "Responses (PP)"
    type: sum
    sql: IFF(${is_pp}, ${TABLE}.RESPONSE_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: prompts_tracked_pp {
    group_label: "Volume · PP"
    label: "Prompts Tracked (PP)"
    type: count_distinct
    sql: IFF(${is_pp}, ${TABLE}.PROMPT_ID, NULL) ;;
  }
  measure: mention_rate_pp {
    group_label: "Visibility · PP"
    label: "Mention Rate (PP)"
    type: number
    sql: ${brand_mentions_pp} / NULLIF(${responses_pp}, 0) ;;
    value_format_name: percent_1
  }
  measure: citation_rate_pp {
    group_label: "Visibility · PP"
    label: "Citation Rate (PP)"
    type: number
    sql: ${cited_responses_pp} / NULLIF(${responses_pp}, 0) ;;
    value_format_name: percent_1
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
    type: date
    convert_tz: no
    sql: {% if granularity._parameter_value == 'week' %} DATEADD(day, 1 - DAYOFWEEKISO(${TABLE}.REPORT_DATE), ${TABLE}.REPORT_DATE)
         {% elsif granularity._parameter_value == 'month' %} DATE_TRUNC('month', ${TABLE}.REPORT_DATE)
         {% else %} ${TABLE}.REPORT_DATE {% endif %} ;;
  }

  dimension: report_period_end {
    hidden: yes
    type: date
    convert_tz: no
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
  measure: kpi_brand_mentions {
    hidden: yes
    group_label: "KPI cards"
    label: "brand_mentions (card)"
    description: "Scorecard version of brand_mentions: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${brand_mentions} ;;
    value_format_name: decimal_0
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.brand_mentions_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }

  measure: kpi_cited_responses {
    hidden: yes
    group_label: "KPI cards"
    label: "cited_responses (card)"
    description: "Scorecard version of cited_responses: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${cited_responses} ;;
    value_format_name: decimal_0
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.cited_responses_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }

  measure: kpi_first_mention_rate {
    hidden: yes
    group_label: "KPI cards"
    label: "first_mention_rate (card)"
    description: "Scorecard version of first_mention_rate: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${first_mention_rate} ;;
    value_format_name: percent_1
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.first_mention_rate_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }

  measure: kpi_net_sentiment {
    hidden: yes
    group_label: "KPI cards"
    label: "net_sentiment (card)"
    description: "Scorecard version of net_sentiment: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${net_sentiment} ;;
    value_format_name: percent_1
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.net_sentiment_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }

  measure: kpi_prompts_tracked {
    hidden: yes
    group_label: "KPI cards"
    label: "prompts_tracked (card)"
    description: "Scorecard version of prompts_tracked: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${prompts_tracked} ;;
    value_format_name: decimal_0
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.prompts_tracked_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }

  measure: kpi_mention_rate {
    hidden: yes
    group_label: "KPI cards"
    label: "mention_rate (card)"
    description: "Scorecard version of mention_rate: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${mention_rate} ;;
    value_format_name: percent_1
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.mention_rate_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }

  measure: kpi_citation_rate {
    hidden: yes
    group_label: "KPI cards"
    label: "citation_rate (card)"
    description: "Scorecard version of citation_rate: value + green/red % change vs PP (HTML, cards only)"
    type: number
    sql: ${citation_rate} ;;
    value_format_name: percent_1
    html: <div style="text-align:center;line-height:1.15;"><div style="font-size:36px;font-weight:400;color:#0B2E4F;">{{ rendered_value }}</div><div style="margin-top:8px;">{% assign pp = scrunch_response.citation_rate_pp._value %}{% if pp == null or pp == 0 %}<span style="font-size:13px;color:#667085;">no PP data</span>{% else %}{% assign cur = value | times: 1.0 %}{% assign pct = cur | minus: pp | divided_by: pp | times: 100.0 | round: 1 %}{% if pct >= 0 %}<span style="font-size:15px;font-weight:700;color:#12B76A;">&#9650; {{ pct }}%</span>{% else %}<span style="font-size:15px;font-weight:700;color:#F04438;">&#9660; {{ pct | abs }}%</span>{% endif %}<span style="font-size:13px;color:#667085;"> vs PP</span>{% endif %}</div></div> ;;
  }
  # ---------------- end KPI cards ----------------
}
