view: session_facts {
  derived_table: {
    sql: SELECT
        sessionid
        , CAST(MIN(timestamp) AS TIMESTAMP) AS session_start
        , CAST(MAX(timestamp) AS TIMESTAMP) AS session_end
        , COUNT(*) AS number_of_events_in_session
        , SUM(CASE WHEN event = 'browse' THEN 1 ELSE NULL END) AS browse_events
        , SUM(CASE WHEN event = 'add-to-cart' THEN 1 ELSE NULL END) AS cart_events
        , SUM(CASE WHEN event = 'purchase' THEN 1 ELSE NULL end) AS purchase_events
      FROM anchordemo.Retail_Store.clickstream_part
      GROUP BY sessionid
 ;;
  }

  measure: count_of_unique_sessions {
    type: count
    drill_fields: [detail*]
  }

  #####  Basic Web Info  ########

  dimension: sessionid {
    primary_key: yes
    type: string
    sql: ${TABLE}.sessionid ;;
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
  }

  dimension: duration {
    label: "Duration (sec)"
    type: number
    sql: (UNIX_MICROS(${TABLE}.session_end) - UNIX_MICROS(${TABLE}.session_start))/1000000 ;;
  }

  measure: average_duration {
    label: "Average Duration (sec)"
    type: average
    value_format_name: decimal_2
    sql: ${duration} ;;
  }

  dimension: duration_seconds_tier {
    label: "Duration Tier (sec)"
    type: tier
    tiers: [10, 30, 60, 120, 300]
    style: integer
    sql: ${duration} ;;
  }

  #####  Bounce Information  ########

  dimension: is_bounce_session {
    type: yesno
    sql: ${number_of_events_in_session} = 1 ;;
  }

  measure: count_bounce_sessions {
    type: count
    filters: {
      field: is_bounce_session
      value: "Yes"
    }
    drill_fields: [detail*]
  }

  measure: percent_bounce_sessions {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_bounce_sessions} / nullif(${count_of_unique_sessions},0) ;;
  }

  ####### Session by event types included  ########

  dimension: browse_events {
    type: number
    sql: ${TABLE}.browse_events ;;
  }

  dimension: cart_events {
    type: number
    sql: ${TABLE}.cart_events ;;
  }

  dimension: purchase_events {
    type: number
    sql: ${TABLE}.purchase_events ;;
  }

  dimension: number_of_browse_events_in_session {
    type: number
    hidden: yes
    sql: ${TABLE}.browse_events ;;
  }

  dimension: number_of_cart_events_in_session {
    type: number
    hidden: yes
    sql: ${TABLE}.cart_events ;;
  }

  dimension: number_of_purchase_events_in_session {
    type: number
    hidden: yes
    sql: ${TABLE}.purchase_events ;;
  }

  dimension: includes_browse {
    type: yesno
    sql: ${number_of_browse_events_in_session} > 0 ;;
  }

  dimension: includes_cart {
    type: yesno
    sql: ${number_of_cart_events_in_session} > 0 ;;
  }

  dimension: includes_purchase {
    type: yesno
    sql: ${number_of_purchase_events_in_session} > 0 ;;
  }

  dimension: is_abandon_cart_session {
    type: yesno
    sql: ${includes_cart} = 'Yes' AND ${includes_purchase} = 'No' ;;
  }

  measure: count_abandon_cart_session {
    type: count
    filters: [includes_cart: "Yes", includes_purchase: "No"]
  }

  measure: percent_abandon_cart {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_abandon_cart_session} / NULLIF(${count_of_unique_sessions},0) ;;
  }

  measure: count_with_cart {
    type: count
    filters: {
      field: includes_cart
      value: "Yes"
    }
    drill_fields: [detail*]
  }

  measure: count_with_purchase {
    type: count
    filters: {
      field: includes_purchase
      value: "Yes"
    }
    drill_fields: [detail*]
  }

  dimension: number_of_events_in_session {
    type: number
    sql: ${TABLE}.number_of_events_in_session ;;
  }

  ####### Linear Funnel   ########

  dimension: furthest_funnel_step {
    sql: CASE
      WHEN ${number_of_purchase_events_in_session} > 0 THEN '(3) Purchase'
      WHEN ${number_of_cart_events_in_session} > 0 THEN '(2) Add to Cart'
      WHEN ${number_of_browse_events_in_session} > 0 THEN '(1) Browse'
      ELSE 'Land'
      END
       ;;
  }

  measure: count_browse_or_later {
    view_label: "Funnel View"
    label: "(1) Browse or later"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(1) Browse,(2) Add to Cart,(3) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: count_cart_or_later {
    view_label: "Funnel View"
    label: "(2) Add to Cart or later"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(2) Add to Cart,(3) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: count_purchase {
    view_label: "Funnel View"
    label: "(3) Purchase"
    type: count
    filters: {
      field: furthest_funnel_step
      value: "(3) Purchase"
    }
    drill_fields: [detail*]
  }

  measure: cart_to_checkout_conversion {
    view_label: "Funnel View"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_purchase} / nullif(${count_cart_or_later},0) ;;
  }

  measure: overall_conversion {
    view_label: "Funnel View"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_purchase} / nullif(${count_of_unique_sessions},0) ;;
  }

  set: detail {
    fields: [
      sessionid,
      session_start_time,
      session_end_time,
      number_of_events_in_session,
      browse_events,
      cart_events,
      purchase_events
    ]
  }
}
