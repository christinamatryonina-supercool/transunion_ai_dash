# =============================================================================

# UI banner - hero header per dashboard tab (HTML in a single-value tile)
# - TransUnion palette: navy #0A4A6E, teal #00A6CA, yellow #FFE600
# - Wordmark built in HTML (no image)
# - Only plain text + simple blocks: Looker's single-value tile rescales padded
#   elements (pills turned into circles), so no backgrounds / padding on inline text
# =============================================================================

view: ui_banner {
  derived_table: { sql: SELECT 1 AS id ;; }

  dimension: id { primary_key: yes hidden: yes sql: ${TABLE}.id ;; }

  measure: header_exec {
    label: "Header · Executive"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:16px;padding:18px 28px 16px 28px;background:linear-gradient(115deg,#033E5E 0%,#0A4A6E 45%,#00A6CA 100%);text-align:left;font-family:Roboto,Arial,sans-serif;">
        <div style="line-height:24px;">
          <span style="font-size:22px;font-weight:700;color:#FFFFFF;vertical-align:middle;">TransUnion</span><span style="display:inline-block;margin-left:5px;width:20px;height:20px;line-height:20px;border:2px solid #7FD3E6;border-radius:50%;color:#7FD3E6;font-size:10px;font-weight:700;text-align:center;vertical-align:top;">tu</span>
          <span style="font-size:11px;letter-spacing:2px;text-transform:uppercase;color:#7FD3E6;font-weight:700;margin-left:14px;vertical-align:middle;">AI Search &amp; GEO</span>
        </div>
        <div style="width:44px;height:4px;background:#FFE600;border-radius:2px;margin:10px 0 8px 0;"></div>
        <div style="font-size:24px;line-height:30px;font-weight:700;color:#FFFFFF;">Executive Summary</div>
        <div style="font-size:13px;line-height:18px;color:#D6EEF5;margin-top:2px;">TransUnion visibility in AI answers vs competitors, and the traffic it drives.</div>
        <div style="font-size:12px;line-height:18px;font-weight:600;margin-top:6px;"><span style="color:#FFE600;">vs PP = change vs the previous period of the same length</span></div>
      </div> ;;
  }
  measure: header_traffic {
    label: "Header · AI Traffic"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:16px;padding:18px 28px 16px 28px;background:linear-gradient(115deg,#033E5E 0%,#0A4A6E 45%,#00A6CA 100%);text-align:left;font-family:Roboto,Arial,sans-serif;">
        <div style="line-height:24px;">
          <span style="font-size:22px;font-weight:700;color:#FFFFFF;vertical-align:middle;">TransUnion</span><span style="display:inline-block;margin-left:5px;width:20px;height:20px;line-height:20px;border:2px solid #7FD3E6;border-radius:50%;color:#7FD3E6;font-size:10px;font-weight:700;text-align:center;vertical-align:top;">tu</span>
          <span style="font-size:11px;letter-spacing:2px;text-transform:uppercase;color:#7FD3E6;font-weight:700;margin-left:14px;vertical-align:middle;">AI Search &amp; GEO</span>
        </div>
        <div style="width:44px;height:4px;background:#FFE600;border-radius:2px;margin:10px 0 8px 0;"></div>
        <div style="font-size:24px;line-height:30px;font-weight:700;color:#FFFFFF;">AI Traffic &amp; Conversions</div>
        <div style="font-size:13px;line-height:18px;color:#D6EEF5;margin-top:2px;">Visits from AI engines: engagement and conversions.</div>
        <div style="font-size:12px;line-height:18px;font-weight:600;margin-top:6px;"><span style="color:#FFE600;">vs PP = change vs the previous period of the same length</span></div>
      </div> ;;
  }
  measure: header_prompts {
    label: "Header · Prompts"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:16px;padding:18px 28px 16px 28px;background:linear-gradient(115deg,#033E5E 0%,#0A4A6E 45%,#00A6CA 100%);text-align:left;font-family:Roboto,Arial,sans-serif;">
        <div style="line-height:24px;">
          <span style="font-size:22px;font-weight:700;color:#FFFFFF;vertical-align:middle;">TransUnion</span><span style="display:inline-block;margin-left:5px;width:20px;height:20px;line-height:20px;border:2px solid #7FD3E6;border-radius:50%;color:#7FD3E6;font-size:10px;font-weight:700;text-align:center;vertical-align:top;">tu</span>
          <span style="font-size:11px;letter-spacing:2px;text-transform:uppercase;color:#7FD3E6;font-weight:700;margin-left:14px;vertical-align:middle;">AI Search &amp; GEO</span>
        </div>
        <div style="width:44px;height:4px;background:#FFE600;border-radius:2px;margin:10px 0 8px 0;"></div>
        <div style="font-size:24px;line-height:30px;font-weight:700;color:#FFFFFF;">Prompt &amp; Persona Intelligence</div>
        <div style="font-size:13px;line-height:18px;color:#D6EEF5;margin-top:2px;">What consumers ask AI engines, and how each engine describes TransUnion.</div>
        <div style="font-size:12px;line-height:18px;font-weight:600;margin-top:6px;"><span style="color:#6CE9A6;">● Cited</span>&nbsp;&nbsp;&nbsp;<span style="color:#FEC84B;">● Mentioned</span>&nbsp;&nbsp;&nbsp;<span style="color:#FDA29B;">● Missing</span></div>
      </div> ;;
  }

  # ---------------- Dynamic chart titles (follow the Granularity control) ----------------
  parameter: granularity {
    label: "Granularity"
    type: unquoted
    allowed_value: { label: "Daily"   value: "day" }
    allowed_value: { label: "Weekly"  value: "week" }
    allowed_value: { label: "Monthly" value: "month" }
    default_value: "day"
  }

  measure: title_mention_rate {
    hidden: yes
    type: max
    sql: ${TABLE}.id ;;
    html: <div style="text-align:center;font-size:15px;line-height:20px;font-weight:500;color:#1F2937;font-family:Roboto,Arial,sans-serif;">TU Mention Rate · {% if granularity._parameter_value == 'week' %}Weekly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last week may be partial</span>{% elsif granularity._parameter_value == 'month' %}Monthly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last month may be partial</span>{% else %}Daily{% endif %}</div> ;;
  }
  measure: title_ai_sessions {
    hidden: yes
    type: max
    sql: ${TABLE}.id ;;
    html: <div style="text-align:center;font-size:15px;line-height:20px;font-weight:500;color:#1F2937;font-family:Roboto,Arial,sans-serif;">AI Sessions · {% if granularity._parameter_value == 'week' %}Weekly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last week may be partial</span>{% elsif granularity._parameter_value == 'month' %}Monthly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last month may be partial</span>{% else %}Daily{% endif %}</div> ;;
  }
  measure: title_sov {
    hidden: yes
    type: max
    sql: ${TABLE}.id ;;
    html: <div style="text-align:center;font-size:15px;line-height:20px;font-weight:500;color:#1F2937;font-family:Roboto,Arial,sans-serif;">Share of Voice · {% if granularity._parameter_value == 'week' %}Weekly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last week may be partial</span>{% elsif granularity._parameter_value == 'month' %}Monthly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last month may be partial</span>{% else %}Daily{% endif %}</div> ;;
  }
  measure: title_ai_by_engine {
    hidden: yes
    type: max
    sql: ${TABLE}.id ;;
    html: <div style="text-align:center;font-size:15px;line-height:20px;font-weight:500;color:#1F2937;font-family:Roboto,Arial,sans-serif;">AI Sessions by Engine · {% if granularity._parameter_value == 'week' %}Weekly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last week may be partial</span>{% elsif granularity._parameter_value == 'month' %}Monthly<span style="font-size:11px;font-weight:400;color:#98A2B3;">&nbsp;&nbsp;first/last month may be partial</span>{% else %}Daily{% endif %}</div> ;;
  }
}
