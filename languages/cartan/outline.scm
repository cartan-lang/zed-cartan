(port_declaration
  ["port" "state"] @context
  name: (identifier) @name) @item

(function_definition
  name: (identifier) @name
  parameters: (parameter_list) @context) @item

(binding
  name: (identifier) @name) @item

(agent
  "every" @context) @item
