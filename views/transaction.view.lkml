view: transaction {
  sql_table_name: anchordemo.Retail_Store.transaction_part ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: product_count {
    type: number
    sql: ${TABLE}.product_count ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}.department_id ;;
  }

  dimension: uid {
    type: number
    sql: ${TABLE}.uid ;;
  }

  dimension: returning {
    type: string
    sql: ${TABLE}.returning ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${price} ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${price} ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}.store_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  set: detail {
    fields: [
      product_count,
      timestamp_time,
      user_id,
      department_id,
      uid,
      returning,
      price,
      store_id,
      product_id,
      order_number
    ]
  }
}
