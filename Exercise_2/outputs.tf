# TODO: Define the output variable for the lambda function.

data "aws_lambda_invocation" "greet" {
  function_name = aws_lambda_function.lambda_function.function_name

  input = <<JSON
{
  "key1": "value1",
  "key2": "value2"
}
JSON
}

output "result" {
  description = "String result of Lambda execution"
  value       = data.aws_lambda_invocation.greet.result
}

