resource "null_resource" "wait_for_w_instance" {
  count      = var.w_number
  provisioner "local-exec" {
    command = "sleep 120"
  }

  depends_on = [aws_instance.worker]
}

resource "null_resource" "ansible_w_inventory_generator" {
  count      = var.w_number
  depends_on = [aws_instance.worker]

  provisioner "local-exec" {
    command = "python3 ./generate_w_inventory.py ${aws_instance.worker[count.index].public_ip} ${aws_instance.worker[count.index].tags_all["Name"]}"
    working_dir = "./modules/ec2/bin"
  }
}

resource "null_resource" "ansible_w_provisioner" {
  count      = var.w_number
  depends_on = [null_resource.wait_for_w_instance]

  provisioner "local-exec" {
    command = "ansible-playbook -i ./terraform/aws/modules/ec2/bin/ansible/hosts-w-${aws_instance.worker[count.index].public_ip} target.yml --private-key=./terraform/aws/modules/ec2/secret_key/jmeter.key"
    working_dir = "./../.."
  }
}