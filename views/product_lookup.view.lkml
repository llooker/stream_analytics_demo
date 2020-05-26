view: product_lookup {
  sql_table_name: `anchordemo.Retail_Store.Product_Lookup` ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.ID ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.Name ;;
  }

  dimension: internal_id {
    type: string
    sql: ${TABLE}.InternalID ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.Price ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${price} ;;
  }

  dimension: image {
    type: string
    sql: ${TABLE}.Image ;;
  }

  set: detail {
    fields: [id, name, internal_id, price, image]
  }
}
