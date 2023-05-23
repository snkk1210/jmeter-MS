resource "null_resource" "ansible_c_inventory_generator" {
  count      = var.c_number
  depends_on = [aws_instance.controller]

  provisioner "local-exec" {
    command = "python3 ./generate_c_inventory.py ${aws_instance.controller[count.index].public_ip}"
    working_dir = "./modules/ec2/bin"
  }
}