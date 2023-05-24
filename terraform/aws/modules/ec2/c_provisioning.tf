resource "null_resource" "wait_for_c_instance" {
  count = var.enable_c_provision ? var.c_number : 0
  provisioner "local-exec" {
    command = "sleep 120"
  }

  depends_on = [aws_instance.controller]
}

resource "null_resource" "ansible_c_inventory_generator" {
  count      = var.enable_c_provision ? var.c_number : 0
  depends_on = [aws_instance.controller]

  provisioner "local-exec" {
    command     = "python3 ./generate_c_inventory.py ${aws_eip.controller[count.index].public_ip} ${aws_instance.controller[count.index].tags_all["Name"]}"
    working_dir = "./modules/ec2/bin"
  }
}

resource "null_resource" "ansible_c_provisioner" {
  count      = var.enable_c_provision ? var.c_number : 0
  depends_on = [null_resource.wait_for_c_instance]

  provisioner "local-exec" {
    command     = "ansible-playbook -i ./terraform/aws/modules/ec2/bin/ansible/hosts-c-${aws_eip.controller[count.index].public_ip} target.yml --private-key=./terraform/aws/modules/ec2/secret_key/jmeter.key"
    working_dir = "./../.."
  }
}