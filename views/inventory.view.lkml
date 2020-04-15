view: inventory {
  sql_table_name: anchordemo.Retail_Store.inventory_part ;;

  dimension: department_id {
    type: string
    sql: ${TABLE}.departmentId ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: aisle_id {
    type: string
    sql: ${TABLE}.aisleId ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.productId ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}.storeId ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  set: detail {
    fields: [
      department_id,
      product_name,
      aisle_id,
      product_id,
      sku,
      count,
      store_id,
      timestamp_time
    ]
  }
}
