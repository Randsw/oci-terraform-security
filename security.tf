
locals {
  ingress_tcp_rule  = (var.tcp_ingress_rule == null) ? [] : var.tcp_ingress_rule
  ingress_udp_rule  = (var.udp_ingress_rule == null) ? [] : var.udp_ingress_rule
}


resource "oci_core_security_list" "app_security_list" {
    compartment_id = var.compartment_id
    vcn_id = var.vcn_id
    display_name = var.security_list_name
    freeform_tags = var.app_tags

    ingress_security_rules {
    // allow ICMP for all type 3 code 4
        protocol = "1"
        source   = "0.0.0.0/0"

        icmp_options {
        type = "3"
        code = "4"
        }
    }

    ingress_security_rules {
    //allow all ICMP from VCN
        protocol = "1"
        source   = "0.0.0.0/0"#var.vcn_cidr

        icmp_options {
        type = "3"
        }
    }
    
    dynamic "egress_security_rules" {
        for_each = var.egress_rule
        content {
            protocol = egress_security_rules.value["protocol"]
            destination = egress_security_rules.value["destination"]
        }
    }

    dynamic "ingress_security_rules" {
        for_each = local.ingress_tcp_rule #var.tcp_ingress_rule
        content {
            protocol = ingress_security_rules.value["protocol"]
            source = ingress_security_rules.value["source"]
            description = ingress_security_rules.value["description"]
            tcp_options {
                max = ingress_security_rules.value["port"]
                min = ingress_security_rules.value["port"]
            }
        }
    }
    dynamic "ingress_security_rules" {
        for_each = local.ingress_udp_rule #var.udp_ingress_rule
        content {
            protocol = ingress_security_rules.value["protocol"]
            source = ingress_security_rules.value["source"]
            description = ingress_security_rules.value["description"]
            udp_options {
                max = ingress_security_rules.value["port"]
                min = ingress_security_rules.value["port"]
            }
        }
    }
}