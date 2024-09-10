variable "function_name" {
  description = "TBD"
  type = string
}

variable "source_dir" {
  description = ""
  type = string
}

# Optionals
variable "runtime" {
  description = "TBD"
  type = string
  default = "python3.11"
}

variable "handler" {
  description = "TBD"
  type = string
  default = "main.handler"
}

variable "timeout" {
  description = ""
  type = number
  default = 15
}

variable "environment_variables" {
  description = ""
  type = map(string)
  default = {}
}