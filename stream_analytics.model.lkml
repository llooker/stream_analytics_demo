connection: "lookerdata"

include: "/views/*.view.lkml"

explore: clickstream {

  join: session_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${clickstream.session_id} = ${session_facts.sessionid} ;;
  }
}

explore: transaction {}

explore: inventory {}
