variable "front_lb" {
  type = object({
    name               = string
    internal           = bool
    load_balancer_type = string
    security_groups    = list
    subnets            = list
  })
}
