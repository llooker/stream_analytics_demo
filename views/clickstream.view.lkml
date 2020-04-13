view: clickstream {
  sql_table_name: anchordemo.Retail_Store.clickstream ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: lng {
    type: number
    sql: ${TABLE}.lng ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
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
    sql: ${TABLE}.page_ref ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.sessionId ;;
  }

  dimension: page_target {
    type: string
    sql: ${TABLE}.page_target ;;
  }

  dimension: uid {
    type: number
    sql: ${TABLE}.uid ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${TABLE}.lat ;;
    sql_longitude: ${TABLE}.lng ;;
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
