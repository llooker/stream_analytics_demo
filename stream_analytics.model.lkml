connection: "lookerdata"

include: "/views/*.view.lkml"

explore: clickstream {

  join: session_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${clickstream.session_id} = ${session_facts.sessionid} ;;
  }

  join: product_lookup {
    view_label: "Product Info"
    type: left_outer
    relationship: many_to_one
    sql_on: ${clickstream.product_id} = ${product_lookup.id} ;;
  }
}

explore: transaction {}

explore: inventory {}
