variable "compartment_id" {
    type = string
}

variable "compartment_state" {
    type = string  
    default = "ACTIVE"
}

variable "compartment_access_level" {
    type = string
    default = "ACCESSIBLE"
  
}

variable "app_tags" {
    type = map(string)  
}

variable "security_list_name" {
    type = string
}

variable "egress_rule" {
    type = list(map(string))
}

variable "tcp_ingress_rule" {
    type = list(map(string))
}

variable "udp_ingress_rule" {
    type = list(map(string))
}

variable "vcn_id" {
    type = string
}
