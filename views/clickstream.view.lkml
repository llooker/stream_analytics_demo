view: clickstream {
  sql_table_name: anchordemo.Retail_Store.clean_clickstream_data ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

###### Location #######

  dimension: lng {
    type: number
    sql: ${TABLE}.lng ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.lat ;;
    sql_longitude: ${TABLE}.lng ;;
  }

  dimension: agent {
    type: string
    sql: ${TABLE}.agent ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: page_ref {
    type: string
    sql: ${TABLE}.pageref ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.sessionId ;;
  }

  measure: count_session_id {
    type: count_distinct
    sql: ${session_id} ;;
  }

  dimension: page_target {
    type: string
    sql: ${TABLE}.pagetarget  ;;
  }

  dimension: product_id {
    type: string
    sql: REGEXP_EXTRACT(${page_target},'P_(.*)')  ;;
  }

  dimension: uid {
    type: number
    sql: ${TABLE}.uid ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.timestamp ;;
  }

  set: detail {
    fields: [
      lng,
      lat,
      agent,
      event,
      page_ref,
      session_id,
      page_target,
      uid,
      timestamp_time,
      location
    ]
  }
}
